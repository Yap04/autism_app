import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/content_model.dart';
import '../providers/repository_providers.dart';

part 'content_provider.g.dart';

@riverpod
Stream<List<ContentModel>> parentPublishedContent(
  ParentPublishedContentRef ref,
) {
  final repo = ref.watch(contentRepositoryProvider);

  return repo.watchAllContent().map((contents) {
    return contents.where((c) {
      return c.isPublished == true && c.target == ContentTarget.parent;
    }).toList();
  });
}

@riverpod
Future<void> Function(String) incrementViews(IncrementViewsRef ref) {
  return (String contentId) async {
    final repo = ref.read(contentRepositoryProvider);
    await repo.incrementContentViews(contentId);
  };
}

@riverpod
Stream<List<ContentModel>> trainerPendingContent(TrainerPendingContentRef ref) {
  final repo = ref.watch(contentRepositoryProvider);

  return repo.watchAllContent().map((contents) {
    final pendingContents =
        contents.where((c) {
            return c.isPublished == true &&
                c.target == ContentTarget.trainer &&
                c.isAdvanced == false;
          }).toList()
          ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return pendingContents;
  });
}

@riverpod
Stream<List<ContentModel>> trainerAdvancedContent(
  TrainerAdvancedContentRef ref,
) {
  final repo = ref.watch(contentRepositoryProvider);

  return repo.watchAllContent().map((contents) {
    final advancedContents =
        contents.where((c) {
            return c.isPublished == true &&
                c.target == ContentTarget.trainer &&
                c.isAdvanced == true;
          }).toList()
          ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return advancedContents;
  });
}
