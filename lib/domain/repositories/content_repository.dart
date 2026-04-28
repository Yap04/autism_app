import '../models/content_model.dart';

abstract class ContentRepository {
  Stream<List<ContentModel>> watchAllContent();

  Future<void> createContent(ContentModel content);

  Future<void> togglePublishStatus(String contentId, bool currentStatus);

  Future<void> incrementContentViews(String contentId);
}
