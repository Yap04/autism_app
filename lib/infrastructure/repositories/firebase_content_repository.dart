import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/content_model.dart';
import '../../domain/repositories/content_repository.dart';

class FirebaseContentRepository implements ContentRepository {
  FirebaseContentRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _contentRef =>
      _firestore.collection('contents');

  @override
  Stream<List<ContentModel>> watchAllContent() {
    return _contentRef.orderBy('publishedAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ContentModel.fromJson(data);
        }).toList();
      },
    );
  }

  @override
  Future<void> createContent(ContentModel content) async {
    final docRef = _contentRef.doc();
    final newContent = content.copyWith(id: docRef.id);
    await docRef.set(newContent.toJson());
  }

  @override
  Future<void> togglePublishStatus(String contentId, bool currentStatus) async {
    await _contentRef.doc(contentId).update({'isPublished': !currentStatus});
  }
}
