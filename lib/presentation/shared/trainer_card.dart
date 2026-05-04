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

    final bioText =
        (trainer.bio?.isNotEmpty ?? false)
            ? trainer.bio!
            : 'No description provided.';
    final sportsList =
        trainer.sports.isNotEmpty ? trainer.sports : ['Not specified'];

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
                      bioText,
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
            'Coaching Sports:',
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
          ),
          8.heightBox,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                sportsList.map((sport) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColor.lightGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sport,
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
          ),
          12.heightBox,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap:
                      () => context.pushRoute(
                        ChatRoute(
                          trainerId: trainer.id,
                          trainerName: trainer.name ?? 'Unknown Trainer',
                        ),
                      ),

                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: ThemeColor.blue,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ThemeColor.aquaBlue),
                    ),
                    child: Text(
                      'Chat with Coach',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              12.widthBox,
              Expanded(
                child: GestureDetector(
                  onTap:
                      isAvailable
                          ? () {
                            context.pushRoute(
                              BookingDetailsRoute(
                                trainerId: trainer.id,
                                trainerName: trainer.name ?? 'unknown',
                                sport:
                                    trainer.sports.isNotEmpty
                                        ? trainer.sports.first
                                        : 'Sports',
                                location: trainer.location ?? 'Kuala Lumpur',
                              ),
                            );
                          }
                          : null,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isAvailable ? ThemeColor.white : ThemeColor.lightGrey,

                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isAvailable
                                ? ThemeColor.darkBlue
                                : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      isAvailable ? 'Book Now' : 'Unavailable',
                      style: AppWidget.bodySmall().copyWith(
                        color:
                            isAvailable
                                ? ThemeColor.darkBlue
                                : ThemeColor.grey100,
                        fontWeight:
                            isAvailable ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
    );
  }
}
