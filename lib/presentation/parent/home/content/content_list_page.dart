import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/content/parent_content_provider.dart'; // 🚀 引入你的数据流
import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';
import 'shared/content_card.dart';

@RoutePage()
class ContentListPage extends ConsumerStatefulWidget {
  const ContentListPage({super.key});

  @override
  ConsumerState<ContentListPage> createState() => _ContentListPageState();
}

class _ContentListPageState extends ConsumerState<ContentListPage> {
  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(parentPublishedContentProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        title: Text('Resources', style: AppWidget.h2TextFieldStyle()),
        centerTitle: true,
      ),
      body: contentAsync.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: ThemeColor.darkBlue),
            ),
        error: (err, _) => Center(child: Text('Failed to load content: $err')),
        data: (contents) {
          if (contents.isEmpty) {
            return Center(
              child: Text(
                'No resources available yet.',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return buildContentCard(context, contents[index]);
            },
          );
        },
      ),
    );
  }
}
