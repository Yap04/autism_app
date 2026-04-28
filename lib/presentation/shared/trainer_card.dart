import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final now = DateTime.now();
    final isManuallyAccepting = trainer.isAcceptingRequests;
    final hasResumeTimePassed =
        trainer.resumeAt != null && now.isAfter(trainer.resumeAt!);

    final isAvailable = isManuallyAccepting || hasResumeTimePassed;

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
                    //TODO: Replace with actual trainer description when available
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
                        color:
                            isAvailable
                                ? ThemeColor.aquaBlue
                                : ThemeColor.lightGrey.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Not Available',
                        style: AppWidget.bodySmall().copyWith(
                          color:
                              isAvailable
                                  ? ThemeColor.darkBlue
                                  : ThemeColor.grey100,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap:
                        isAvailable
                            ? () {
                              context.pushRoute(
                                BookingDetailsRoute(
                                  trainerId: trainer.id,
                                  trainerName: trainer.name ?? 'unknown',
                                  sport: 'Swimming',
                                  location: 'Kuala Lumpur',
                                ),
                              );
                            }
                            : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isAvailable
                                ? ThemeColor.blue
                                : ThemeColor.lightGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAvailable ? 'Book Now' : 'Unavailable',
                        style: AppWidget.bodyMedium().copyWith(
                          color:
                              isAvailable
                                  ? ThemeColor.white
                                  : ThemeColor.grey100,
                          fontWeight:
                              isAvailable ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  if (!isAvailable &&
                      trainer.resumeAt != null &&
                      trainer.resumeAt!.isAfter(now))
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Available at ${DateFormat('hh:mm a').format(trainer.resumeAt!)}',
                        style: AppWidget.bodyExtraSmall().copyWith(
                          color: ThemeColor.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
