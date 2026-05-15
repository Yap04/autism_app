import '../../domain/models/appointment_model.dart';

class SlaService {
  static const double penaltyRate = 0.3;
  static const int travelPenaltyHours = 4;

  static Map<String, dynamic> calculateCancellation(AppointmentModel appt) {
    final now = DateTime.now();
    final hoursUntilSession = appt.dateTime.difference(now).inHours;

    final totalPaid = appt.amount;
    final transportFee = appt.transportFee;

    final isCredit = appt.paymentMethod == PaymentMethod.credit;

    final creditsUsed = appt.duration ~/ 60;

    // 1. Handle pending sessions: Full refund, no penalty
    if (appt.status == AppointmentStatus.pending) {
      return {
        'isFree': true,
        'refundAmount':
            isCredit ? creditsUsed.toDouble() : (totalPaid + transportFee),
        'trainerCompensation': 0.0,
        'message':
            isCredit
                ? 'Request cancelled: $creditsUsed Session Credit(s) refunded.'
                : 'Request cancelled: Full refund (RM ${(totalPaid + transportFee).toStringAsFixed(2)}) initiated.',
      };
    }

    // 2. Cancel before 24 hours
    if (hoursUntilSession >= 24) {
      return {
        'isFree': true,
        'refundAmount':
            isCredit ? creditsUsed.toDouble() : (totalPaid + transportFee),
        'trainerCompensation': 0.0,
        'message':
            isCredit
                ? 'More than 24h notice: $creditsUsed Session Credit(s) will be refunded.'
                : 'More than 24h notice: Full refund (including travel fee) to your original payment method.',
      };
    }

    // 3. Cancel within 24 hours
    final penalty = totalPaid * penaltyRate;

    if (isCredit) {
      // Credit Logic: Forfeit credit, refund 0, but platform compensate the trainer
      return {
        'isFree': false,
        'refundAmount': 0.0,
        'trainerCompensation': penalty,
        'message':
            'Less than 24h notice: $creditsUsed Session Credit(s) forfeited. The coach will be compensated.',
      };
    } else {
      // Cancel 4 hours before the session starts
      if (hoursUntilSession < travelPenaltyHours && transportFee > 0) {
        final refund = totalPaid - penalty;
        final trainerComp = penalty + transportFee;

        return {
          'isFree': false,
          'refundAmount': refund,
          'trainerCompensation': trainerComp,
          'message':
              "Less than 24h notice: 30% (RM ${penalty.toStringAsFixed(2)}) will be deducted to compensate the coach's time.",
        };
      } else {
        // Cancel before 4 hours before the session starts
        final refund = (totalPaid - penalty) + transportFee;

        return {
          'isFree': false,
          'refundAmount': refund,
          'trainerCompensation': penalty,
          'message':
              transportFee > 0
                  ? 'Less than 24h notice: 30% (RM ${penalty.toStringAsFixed(2)}) deducted. Travel Fee is fully refunded.'
                  : 'Less than 24h notice: 30% (RM ${penalty.toStringAsFixed(2)}) will be deducted.',
        };
      }
    }
  }
}
