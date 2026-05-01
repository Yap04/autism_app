import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/models/appointment_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../services/stripe_service.dart';

class FirebaseAppointmentRepository implements AppointmentRepository {
  FirebaseAppointmentRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointmentsRef =>
      _firestore.collection('appointments');

  @override
  Future<void> createAppointments({
    required List<AppointmentModel> appointments,
    required bool useCredit,
    required PaymentChannel paymentChannel,
    String? stripePaymentIntentId,
  }) async {
    final batch = _firestore.batch();

    try {
      if (appointments.isEmpty) {
        return;
      }

      final parentId = appointments.first.parentId;
      String? firstAppId;

      for (final app in appointments) {
        final appDocRef = _appointmentsRef.doc();
        firstAppId ??= appDocRef.id;
        final newAppointment = app.copyWith(id: appDocRef.id);
        batch.set(appDocRef, newAppointment.toJson());
      }

      if (useCredit) {
        final totalDeduct = appointments.length;
        final userRef = _firestore.collection('users').doc(parentId);
        batch.update(userRef, {
          'sessionCredits': FieldValue.increment(-totalDeduct),
        });
      }

      final txRef =
          _firestore
              .collection('users')
              .doc(parentId)
              .collection('transactions')
              .doc();

      final description =
          'Booked ${appointments.length} ${appointments.first.sport} session(s) with ${appointments.first.trainerName}';

      //todo: assuming that RM80 for each session
      final txAmount =
          useCredit
              ? -appointments.length.toDouble()
              : -80.0 * appointments.length;

      final tx = TransactionModel(
        id: txRef.id,
        parentId: parentId,
        type: useCredit ? TransactionType.deduct : TransactionType.payment,
        paymentChannel: paymentChannel,
        amount: txAmount,
        relatedAppointmentId: firstAppId,
        description: description,
        createdAt: DateTime.now(),
        status: TransactionStatus.pending,
        stripePaymentIntentId: stripePaymentIntentId,
      );
      batch.set(txRef, tx.toJson());

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  @override
  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    try {
      String? stripePaymentIntentIdToRefund;

      await _firestore.runTransaction((transaction) async {
        final appRef = _appointmentsRef.doc(appointmentId);
        final appSnapshot = await transaction.get(appRef);

        if (!appSnapshot.exists) {
          throw Exception('Appointment not found');
        }

        final appData = appSnapshot.data()!;
        if (appData['status'] == status.name) {
          return;
        }

        transaction.update(appRef, {'status': status.name});

        final isCreditUsed = appData['paymentMethod'] == 'credit';
        final parentId = appData['parentId'] as String;
        final trainerId = appData['trainerId'] as String;

        final paymentChannel =
            isCreditUsed ? PaymentChannel.credit : PaymentChannel.stripe;

        final transactionsQuery =
            await _firestore
                .collection('users')
                .doc(parentId)
                .collection('transactions')
                .where('relatedAppointmentId', isEqualTo: appointmentId)
                .limit(1)
                .get();

        DocumentReference? originalTxRef;
        // if pay by credit, refund 1 credit, or else RM80
        var refundAmount = isCreditUsed ? 1.0 : 80.0;

        if (transactionsQuery.docs.isNotEmpty) {
          originalTxRef = transactionsQuery.docs.first.reference;
          final txData = transactionsQuery.docs.first.data();

          if (!isCreditUsed) {
            stripePaymentIntentIdToRefund =
                txData['stripePaymentIntentId'] as String?;
          }

          final originalAmount = (txData['amount'] as num?)?.toDouble() ?? 0.0;

          if (originalAmount != 0) {
            refundAmount = originalAmount.abs();
          }
        }

        if (status == AppointmentStatus.completed) {
          if (originalTxRef != null) {
            transaction.update(originalTxRef, {
              'status': TransactionStatus.completed.name,
            });
          }

          // release money to trainer
          final duration = (appData['duration'] as num?)?.toInt() ?? 60;
          final amountToEarn = (duration / 60) * 80.0;

          final earningTxRef =
              _firestore
                  .collection('users')
                  .doc(trainerId)
                  .collection('transactions')
                  .doc();

          final earningTx = TransactionModel(
            id: earningTxRef.id,
            parentId: trainerId,
            type: TransactionType.earning,
            paymentChannel: PaymentChannel.credit,
            amount: amountToEarn,
            description:
                'Earnings for ${appData['sport']} session with ${appData['childName']}',
            createdAt: DateTime.now(),
            relatedAppointmentId: appointmentId,
          );

          transaction.set(earningTxRef, earningTx.toJson());
        }

        if (status == AppointmentStatus.rejected ||
            status == AppointmentStatus.cancelled) {
          if (isCreditUsed) {
            final userRef = _firestore.collection('users').doc(parentId);
            transaction.update(userRef, {
              'sessionCredits': FieldValue.increment(refundAmount.toInt()),
            });
          }

          if (originalTxRef != null) {
            transaction.update(originalTxRef, {
              'status': TransactionStatus.refunded.name,
              'description': '${appData['sport']} Session (Refunded)',
            });
          }

          final newTxRef =
              _firestore
                  .collection('users')
                  .doc(parentId)
                  .collection('transactions')
                  .doc();

          final refundDescription =
              status == AppointmentStatus.cancelled
                  ? 'Refund: Cancelled by Admin'
                  : 'Refund: Rejected by Trainer';

          final refundTx = TransactionModel(
            id: newTxRef.id,
            parentId: parentId,
            type: TransactionType.refund,
            paymentChannel: paymentChannel,
            amount: refundAmount,
            description: refundDescription,
            createdAt: DateTime.now(),
            relatedAppointmentId: appointmentId,
          );

          transaction.set(newTxRef, refundTx.toJson());
        }
      });

      if (stripePaymentIntentIdToRefund != null &&
          (status == AppointmentStatus.rejected ||
              status == AppointmentStatus.cancelled)) {
        debugPrint(
          'Initiating Stripe refund for: $stripePaymentIntentIdToRefund',
        );

        final refundSuccess = await StripeService().refundStripePayment(
          stripePaymentIntentIdToRefund!,
        );

        if (!refundSuccess) {
          debugPrint(
            'CRITICAL: Stripe refund API call failed! Manual intervention required.',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }

  @override
  Stream<List<AppointmentModel>> watchParentAppointments(String parentId) {
    return _appointmentsRef
        .where('parentId', isEqualTo: parentId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Stream<List<AppointmentModel>> watchTrainerAppointments(String trainerId) {
    return _appointmentsRef
        .where('trainerId', isEqualTo: trainerId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Stream<List<AppointmentModel>> watchAllAppointments() {
    return _firestore
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppointmentModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  ) async {
    try {
      await _appointmentsRef.doc(appointmentId).update({
        'dateTime': Timestamp.fromDate(newDateTime),
        'status': AppointmentStatus.pending.name,
      });
    } catch (e) {
      throw Exception('Failed to reschedule appointment: $e');
    }
  }
}
