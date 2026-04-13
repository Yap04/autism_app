import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/user_model.dart';
import 'user_avatar.dart';

class TrainerCard extends StatelessWidget {
  const TrainerCard({required this.trainer, super.key});
  final UserModel trainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                radius: 36,
                userAvatarUrl: trainer.userAvatarUrl,
                username: trainer.name ?? trainer.nickname,
                fontSize: 28,
              ),
              16.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trainer.name ??
                                trainer.nickname ??
                                'Unknown Trainer',
                            style: AppWidget.bodyLarge().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' 4.9',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    4.heightBox,
                    Text(
                      'Experienced in autism sports training...',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.heightBox,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.aquaBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Available',
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.heightBox,
          Text(
            'Specialized Certifications',
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: ThemeColor.lightOrange.withValues(
                      alpha: 0.3,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 16,
                      color: ThemeColor.orange,
                    ),
                  ),
                  8.widthBox,
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: ThemeColor.aquaBlue,
                    child: Icon(
                      Icons.security,
                      size: 16,
                      color: ThemeColor.darkBlue,
                    ),
                  ),
                  8.widthBox,
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: ThemeColor.red.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.medical_services,
                      size: 16,
                      color: ThemeColor.negative,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.pushRoute(
                    BookingDetailsRoute(
                      trainerId: trainer.id,
                      trainerName: trainer.name ?? 'unknown',
                      sport: 'Swimming',
                      location: 'Kuala Lumpur',
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColor.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Book Now',
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
