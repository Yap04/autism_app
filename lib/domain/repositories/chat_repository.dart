import '../models/chat_room_model.dart';
import '../models/message_model.dart';

abstract class ChatRepository {
  Stream<List<ChatRoomModel>> getUserChatRooms(String userId);

  Stream<List<MessageModel>> getChatMessages(String roomId);

  Future<void> sendMessage({
    required String roomId,
    required MessageModel message,
  });

  Future<void> markMessagesAsRead({
    required String roomId,
    required String userId,
  });
}
