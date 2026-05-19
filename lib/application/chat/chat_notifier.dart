import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/chat_room_model.dart';
import '../../domain/models/message_model.dart';
import '../../infrastructure/services/remote_notification_service.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'chat_notifier.g.dart';

@riverpod
Stream<List<ChatRoomModel>> userChatRooms(UserChatRoomsRef ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value([]);

  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getUserChatRooms(user.id);
}

@riverpod
Stream<List<MessageModel>> chatMessages(ChatMessagesRef ref, String roomId) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getChatMessages(roomId);
}

@riverpod
int totalUnreadCount(TotalUnreadCountRef ref) {
  final user = ref.watch(authNotifierProvider).value;
  final rooms = ref.watch(userChatRoomsProvider).valueOrNull ?? [];
  if (user == null) return 0;
  return rooms
      .where((r) => !r.participants.contains('chatbot_ai'))
      .fold(0, (sum, r) => sum + r.unreadCount);
}

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> sendMessage({
    required String receiverId,
    required String text,
    bool isImage = false,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final user = ref.read(authNotifierProvider).value;
      if (user == null) {
        throw Exception('Please log in first.');
      }

      final ids = [user.id, receiverId]..sort();
      final roomId = '${ids[0]}_${ids[1]}';

      final myMessage = MessageModel(
        id: '',
        senderId: user.id,
        receiverId: receiverId,
        text: text.trim(),
        isImage: isImage,
        createdAt: DateTime.now(),
      );

      await ref
          .read(chatRepositoryProvider)
          .sendMessage(roomId: roomId, message: myMessage);

      if (receiverId != 'chatbot_ai') {
        try {
          final targetToken = await ref
              .read(userRepositoryProvider)
              .getUserFcmToken(receiverId);

          if (targetToken != null && targetToken.isNotEmpty) {
            final senderName = user.name ?? user.nickname ?? 'New Message';
            final notificationBody = isImage ? 'Sent a photo 📷' : text.trim();

            await RemoteNotificationService.notifyOtherUser(
              targetFcmToken: targetToken,
              title: senderName,
              body: notificationBody,
            );
          }
        } catch (e) {
          print('Push notification failed to send: $e');
        }
      }

      if (receiverId == 'chatbot_ai') {
        try {
          final aiResponseText = await ref
              .read(geminiServiceProvider)
              .getResponse(text.trim());

          final aiMessage = MessageModel(
            id: '',
            senderId: 'chatbot_ai',
            receiverId: user.id,
            text: aiResponseText,
            createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
          );

          await ref
              .read(chatRepositoryProvider)
              .sendMessage(roomId: roomId, message: aiMessage);
        } catch (apiError) {
          throw Exception('Gemini Error: $apiError');
        }
      }
    });
  }

  Future<void> markAsRead(String roomId) async {
    try {
      final user = ref.read(authNotifierProvider).value;
      if (user == null) return;

      await ref
          .read(chatRepositoryProvider)
          .markMessagesAsRead(roomId: roomId, userId: user.id);
    } catch (e) {
      print('Error marking as read: $e');
    }
  }
}
