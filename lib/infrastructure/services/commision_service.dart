import '../../domain/models/fees_config_model.dart';

class CommissionService {
  // Calculates the commission and trainer's net earnings for a single session
  static Map<String, dynamic> calculateEarnings({
    required double sessionAmount,
    required double transportFee,
    required int completedSessions,
    required FeesConfigModel config,
  }) {
    final masterCoachThreshold = config.commThreshold;
    final standardRate = config.commStandardRate;
    final masterRate = config.commMasterRate;

    // Determine if the user is a Master Coach
    final isMasterCoach = completedSessions >= masterCoachThreshold;

    // Determine the current commission rate
    final takeRate = isMasterCoach ? masterRate : standardRate;

    // Calculate platform fee and trainer's actual earnings
    final platformFee = sessionAmount * takeRate;
    final trainerEarning = (sessionAmount - platformFee) + transportFee;

    return {
      'isMasterCoach': isMasterCoach,
      'takeRate': takeRate,
      'takeRatePercentage': '${(takeRate * 100).toInt()}%',
      'platformFee': platformFee,
      'trainerEarning': trainerEarning,
    };
  }
}
