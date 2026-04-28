import 'dart:ui';

import '../../core/constant/color_constant.dart';
import '../../domain/models/ticket_model.dart';

Color getStatusColor(TicketStatus status) {
  switch (status) {
    case TicketStatus.open:
      return ThemeColor.orange;
    case TicketStatus.resolved:
      return ThemeColor.green;
    case TicketStatus.escalated:
      return ThemeColor.negative;
  }
}
