import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/appointment_model.dart';
import '../../domain/models/credit_transaction_model.dart';
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

        final txRef = _firestore.collection('creditTransactions').doc();
        final tx = CreditTransactionModel(
          id: txRef.id,
          parentId: parentId,
          type: TransactionType.deduct,
          amount: -totalDeduct,
          relatedAppointmentId: firstAppId,
          description:
              'Booked ${appointments.length} ${appointments.first.sport} session(s) with ${appointments.first.trainerName}',
          createdAt: DateTime.now(),
        );
        batch.set(txRef, tx.toJson());
      }
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
      await _appointmentsRef.doc(appointmentId).update({'status': status.name});
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
