import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/appointment_model.dart';
import '../providers/repository_providers.dart';

final parentAppointmentsStreamProvider =
    StreamProvider.family<List<AppointmentModel>, String>((ref, parentId) {
      final repository = ref.read(appointmentRepositoryProvider);
      return repository.watchParentAppointments(parentId);
    });
