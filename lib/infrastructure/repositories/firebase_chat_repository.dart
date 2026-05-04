import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/chat_room_model.dart';
import '../../domain/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';

class FirebaseChatRepository implements ChatRepository {
  FirebaseChatRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static const String _chatRoomsPath = 'chatRooms';
  static const String _messagesPath = 'messages';

  CollectionReference<Map<String, dynamic>> get _chatRoomsRef =>
      _firestore.collection(_chatRoomsPath);

  @override
  Stream<List<ChatRoomModel>> getUserChatRooms(String userId) {
    return _chatRoomsRef
        .where('participants', arrayContains: userId)
        .orderBy('lastUpdatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return ChatRoomModel.fromJson(data);
              }).toList(),
        );
  }

  @override
  Stream<List<MessageModel>> getChatMessages(String roomId) {
    return _chatRoomsRef
        .doc(roomId)
        .collection(_messagesPath)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return MessageModel.fromJson(data);
              }).toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String roomId,
    required MessageModel message,
  }) async {
    final batch = _firestore.batch();

    try {
      final roomRef = _chatRoomsRef.doc(roomId);
      final messageRef = roomRef.collection(_messagesPath).doc();

      final newMessage = message.copyWith(id: messageRef.id);
      batch
        ..set(messageRef, newMessage.toJson())
        ..set(roomRef, {
          'participants': FieldValue.arrayUnion([
            message.senderId,
            message.receiverId,
          ]),
          'lastMessage': message.text,
          'lastUpdatedAt': FieldValue.serverTimestamp(),
          'unreadCount': FieldValue.increment(1),
        }, SetOptions(merge: true));

      await batch.commit();
    } catch (e) {
      throw Exception('Gagal menghantar mesej (Failed to send message): $e');
    }
  }

  @override
  Future<void> markMessagesAsRead({
    required String roomId,
    required String userId,
  }) async {
    try {
      final unreadSnapshot =
          await _chatRoomsRef
              .doc(roomId)
              .collection(_messagesPath)
              .where('receiverId', isEqualTo: userId)
              .where('isRead', isEqualTo: false)
              .get();

      if (unreadSnapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in unreadSnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      batch.update(_chatRoomsRef.doc(roomId), {'unreadCount': 0});

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }
}
