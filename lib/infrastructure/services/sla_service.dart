import '../../domain/models/appointment_model.dart';

class SlaService {
  static const double penaltyRate = 0.3;

  static Map<String, dynamic> calculateCancellation(AppointmentModel appt) {
    final now = DateTime.now();
    final hoursUntilSession = appt.dateTime.difference(now).inHours;
    final totalPaid = appt.amount;

    final isCredit = appt.paymentMethod == PaymentMethod.credit;

    // 1. Cancel before 24 hours
    if (hoursUntilSession >= 24) {
      return {
        'isFree': true,
        'refundAmount': isCredit ? 1.0 : totalPaid,
        'trainerCompensation': 0.0,
        'message':
            isCredit
                ? 'More than 24h notice: 1 Session Credit will be refunded.'
                : 'More than 24h notice: Full refund to your original payment method.',
      };
    }

    // 2. Cancel within 24 hours
    final penalty = totalPaid * penaltyRate;

    if (isCredit) {
      // 🚀 Credit Logic: Forfeit credit, refund 0, but platform compensate the trainer
      return {
        'isFree': false,
        'refundAmount': 0.0,
        'trainerCompensation': penalty,
        'message':
            'Less than 24h notice: 1 Session Credit is forfeited. The coach will be compensated for their reserved time.',
      };
    } else {
      final refund = totalPaid - penalty;
      return {
        'isFree': false,
        'refundAmount': refund,
        'trainerCompensation': penalty,
        'message':
            "Less than 24h notice: 30% (RM ${penalty.toStringAsFixed(2)}) will be deducted to compensate the coach's time.",
      };
    }
  }
}
