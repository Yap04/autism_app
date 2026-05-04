import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../application/content/content_provider.dart';
import '../../../../../core/constant/color_constant.dart';
import '../../../../../core/constant/textstyle_constant.dart';
import '../../../../../core/extension/widget_ext.dart';
import '../../../../../domain/models/content_model.dart';
import '../../../../shared/snack_bar.dart';

Widget buildContentCard(
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
      typeColor = Colors.purple;
  }

  return GestureDetector(
    onTap: () async {
      await ref.read(incrementViewsProvider)(content.id);

      final urlString = content.contentUrl;

      if (urlString != null && urlString.trim().isNotEmpty) {
        final uri = Uri.parse(urlString);

        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          AppSnackBar.error(context, 'Failed to open the resource: $e');
        }
      } else {
        AppSnackBar.error(context, 'Invalid URL');
      }
    },
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(typeIcon, color: typeColor, size: 24),
              8.widthBox,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  content.type.name.toUpperCase(),
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          12.heightBox,

          Column(
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
              Text(
                content.description,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),

          Text(
            DateFormat('MMM dd, yyyy').format(content.publishedAt),
            style: AppWidget.bodyExtraSmall().copyWith(
              color: ThemeColor.grey100,
            ),
          ),
        ],
      ),
    ),
  );
}
