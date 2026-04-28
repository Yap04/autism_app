import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/content_model.dart';
import '../providers/repository_providers.dart';

final parentPublishedContentProvider =
    StreamProvider.autoDispose<List<ContentModel>>((ref) {
      final repo = ref.watch(contentRepositoryProvider);

      return repo.watchAllContent().map((contents) {
        return contents.where((c) {
          return c.isPublished == true && c.target == ContentTarget.parent;
        }).toList();
      });
    });

final incrementViewsProvider =
    Provider.autoDispose<Future<void> Function(String)>((ref) {
      return (String contentId) async {
        final repo = ref.read(contentRepositoryProvider);
        await repo.incrementContentViews(contentId);
      };
    });
