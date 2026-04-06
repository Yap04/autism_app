import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/appointment_model.dart';
import '../../domain/models/user_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'appointment_notifier.g.dart';

@riverpod
class AppointmentNotifier extends _$AppointmentNotifier {
  @override
  Stream<List<AppointmentModel>> build() {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.value;

    if (user == null) {
      return Stream.value([]);
    }

    final repo = ref.watch(appointmentRepositoryProvider);

    if (user.role == UserRole.trainer) {
      return repo.watchTrainerAppointments(user.id);
    } else {
      return repo.watchParentAppointments(user.id);
    }
  }

  Future<void> createAppointment({
    required String trainerId,
    required String trainerName,
    required String sport,
    required String location,
    required DateTime dateTime,
    required PaymentMethod paymentMethod,
    required int recurringWeeks,
  }) async {
    final user = await ref.read(authNotifierProvider.future);
    if (user == null) {
      throw Exception('Please login first');
    }

    if (paymentMethod == PaymentMethod.credit &&
        user.sessionCredits < recurringWeeks) {
      throw Exception('Not enough credits. Please top up your credits.');
    }

    try {
      final recurringGroupId =
          recurringWeeks > 1
              ? 'group_${DateTime.now().millisecondsSinceEpoch}'
              : null;

      final appointmentsToCreate = <AppointmentModel>[];

      for (var i = 0; i < recurringWeeks; i++) {
        final sessionDate = dateTime.add(Duration(days: 7 * i));

        appointmentsToCreate.add(
          AppointmentModel(
            id: '',
            parentId: user.id,
            parentName: user.name,
            trainerId: trainerId,
            trainerName: trainerName,
            sport: sport,
            location: location,
            dateTime: sessionDate,
            status: AppointmentStatus.pending,
            createdAt: DateTime.now(),
            paymentMethod: paymentMethod,
            paymentStatus: PaymentStatus.paid,
            recurringGroupId: recurringGroupId,
            sequenceInfo:
                recurringWeeks > 1 ? '${i + 1}/$recurringWeeks' : null,
          ),
        );
      }
      await ref
          .read(appointmentRepositoryProvider)
          .createAppointments(
            appointments: appointmentsToCreate,
            useCredit: paymentMethod == PaymentMethod.credit,
          );
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<void> updateStatus(
    String appointmentId,
    AppointmentStatus newStatus,
  ) async {
    try {
      await ref
          .read(appointmentRepositoryProvider)
          .updateAppointmentStatus(appointmentId, newStatus);
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }
}
