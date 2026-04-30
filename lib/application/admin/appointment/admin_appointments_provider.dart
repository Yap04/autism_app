import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/appointment_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_appointments_provider.g.dart';

@riverpod
Stream<List<AppointmentModel>> allAppointmentsStream(AllAppointmentsStreamRef ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.watchAllAppointments();
}

@riverpod
class AppointmentFilter extends _$AppointmentFilter {
  @override
  String build() {
    return 'All';
  }

  void updateFilter(String newFilter) {
    state = newFilter;
  }
}
