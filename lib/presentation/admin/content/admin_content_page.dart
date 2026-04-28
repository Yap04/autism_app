import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/admin/content/admin_content_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/content_model.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class AdminContentPage extends ConsumerWidget {
  const AdminContentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsAsync = ref.watch(allContentStreamProvider);
    final currentTab = ref.watch(contentTabProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platform Content', style: AppWidget.h2TextFieldStyle()),
                  8.heightBox,
                  Text(
                    'Manage educational resources for parents and professional assessments for trainers.',
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                ],
              ),
              _buildAddContentBtn(context),
            ],
          ),

          32.heightBox,

          _buildMainTabs(ref, currentTab),

          24.heightBox,

          contentsAsync.when(
            data: (contents) {
              final filteredList =
                  contents.where((c) => c.target == currentTab).toList();

              return Container(
                decoration: BoxDecoration(
                  color: ThemeColor.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTableHeader(currentTab),
                    const Divider(height: 1),
                    if (filteredList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(48),
                        child: Text(
                          'No content found for this category.',
                          style: AppWidget.bodyMedium(),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        separatorBuilder:
                            (context, index) => const Divider(height: 1),
                        itemBuilder:
                            (context, index) => _buildContentRow(
                              context,
                              ref,
                              filteredList[index],
                            ),
                      ),
                  ],
                ),
              );
            },
            loading:
                () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(
                      color: ThemeColor.darkBlue,
                    ),
                  ),
                ),
            error:
                (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Text(
                      'Failed to load content: $err',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.red,
                      ),
                    ),
                  ),
                ),
          ),
          48.heightBox,
        ],
      ),
    );
  }

  Widget _buildAddContentBtn(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.router.push(const AdminContentEditorRoute());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: ThemeColor.darkBlue,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: ThemeColor.darkBlue.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.add, color: ThemeColor.white, size: 20),
              8.widthBox,
              Text(
                'Create New',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTabs(WidgetRef ref, ContentTarget activeTab) {
    return Row(
      children: [
        _buildSingleTab(
          ref,
          'Parent Resources',
          ContentTarget.parent,
          activeTab,
        ),
        16.widthBox,
        _buildSingleTab(
          ref,
          'Trainer Assessments',
          ContentTarget.trainer,
          activeTab,
        ),
      ],
    );
  }

  Widget _buildSingleTab(
    WidgetRef ref,
    String title,
    ContentTarget target,
    ContentTarget activeTab,
  ) {
    final isSelected = activeTab == target;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ref.read(contentTabProvider.notifier).state = target,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? ThemeColor.orange.withValues(alpha: 0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ThemeColor.orange : ThemeColor.lightGrey,
            ),
          ),
          child: Row(
            children: [
              Icon(
                target == ContentTarget.parent
                    ? Icons.family_restroom
                    : Icons.school_outlined,
                color: isSelected ? ThemeColor.orange : ThemeColor.grey100,
                size: 20,
              ),
              12.widthBox,
              Text(
                title,
                style: AppWidget.bodyMedium().copyWith(
                  color: isSelected ? ThemeColor.orange : ThemeColor.grey100,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(ContentTarget currentTab) {
    final metricName =
        currentTab == ContentTarget.parent ? 'Views' : 'Completions';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: ThemeColor.cream.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Content Title', style: _headerStyle()),
          ),
          Expanded(child: Text('Format', style: _headerStyle())),
          Expanded(child: Text(metricName, style: _headerStyle())),
          Expanded(child: Center(child: Text('Status', style: _headerStyle()))),
          Expanded(child: Center(child: Text('Action', style: _headerStyle()))),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => AppWidget.bodySmall().copyWith(
    fontWeight: FontWeight.bold,
    color: ThemeColor.grey100,
  );

  Widget _buildContentRow(
    BuildContext context,
    WidgetRef ref,
    ContentModel content,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.heightBox,
                Text(
                  'Created: ${DateFormat('dd MMM yyyy').format(content.publishedAt)}',
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildTypeTag(content.type)),
          Expanded(
            child: Text(
              '${content.viewsOrTakes}',
              style: AppWidget.bodyMedium().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: _buildStatusTag(content.isPublished)),
          Expanded(
            child: Align(child: _buildTogglePublishBtn(context, ref, content)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTag(ContentType type) {
    IconData icon;
    Color color;
    switch (type) {
      case ContentType.article:
        icon = Icons.article_outlined;
        color = ThemeColor.blue;
      case ContentType.video:
        icon = Icons.play_circle_outline;
        color = ThemeColor.red;
      case ContentType.quiz:
        icon = Icons.quiz_outlined;
        color = Colors.purple;
    }
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        6.widthBox,
        Text(
          type.name.toUpperCase(),
          style: AppWidget.bodyExtraSmall().copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag(bool isPublished) {
    final color = isPublished ? ThemeColor.green : ThemeColor.grey100;

    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isPublished ? 'PUBLISHED' : 'DRAFT',
          style: AppWidget.bodyExtraSmall().copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTogglePublishBtn(
    BuildContext context,
    WidgetRef ref,
    ContentModel content,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          try {
            await ref
                .read(contentRepositoryProvider)
                .togglePublishStatus(content.id, content.isPublished);

            if (context.mounted) {
              AppSnackBar.success(
                context,
                content.isPublished
                    ? 'Content set to Draft.'
                    : 'Content Published!',
              );
            }
          } catch (e) {
            if (context.mounted) {
              AppSnackBar.error(context, 'Failed to update status: $e');
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeColor.cream,
            border: Border.all(color: ThemeColor.lightGrey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            content.isPublished
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: ThemeColor.darkBlue,
            size: 20,
          ),
        ),
      ),
    );
  }
}
