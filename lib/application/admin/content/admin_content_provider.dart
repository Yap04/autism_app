import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/content_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_content_provider.g.dart';

@riverpod
Stream<List<ContentModel>> allContentStream(AllContentStreamRef ref) {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.watchAllContent();
}

@riverpod
class ContentTab extends _$ContentTab {
  @override
  ContentTarget build() {
    return ContentTarget.parent;
  }

  void updateTab(ContentTarget newTarget) {
    state = newTarget;
  }
}
