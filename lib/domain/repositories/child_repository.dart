import '../models/child_model.dart';

abstract class ChildRepository {
  Future<void> saveChild(ChildModel child);

  Stream<List<ChildModel>> watchChildrenByParentId(String parentId);

  Stream<List<ChildModel>> watchStudentsByTrainerId(String trainerId);

  Future<ChildModel?> getChildById(String childId);
}
