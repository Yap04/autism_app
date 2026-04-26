import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/appointment_model.dart';
import '../../providers/repository_providers.dart';

final allAppointmentsStreamProvider =
    StreamProvider.autoDispose<List<AppointmentModel>>((ref) {
      final repository = ref.read(appointmentRepositoryProvider);
      return repository.watchAllAppointments();
    });

final appointmentFilterProvider = StateProvider<String>((ref) => 'All');
