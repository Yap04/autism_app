import 'package:flutter/widgets.dart';
import '../../domain/models/appointment_model.dart';
import 'localization_ext.dart';

extension AppointmentStatusExt on AppointmentStatus {
  String toLocalized(BuildContext context) {
    return switch (this) {
      AppointmentStatus.pending => context.l10n.statusPending,
      AppointmentStatus.accepted => context.l10n.statusAccepted,
      AppointmentStatus.completed => context.l10n.statusCompleted,
      AppointmentStatus.cancelled => context.l10n.statusCancelled,
      AppointmentStatus.rejected => context.l10n.statusRejected,
    };
  }
}
