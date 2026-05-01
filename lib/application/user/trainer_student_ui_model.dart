import '../../domain/models/appointment_model.dart';
import '../../domain/models/child_model.dart';

class TrainerStudentUIModel {
  TrainerStudentUIModel({
    required this.child,
    required this.latestBooking,
    required this.status,
    required this.hasPendingBooking,
  });
  final ChildModel child;
  final AppointmentModel latestBooking;
  final String status;
  final bool hasPendingBooking;
}
