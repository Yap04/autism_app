import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/appointment_model.dart';
import '../../domain/models/child_model.dart';
import '../../domain/models/user_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';
import 'trainer_student_ui_model.dart';

part 'trainer_provider.g.dart';

@riverpod
Future<List<UserModel>> trainerList(TrainerListRef ref) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: UserRole.trainer.name)
            .where('status', isEqualTo: UserStatus.active.name)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return UserModel.fromJson(data);
    }).toList();
  } catch (e) {
    throw Exception('Failed to Fetch Trainer List: $e');
  }
}

@riverpod
Future<List<TrainerStudentUIModel>> trainerStudents(
  TrainerStudentsRef ref,
) async {
  final currentUser = ref.watch(authNotifierProvider).value;
  if (currentUser == null) return [];
  final trainerId = currentUser.id;

  final firestore = FirebaseFirestore.instance;

  final appointmentsSnap =
      await firestore
          .collection('appointments')
          .where('trainerId', isEqualTo: trainerId)
          .orderBy('createdAt', descending: true)
          .get();

  if (appointmentsSnap.docs.isEmpty) {
    return [];
  }

  final allAppointments =
      appointmentsSnap.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();

  final appointmentsByChild = <String, List<AppointmentModel>>{};
  for (final appt in allAppointments) {
    appointmentsByChild.putIfAbsent(appt.childId, () => []).add(appt);
  }

  final uiModels = <TrainerStudentUIModel>[];

  for (final entry in appointmentsByChild.entries) {
    final childId = entry.key;
    final childAppointments = entry.value;

    final latestAppt = childAppointments.first;

    final childDoc = await firestore.collection('children').doc(childId).get();
    if (!childDoc.exists) {
      continue;
    }

    final childData = childDoc.data()!;
    childData['id'] = childDoc.id;
    final child = ChildModel.fromJson(childData);

    final hasActive = childAppointments.any(
      (a) => a.status == AppointmentStatus.accepted,
    );
    final hasPending = childAppointments.any(
      (a) => a.status == AppointmentStatus.pending,
    );

    String uiStatus;
    if (hasActive) {
      uiStatus = 'active';
    } else if (hasPending) {
      uiStatus = 'pending';
    } else {
      uiStatus = 'past';
    }

    uiModels.add(
      TrainerStudentUIModel(
        child: child,
        latestBooking: latestAppt,
        status: uiStatus,
        hasPendingBooking: hasPending,
      ),
    );
  }

  return uiModels;
}

@riverpod
Future<UserModel?> fetchTrainer(FetchTrainerRef ref, String trainerId) async {
  if (trainerId.isEmpty) {
    return null;
  }
  return ref.watch(userRepositoryProvider).getUserById(trainerId);
}

@riverpod
Future<List<UserModel>> pendingTrainers(PendingTrainersRef ref) async {
  return ref.watch(userRepositoryProvider).getPendingTrainers();
}
