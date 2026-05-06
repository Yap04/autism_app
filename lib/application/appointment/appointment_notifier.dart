import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/appointment_model.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/models/user_model.dart';
import '../../infrastructure/services/remote_notification_service.dart';
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
    required String childId,
    required String childName,
    required String trainerId,
    required String trainerName,
    required String sport,
    required String location,
    required DateTime dateTime,
    required PaymentMethod paymentMethod,
    required int recurringWeeks,
    required int duration,
    required SessionType sessionType,
    String? stripePaymentIntentId,
    String? childAvatarUrl,
  }) async {
    final user = await ref.read(authNotifierProvider.future);
    if (user == null) {
      throw Exception('Please login first');
    }

    if (paymentMethod == PaymentMethod.credit &&
        user.sessionCredits < recurringWeeks) {
      throw Exception('Not enough credits. Please top up your credits.');
    }

    if (paymentMethod == PaymentMethod.singlePay &&
        stripePaymentIntentId == null) {
      throw Exception('Payment Intent ID is required for Stripe payments.');
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
            parentName: user.name ?? user.nickname ?? 'Unknown User',
            parentAvatarUrl: user.userAvatarUrl,
            childId: childId,
            childName: childName,
            childAvatarUrl: childAvatarUrl,
            trainerId: trainerId,
            trainerName: trainerName,
            sport: sport,
            location: location,
            duration: duration,
            sessionType: sessionType,
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
            paymentChannel:
                paymentMethod == PaymentMethod.credit
                    ? PaymentChannel.credit
                    : PaymentChannel.stripe,
            stripePaymentIntentId: stripePaymentIntentId,
          );

      try {
        final trainerToken = await ref
            .read(userRepositoryProvider)
            .getUserFcmToken(trainerId);

        if (trainerToken != null && trainerToken.isNotEmpty) {
          await RemoteNotificationService.notifyOtherUser(
            targetFcmToken: trainerToken,
            title: 'New Booking Reminder 📅',
            body:
                '${user.name ?? 'A parent'} has booked a new $sport session for $childName!',
          );
        }
      } catch (e) {
        print(
          'Failed to send remote notification to trainer, but appointment was saved: $e',
        );
      }

      for (final appt in appointmentsToCreate) {
        await scheduleRemindersForAppointment(appt);
      }
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<void> updateStatus(
    String appointmentId,
    AppointmentStatus newStatus,
    PaymentChannel paymentChannel,
  ) async {
    try {
      await ref
          .read(appointmentRepositoryProvider)
          .updateAppointmentStatus(appointmentId, newStatus);
      try {
        final appointment = await ref
            .read(appointmentRepositoryProvider)
            .getAppointmentById(appointmentId);

        if (appointment != null) {
          final parentToken = await ref
              .read(userRepositoryProvider)
              .getUserFcmToken(appointment.parentId);

          if (parentToken != null && parentToken.isNotEmpty) {
            var title = '';
            var body = '';

            if (newStatus == AppointmentStatus.accepted) {
              title = 'Appointment Confirmed ✅';
              body =
                  'Trainer ${appointment.trainerName} has accepted your ${appointment.sport} booking.';
            } else if (newStatus == AppointmentStatus.rejected ||
                newStatus == AppointmentStatus.cancelled) {
              title = 'Appointment Rejected/Cancelled ❌';
              body =
                  'Unfortunately, Trainer ${appointment.trainerName} is unable to accept your ${appointment.sport} booking.';
            }

            if (title.isNotEmpty) {
              await RemoteNotificationService.notifyOtherUser(
                targetFcmToken: parentToken,
                title: title,
                body: body,
              );
            }
          }
        }
      } catch (e) {
        print('Status updated successfully, but failed to notify parent: $e');
      }
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }

  Future<void> scheduleRemindersForAppointment(
    AppointmentModel appointment,
  ) async {
    if (kIsWeb) {
      return;
    }

    final notificationService = ref.read(notificationServiceProvider);
    final notificationId = appointment.dateTime.millisecondsSinceEpoch
        .remainder(100000);

    final now = DateTime.now();
    final reminderTime = appointment.dateTime.subtract(
      const Duration(hours: 2),
    );

    if (reminderTime.isAfter(now)) {
      await notificationService.scheduleAppointmentReminder(
        notificationId: notificationId,
        title: 'Training Reminder! 🏃‍♂️',
        body:
            'Your ${appointment.sport} session with ${appointment.trainerName} starts at ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}. Get ready!',
        scheduledTime: reminderTime,
      );
    } else if (appointment.dateTime.isAfter(now)) {
      await notificationService.showImmediateAppointmentReminder(
        notificationId: notificationId,
        title: 'Urgent: Training Soon! 🏃‍♂️',
        body:
            'Your ${appointment.sport} session is starting very soon at ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}!',
      );
    }
  }

  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDateTime,
  }) async {
    try {
      await ref
          .read(appointmentRepositoryProvider)
          .rescheduleAppointment(appointmentId, newDateTime);

      try {
        final currentUser = ref.read(authNotifierProvider).value;

        final appointment = await ref
            .read(appointmentRepositoryProvider)
            .getAppointmentById(appointmentId);

        if (currentUser != null && appointment != null) {
          String targetUserId;
          const title = 'Appointment Rescheduled 🔄';
          var body = '';

          final timeString =
              '${newDateTime.hour}:${newDateTime.minute.toString().padLeft(2, '0')}';
          final dateString = '${newDateTime.day}/${newDateTime.month}';

          // parent reschedule
          if (currentUser.id == appointment.parentId) {
            targetUserId = appointment.trainerId;
            body =
                'The parent requests to reschedule the ${appointment.sport} session to $dateString at $timeString.';
          }
          // trainer reschedule
          else {
            targetUserId = appointment.parentId;
            body =
                'Trainer ${appointment.trainerName} requests to reschedule the ${appointment.sport} session to $dateString at $timeString.';
          }

          final targetToken = await ref
              .read(userRepositoryProvider)
              .getUserFcmToken(targetUserId);

          if (targetToken != null && targetToken.isNotEmpty) {
            await RemoteNotificationService.notifyOtherUser(
              targetFcmToken: targetToken,
              title: title,
              body: body,
            );
          }

          // update local notification
          final updatedAppointment = appointment.copyWith(
            dateTime: newDateTime,
            status: AppointmentStatus.pending,
          );
          await scheduleRemindersForAppointment(updatedAppointment);
        }
      } catch (e) {
        print('⚠️ Reschedule successful, but notification failed: $e');
      }
    } catch (e) {
      throw Exception('Failed to reschedule: $e');
    }
  }
}
