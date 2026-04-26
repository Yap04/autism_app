import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/content_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_content_editor_notifier.g.dart';

@riverpod
class AdminContentEditorNotifier extends _$AdminContentEditorNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> createContent({
    required String title,
    required String description,
    required String contentUrl,
    required ContentTarget target,
    required ContentType type,
    required bool isPublished,
  }) async {
    state = const AsyncLoading();

    try {
      final newContent = ContentModel(
        id: '',
        title: title,
        description: description,
        contentUrl: contentUrl.isNotEmpty ? contentUrl : null,
        target: target,
        type: type,
        isPublished: isPublished,
        publishedAt: DateTime.now(),
      );

      await ref.read(contentRepositoryProvider).createContent(newContent);

      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }
}
