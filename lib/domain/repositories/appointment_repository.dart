import '../models/appointment_model.dart';

abstract class AppointmentRepository {
  Future<void> createAppointments({
    required List<AppointmentModel> appointments,
    required bool useCredit,
  });

  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  );

  Stream<List<AppointmentModel>> watchParentAppointments(String parentId);

  Stream<List<AppointmentModel>> watchTrainerAppointments(String trainerId);
}
