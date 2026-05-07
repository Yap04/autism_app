class CommissionService {
  static const int masterCoachThreshold =
      30; // Complete 30 Sessions to become master coach
  static const double standardRate = 0.20; // Standard commission: 20%
  static const double masterRate = 0.10; // Master commission: 10%

  /// Calculates the commission and trainer's net earnings for a single session
  static Map<String, dynamic> calculateEarnings({
    required double sessionAmount,
    required int completedSessions,
  }) {
    // Determine if the user is a Master Coach
    final isMasterCoach = completedSessions >= masterCoachThreshold;

    // Determine the current commission rate
    final takeRate = isMasterCoach ? masterRate : standardRate;

    // Calculate platform fee and trainer's actual earnings
    final platformFee = sessionAmount * takeRate;
    final trainerEarning = sessionAmount - platformFee;

    return {
      'isMasterCoach': isMasterCoach,
      'takeRate': takeRate,
      'takeRatePercentage': '${(takeRate * 100).toInt()}%',
      'platformFee': platformFee,
      'trainerEarning': trainerEarning,
    };
  }
}
