import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/user_model.dart';
import '../../core/constant/badge_constant.dart';
import '../../core/extension/sport_ext.dart';
import 'user_avatar.dart';

class TrainerCard extends StatefulWidget {
  const TrainerCard({required this.trainer, super.key});
  final UserModel trainer;

  @override
  State<TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<TrainerCard> {
  bool _badgesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isManuallyAccepting = widget.trainer.isAcceptingRequests;
    final hasResumeTimePassed =
        widget.trainer.resumeAt != null &&
        now.isAfter(widget.trainer.resumeAt!);

    final hasValidLocation =
        widget.trainer.location != null &&
        widget.trainer.location!.trim().isNotEmpty;

    final isAvailable =
        (isManuallyAccepting || hasResumeTimePassed) && hasValidLocation;

    final bioText =
        (widget.trainer.bio?.isNotEmpty ?? false)
            ? widget.trainer.bio!
            : context.l10n.noDescriptionProvided;
    final sportsList =
        widget.trainer.sports.isNotEmpty
            ? widget.trainer.sports
            : [context.l10n.notSpecified];

    final userBadgeIds = widget.trainer.badges;
    final displayBadges =
        userBadgeIds
            .map((id) {
              return AppBadges.allBadges.cast<BadgeDef?>().firstWhere(
                (b) => b?.id == id,
                orElse: () => null,
              );
            })
            .whereType<BadgeDef>()
            .toList();

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
                userAvatarUrl: widget.trainer.userAvatarUrl,
                username: widget.trainer.name ?? widget.trainer.nickname,
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
                            widget.trainer.name ??
                                widget.trainer.nickname ??
                                context.l10n.unknownTrainer,
                            style: AppWidget.bodyLarge().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: ThemeColor.orange,
                              size: 16,
                            ),
                            4.widthBox,
                            Text(
                              widget.trainer.avgRating != null
                                  ? widget.trainer.avgRating!.toStringAsFixed(1)
                                  : '-',
                              style: AppWidget.bodySmall().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
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

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isAvailable
                                    ? ThemeColor.aquaBlue
                                    : ThemeColor.lightGrey.withValues(
                                      alpha: 0.5,
                                    ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isAvailable
                                      ? ThemeColor.darkBlue
                                      : ThemeColor.grey100,
                            ),
                          ),
                          child: Text(
                            isAvailable
                                ? context.l10n.availableStatus
                                : context.l10n.notAvailableStatus,
                            style: AppWidget.bodySmall().copyWith(
                              color:
                                  isAvailable
                                      ? ThemeColor.darkBlue
                                      : ThemeColor.grey100,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        if (widget.trainer.acceptsHomeBased)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.home_outlined,
                                  size: 13,
                                  color: Colors.green,
                                ),
                                4.widthBox,
                                Text(
                                  context.l10n.homeBased,
                                  style: AppWidget.bodySmall().copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.heightBox,
          Text(
            context.l10n.coachingSports,
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
                      sport.toLocalizedSport(context),
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
                          trainerId: widget.trainer.id,
                          trainerName:
                              widget.trainer.name ??
                              context.l10n.unknownTrainer,
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
                      context.l10n.chatWithCoach,
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
                                trainerId: widget.trainer.id,
                                trainerName:
                                    widget.trainer.name ??
                                    context.l10n.unknownTrainer,
                                sport:
                                    widget.trainer.sports.isNotEmpty
                                        ? widget.trainer.sports.first
                                        : 'Sports',
                                location:
                                    widget.trainer.location ?? 'Kuala Lumpur',
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
                      isAvailable
                          ? context.l10n.bookNow
                          : context.l10n.unavailableAction,
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
              widget.trainer.resumeAt != null &&
              widget.trainer.resumeAt!.isAfter(now))
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                context.l10n.availableAtTime(
                  DateFormat('hh:mm a').format(widget.trainer.resumeAt!),
                ),
                style: AppWidget.bodyExtraSmall().copyWith(
                  color: ThemeColor.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (displayBadges.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            GestureDetector(
              onTap: () => setState(() => _badgesExpanded = !_badgesExpanded),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.achievementsCount(
                      displayBadges.length.toString(),
                    ),
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.grey100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _badgesExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: ThemeColor.grey100,
                  ),
                ],
              ),
            ),
            if (_badgesExpanded) ...[
              8.heightBox,
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    displayBadges.map((badgeDef) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeDef.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: badgeDef.color.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              badgeDef.icon,
                              size: 14,
                              color: badgeDef.color,
                            ),
                            4.widthBox,
                            Text(
                              badgeDef.label.replaceAll('\n', ' '),
                              style: AppWidget.bodyExtraSmall().copyWith(
                                color: badgeDef.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
