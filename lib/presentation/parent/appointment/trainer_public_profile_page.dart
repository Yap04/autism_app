import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/feedback_model.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/user_avatar.dart';

@RoutePage()
class TrainerPublicProfilePage extends ConsumerWidget {
  const TrainerPublicProfilePage({required this.trainer, super.key});
  final UserModel trainer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coachName =
        trainer.name ?? trainer.nickname ?? context.l10n.coachFallbackName;
    final avgRating = trainer.avgRating ?? 0.0;
    final totalReviews = trainer.totalReviews ?? 0;

    final now = DateTime.now();
    final isManuallyAccepting = trainer.isAcceptingRequests;
    final hasResumeTimePassed =
        trainer.resumeAt != null && now.isAfter(trainer.resumeAt!);

    final hasValidLocation =
        trainer.location != null && trainer.location!.trim().isNotEmpty;

    final isAvailable =
        (isManuallyAccepting || hasResumeTimePassed) && hasValidLocation;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: const Color(0xFF0B1E3D),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ThemeColor.white),
              onPressed: () => context.router.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ColoredBox(
                color: const Color(0xFF0B1E3D),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        UserAvatar(
                          radius: 44,
                          username: coachName,
                          userAvatarUrl: trainer.userAvatarUrl,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: ThemeColor.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0B1E3D),
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: ThemeColor.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.heightBox,
                    Text(
                      coachName,
                      style: AppWidget.h2TextFieldStyle().copyWith(
                        color: ThemeColor.white,
                      ),
                    ),
                    6.heightBox,
                    if (trainer.location?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 14,
                            ),
                            4.widthBox,
                            Expanded(
                              child: Text(
                                trainer.location!,
                                style: AppWidget.bodySmall().copyWith(
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                    12.heightBox,
                    if (trainer.acceptsHomeBased)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColor.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ThemeColor.green.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.home_work_rounded,
                              color: ThemeColor.green,
                              size: 14,
                            ),
                            6.widthBox,
                            Text(
                              context.l10n.homeBasedAvailable,
                              style: AppWidget.bodyExtraSmall().copyWith(
                                color: ThemeColor.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColor.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.domain_rounded,
                              color: ThemeColor.white.withValues(alpha: 0.6),
                              size: 14,
                            ),
                            6.widthBox,
                            Text(
                              context.l10n.centerBasedOnly,
                              style: AppWidget.bodyExtraSmall().copyWith(
                                color: ThemeColor.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                    24.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildHeaderStat(
                            avgRating == 0.0
                                ? '-'
                                : avgRating.toStringAsFixed(1),
                            context.l10n.avgRating,
                          ),
                          12.widthBox,
                          _buildHeaderStat(
                            '$totalReviews',
                            context.l10n.reviewsLabel,
                          ),
                          12.widthBox,
                          _buildHeaderStat(
                            '${trainer.sports.length}',
                            context.l10n.sportsLabel,
                          ),
                        ],
                      ),
                    ),
                    20.heightBox,
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: context.l10n.ratingAndReviews,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              avgRating == 0.0
                                  ? '-'
                                  : avgRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.darkBlue,
                                height: 1.1,
                              ),
                            ),
                            4.heightBox,
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < avgRating.round()
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 18,
                                  color: ThemeColor.orange,
                                );
                              }),
                            ),
                            6.heightBox,
                            Text(
                              context.l10n.reviewsCount(
                                totalReviews.toString(),
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: ThemeColor.grey100,
                              ),
                            ),
                          ],
                        ),
                        28.widthBox,
                        if (totalReviews > 0)
                          Expanded(
                            child: FutureBuilder<List<FeedbackModel>>(
                              future: ref
                                  .read(feedbackRepositoryProvider)
                                  .getFeedbacksByTrainerId(trainer.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                }
                                final feedbacks =
                                    snapshot.data!
                                        .where((f) => f.rating != null)
                                        .toList();
                                return Column(
                                  children: List.generate(5, (i) {
                                    final star = 5 - i;
                                    final count =
                                        feedbacks
                                            .where((f) => f.rating == star)
                                            .length;
                                    final ratio =
                                        feedbacks.isEmpty
                                            ? 0.0
                                            : count / feedbacks.length;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        children: [
                                          Text(
                                            '$star',
                                            style: AppWidget.bodySmall(),
                                          ),
                                          4.widthBox,
                                          const Icon(
                                            Icons.star_rounded,
                                            size: 12,
                                            color: ThemeColor.orange,
                                          ),
                                          8.widthBox,
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: ratio,
                                              backgroundColor: ThemeColor
                                                  .lightGrey
                                                  .withValues(alpha: 0.3),
                                              color: ThemeColor.orange,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              minHeight: 5,
                                            ),
                                          ),
                                          8.widthBox,
                                          SizedBox(
                                            width: 16,
                                            child: Text(
                                              '$count',
                                              style: AppWidget.bodySmall()
                                                  .copyWith(
                                                    color: ThemeColor.grey100,
                                                  ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          )
                        else
                          Expanded(
                            child: Text(
                              context.l10n.noReviewsYet,
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (trainer.bio?.isNotEmpty ?? false)
                    _buildSectionCard(
                      title: context.l10n.aboutTitle,
                      child: Text(
                        trainer.bio!,
                        style: AppWidget.bodyMedium().copyWith(height: 1.6),
                      ),
                    ),

                  if (trainer.sports.isNotEmpty)
                    _buildSectionCard(
                      title: context.l10n.sportsTitle,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            trainer.sports.map((sport) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeColor.aquaBlue.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      getSportIcon(sport),
                                      size: 16,
                                      color: ThemeColor.darkBlue,
                                    ),
                                    8.widthBox,
                                    Text(
                                      sport.toLocalizedSport(context),
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.darkBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                  if (totalReviews > 0)
                    _buildSectionCard(
                      title: context.l10n.reviewsTitle,
                      child: FutureBuilder<List<FeedbackModel>>(
                        future: ref
                            .read(feedbackRepositoryProvider)
                            .getFeedbacksByTrainerId(trainer.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ThemeColor.darkBlue,
                              ),
                            );
                          }
                          final reviews =
                              (snapshot.data ?? [])
                                  .where(
                                    (f) =>
                                        f.rating != null &&
                                        f.review != null &&
                                        f.review!.isNotEmpty,
                                  )
                                  .toList();

                          if (reviews.isEmpty) {
                            return Text(
                              context.l10n.noWrittenReviewsYet,
                              style: AppWidget.bodySmall().copyWith(
                                color: ThemeColor.grey100,
                              ),
                            );
                          }

                          return Column(
                            children:
                                reviews
                                    .map((f) => _buildReviewItem(context, f))
                                    .toList(),
                          );
                        },
                      ),
                    ),

                  40.heightBox,
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomActionButton(
            label:
                isAvailable
                    ? context.l10n.bookASession
                    : context.l10n.unavailableAction,
            borderRadius: 16,
            onPressed:
                isAvailable
                    ? () {
                      final coachName =
                          trainer.name ??
                          trainer.nickname ??
                          context.l10n.coachFallbackName;
                      final location = trainer.location!;
                      final sport =
                          trainer.sports.isNotEmpty
                              ? trainer.sports.first
                              : context.l10n.generalSport;
                      context.pushRoute(
                        BookingDetailsRoute(
                          trainerId: trainer.id,
                          trainerName: coachName,
                          sport: sport,
                          location: location,
                        ),
                      );
                    }
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppWidget.bodySmall().copyWith(
              color: ThemeColor.grey100,
              fontSize: 11,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          16.heightBox,
          child,
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppWidget.h3TextFieldStyle().copyWith(
                color: ThemeColor.white,
              ),
            ),
            4.heightBox,
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, FeedbackModel feedback) {
    // Anonymous Review
    final reviewerName = context.l10n.defaultUser;
    const initials = 'US';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.cream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    (feedback.rating ?? 0) > index
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: ThemeColor.orange,
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMd(
                  context.l10n.localeName,
                ).format(feedback.createdAt),
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          12.heightBox,
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: ThemeColor.darkBlue,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: ThemeColor.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              8.widthBox,
              Text(
                reviewerName,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          10.heightBox,
          Text(
            feedback.review!,
            style: AppWidget.bodySmall().copyWith(
              color: ThemeColor.black,
              height: 1.55,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
