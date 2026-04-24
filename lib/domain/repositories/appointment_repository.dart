import '../models/appointment_model.dart';
import '../models/transaction_model.dart';

abstract class AppointmentRepository {
  Future<void> createAppointments({
    required List<AppointmentModel> appointments,
    required bool useCredit,
    required PaymentChannel paymentChannel,
  });

  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
    PaymentChannel paymentChannel,
  );

  Stream<List<AppointmentModel>> watchParentAppointments(String parentId);

  Stream<List<AppointmentModel>> watchTrainerAppointments(String trainerId);
}
