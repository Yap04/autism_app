import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../application/auth/auth_notifier.dart';
import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';
import '../../../../core/extension/localization_ext.dart';
import '../../../../core/extension/widget_ext.dart';
import '../../../application/content/content_provider.dart';
import '../../../core/constant/badge_constant.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/content_model.dart';
import '../../../domain/models/user_model.dart';
import '../../parent/home/content/shared/content_card.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class TrainerAcademyPage extends ConsumerStatefulWidget {
  const TrainerAcademyPage({super.key});

  @override
  ConsumerState<TrainerAcademyPage> createState() => _TrainerAcademyPageState();
}

class _TrainerAcademyPageState extends ConsumerState<TrainerAcademyPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isPendingTrainer =
        currentUser.verificationStatus == VerificationStatus.pending;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        centerTitle: true,
        leading:
            isPendingTrainer
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
                  onPressed: () {
                    context.router.replaceAll([const LoginRoute()]);
                  },
                )
                : null,
        title: Text(
          context.l10n.academyTitle,
          style: AppWidget.h2TextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child:
            isPendingTrainer
                ? _buildPendingView(context, ref)
                : _buildApprovedView(context, ref),
      ),
    );
  }

  Widget _buildPendingView(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(trainerPendingContentProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.welcomeToAcademy,
          style: AppWidget.h2TextFieldStyle().copyWith(
            color: ThemeColor.darkBlue,
          ),
        ),
        8.heightBox,
        Text(
          context.l10n.academyPendingDescription,
          style: AppWidget.bodyMedium().copyWith(
            color: ThemeColor.grey100,
            height: 1.4,
          ),
        ),
        24.heightBox,

        contentAsync.when(
          loading:
              () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: ThemeColor.darkBlue),
                ),
              ),
          error:
              (err, _) => Center(
                child: Text(
                  context.l10n.errorLoadingAcademyContent(err.toString()),
                  style: const TextStyle(color: ThemeColor.red),
                ),
              ),
          data: (contents) {
            if (contents.isEmpty) {
              return Center(
                child: Text(
                  context.l10n.noTrainingModulesAvailable,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              );
            }

            final materials =
                contents.where((c) => c.type != ContentType.quiz).toList();
            final quizzes =
                contents.where((c) => c.type == ContentType.quiz).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (materials.isNotEmpty) ...[
                  Text(
                    context.l10n.learningMaterials,
                    style: AppWidget.h3TextFieldStyle(),
                  ),
                  16.heightBox,
                  ...materials.map(
                    (content) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: IntrinsicHeight(
                        child: buildContentCard(context, ref, content),
                      ),
                    ),
                  ),
                  24.heightBox,
                ],

                if (quizzes.isNotEmpty) ...[
                  Text(
                    context.l10n.finalAssessment,
                    style: AppWidget.h3TextFieldStyle().copyWith(
                      color: ThemeColor.orange,
                    ),
                  ),
                  8.heightBox,
                  Text(
                    context.l10n.finalAssessmentDescription,
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                  16.heightBox,
                  ...quizzes.map(
                    (quiz) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: IntrinsicHeight(
                        child: buildContentCard(context, ref, quiz),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildApprovedView(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(trainerAdvancedContentProvider);
    final currentUser = ref.watch(authNotifierProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.continuousLearning,
          style: AppWidget.h2TextFieldStyle().copyWith(
            color: ThemeColor.darkBlue,
          ),
        ),
        8.heightBox,
        Text(
          context.l10n.upskillDescription,
          style: AppWidget.bodyMedium().copyWith(
            color: ThemeColor.grey100,
            height: 1.4,
          ),
        ),
        24.heightBox,

        Text(
          context.l10n.myBadgesWithPoints(
            (currentUser?.totalCpdPoints ?? 0).toString(),
          ),
          style: AppWidget.h3TextFieldStyle(),
        ),
        16.heightBox,

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                AppBadges.allBadges.map((badgeDef) {
                  final hasEarned =
                      currentUser!.totalCpdPoints >= badgeDef.requiredPoints;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildBadgeItem(
                      context,
                      badgeDef,
                      isLocked: !hasEarned,
                    ),
                  );
                }).toList(),
          ),
        ),
        32.heightBox,

        Text(context.l10n.advancedCourses, style: AppWidget.h3TextFieldStyle()),
        16.heightBox,

        contentAsync.when(
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: ThemeColor.darkBlue),
              ),
          error: (err, _) => Text(context.l10n.errorMessage(err.toString())),
          data: (contents) {
            if (contents.isEmpty) {
              return Text(
                context.l10n.noAdvancedCoursesYet,
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.grey100,
                ),
              );
            }

            return Column(
              children:
                  contents.map((content) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildAdvancedCourseCard(context, ref, content),
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBadgeItem(
    BuildContext context,
    BadgeDef badgeDef, {
    bool isLocked = false,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color:
                isLocked
                    ? ThemeColor.cream
                    : badgeDef.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isLocked
                      ? ThemeColor.lightGrey
                      : badgeDef.color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            isLocked ? Icons.lock_outline : badgeDef.icon,
            color: isLocked ? ThemeColor.grey100 : badgeDef.color,
            size: 32,
          ),
        ),
        8.heightBox,
        Text(
          isLocked
              ? context.l10n.requiredPointsLabel(
                badgeDef.requiredPoints.toString(),
              )
              : badgeDef.label,
          textAlign: TextAlign.center,
          style: AppWidget.bodyExtraSmall().copyWith(
            fontWeight: FontWeight.bold,
            color: isLocked ? ThemeColor.grey100 : ThemeColor.black,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedCourseCard(
    BuildContext context,
    WidgetRef ref,
    ContentModel content,
  ) {
    IconData typeIcon;
    Color typeColor;

    switch (content.type) {
      case ContentType.video:
        typeIcon = Icons.play_circle_fill_rounded;
        typeColor = ThemeColor.red;
      case ContentType.article:
        typeIcon = Icons.article_rounded;
        typeColor = ThemeColor.blue;
      case ContentType.quiz:
        typeIcon = Icons.quiz_rounded;
        typeColor = ThemeColor.orange;
    }

    return GestureDetector(
      onTap: () async {
        await ref.read(incrementViewsProvider)(content.id);
        final urlString = content.contentUrl;
        if (urlString != null && urlString.isNotEmpty) {
          try {
            await launchUrl(
              Uri.parse(urlString),
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            if (context.mounted) {
              AppSnackBar.error(
                context,
                context.l10n.failedToOpenCourse(e.toString()),
              );
            }
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: Icon(typeIcon, color: typeColor, size: 40),
            ),
            16.widthBox,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: AppWidget.bodyMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.heightBox,
                    Text(
                      DateFormat('MMM dd, yyyy').format(content.publishedAt),
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    8.heightBox,

                    Row(
                      children: [
                        if (content.type == ContentType.quiz)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColor.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              context.l10n.plusCpdPoints(
                                content.cpdPoints.toString(),
                              ),
                              style: AppWidget.bodyExtraSmall().copyWith(
                                color: ThemeColor.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: ThemeColor.grey100,
                        ),
                        4.widthBox,
                        Text(
                          '${content.viewsOrTakes}',
                          style: AppWidget.bodyExtraSmall().copyWith(
                            color: ThemeColor.grey100,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
