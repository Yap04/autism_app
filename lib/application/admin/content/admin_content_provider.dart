import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/content_model.dart';
import '../../providers/repository_providers.dart';

final allContentStreamProvider = StreamProvider.autoDispose<List<ContentModel>>(
  (ref) {
    final repo = ref.watch(contentRepositoryProvider);
    return repo.watchAllContent();
  },
);

final contentTabProvider = StateProvider<ContentTarget>(
  (ref) => ContentTarget.parent,
);
