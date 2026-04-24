import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/appointment_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/appointment_repository.dart';

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

      final tx = CreditTransactionModel(
        id: txRef.id,
        parentId: parentId,
        type: useCredit ? TransactionType.deduct : TransactionType.payment,
        paymentChannel: paymentChannel,
        amount: txAmount,
        relatedAppointmentId: firstAppId,
        description: description,
        createdAt: DateTime.now(),
        status: TransactionStatus.pending,
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
    PaymentChannel paymentChannel,
  ) async {
    try {
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

        final transactionsQuery =
            await _firestore
                .collection('users')
                .doc(parentId)
                .collection('transactions')
                .where('relatedAppointmentId', isEqualTo: appointmentId)
                .limit(1)
                .get();

        DocumentReference? originalTxRef;
        if (transactionsQuery.docs.isNotEmpty) {
          originalTxRef = transactionsQuery.docs.first.reference;
        }

        if (status == AppointmentStatus.accepted && originalTxRef != null) {
          transaction.update(originalTxRef, {
            'status': TransactionStatus.completed.name,
          });
        }

        if (status == AppointmentStatus.rejected && isCreditUsed) {
          final userRef = _firestore.collection('users').doc(parentId);
          transaction.update(userRef, {
            'sessionCredits': FieldValue.increment(1),
          });

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
          final refundTx = CreditTransactionModel(
            id: newTxRef.id,
            parentId: parentId,
            type: TransactionType.refund,
            paymentChannel: paymentChannel,
            amount: 1,
            description: 'Refund: Rejected by trainer',
            createdAt: DateTime.now(),
            relatedAppointmentId: appointmentId,
          );
          transaction.set(newTxRef, refundTx.toJson());
        }
      });
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
}
