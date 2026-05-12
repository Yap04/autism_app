import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/chat/chat_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../core/extension/localization_ext.dart';

class HomeHeaderRow extends ConsumerWidget {
  const HomeHeaderRow({required this.userName, this.fallbackName, super.key});

  final String? userName;
  final String? fallbackName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = userName ?? fallbackName ?? context.l10n.parentFallbackName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.goodMorningGreeting(name),
          style: AppWidget.h2TextFieldStyle(),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                context.pushRoute(const ChatListRoute());
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeColor.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColor.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: ThemeColor.darkBlue,
                  size: 24,
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final count = ref.watch(totalUnreadCountProvider);
                if (count == 0) {
                  return emptyBox;
                }
                return Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ThemeColor.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: ThemeColor.cream, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: ThemeColor.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
