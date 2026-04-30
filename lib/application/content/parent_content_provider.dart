import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/content_model.dart';
import '../providers/repository_providers.dart';

part 'parent_content_provider.g.dart';

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
