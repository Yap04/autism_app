import '../models/child_model.dart';

abstract class ChildRepository {
  Future<void> saveChild(ChildModel child);

  Stream<List<ChildModel>> watchChildrenByParentId(String parentId);
}
