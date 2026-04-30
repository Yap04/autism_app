import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/appointment_model.dart';
import '../providers/repository_providers.dart';

part 'appointment_provider.g.dart';

@riverpod
Stream<List<AppointmentModel>> parentAppointmentsStream(
  ParentAppointmentsStreamRef ref,
  String parentId,
) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.watchParentAppointments(parentId);
}
