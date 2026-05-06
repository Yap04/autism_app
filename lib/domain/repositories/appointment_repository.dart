import '../models/appointment_model.dart';
import '../models/transaction_model.dart';

abstract class AppointmentRepository {
  Future<void> createAppointments({
    required List<AppointmentModel> appointments,
    required bool useCredit,
    required PaymentChannel paymentChannel,
    String? stripePaymentIntentId,
  });

  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  );

  Future<AppointmentModel?> getAppointmentById(String appointmentId);

  Stream<List<AppointmentModel>> watchParentAppointments(String parentId);

  Stream<List<AppointmentModel>> watchTrainerAppointments(String trainerId);

  Stream<List<AppointmentModel>> watchAllAppointments();

  Future<void> rescheduleAppointment(
    String appointmentId,
    DateTime newDateTime,
  );

  Future<void> cancelAppointment({
    required String appointmentId,
    required String parentId,
    required String trainerId,
    required double refundAmount,
    required double trainerCompensation,
    required bool isMeltdownGrace,
    required String cancelledBy,
  });
}
