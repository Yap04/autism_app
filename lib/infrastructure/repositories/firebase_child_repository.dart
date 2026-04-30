import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/child_model.dart';
import '../../domain/repositories/child_repository.dart';

class FirebaseChildRepository implements ChildRepository {
  FirebaseChildRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static const String _childPath = 'children';

  CollectionReference<Map<String, dynamic>> get _childRef =>
      _firestore.collection(_childPath);

  @override
  Future<void> saveChild(ChildModel child) async {
    try {
      await _childRef
          .doc(child.id)
          .set(child.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save child profile: $e');
    }
  }

  @override
  Stream<List<ChildModel>> watchChildrenByParentId(String parentId) {
    return _childRef
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChildModel.fromJson(doc.data());
          }).toList();
        });
  }
}
