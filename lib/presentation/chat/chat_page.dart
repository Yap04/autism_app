import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/chat/chat_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/message_model.dart';
import '../shared/snack_bar.dart';

@RoutePage()
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    required this.trainerId,
    required this.trainerName,
    super.key,
  });

  final String trainerId;
  final String trainerName;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _roomId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        final ids = [user.id, widget.trainerId]..sort();
        final generatedRoomId = '${ids[0]}_${ids[1]}';

        setState(() {
          _roomId = generatedRoomId;
        });

        ref.read(chatNotifierProvider.notifier).markAsRead(generatedRoomId);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    try {
      await ref
          .read(chatNotifierProvider.notifier)
          .sendMessage(receiverId: widget.trainerId, text: text);

      _scrollToBottom();
    } catch (e) {
      AppSnackBar.error(context, 'Failed to send message: $e');
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_roomId == null) {
      return const Scaffold(
        backgroundColor: ThemeColor.cream,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentUser = ref.watch(authNotifierProvider).value;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 1,
        shadowColor: ThemeColor.black.withValues(alpha: 0.1),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: ThemeColor.grey100,
              child: Icon(Icons.person, color: ThemeColor.white, size: 24),
            ),
            12.widthBox,
            Text(widget.trainerName, style: AppWidget.h3TextFieldStyle()),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ref
                  .watch(chatMessagesProvider(_roomId!))
                  .when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (messages) {
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            'Start a conversation with ${widget.trainerName}',
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.grey100,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = currentUser?.id == message.senderId;
                          return _buildMessageBubble(message, isMe);
                        },
                      );
                    },
                  ),
            ),

            _buildBottomInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isMe) {
    final timeString = DateFormat('h:mm a').format(message.createdAt);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            const CircleAvatar(
              radius: 14,
              backgroundColor: ThemeColor.grey100,
              child: Icon(Icons.person, color: ThemeColor.white, size: 18),
            ),
          if (!isMe) 8.widthBox,

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? ThemeColor.darkBlue : ThemeColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColor.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppWidget.bodyLarge().copyWith(
                      color: isMe ? ThemeColor.white : ThemeColor.black,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    timeString,
                    style: AppWidget.bodySmall().copyWith(
                      color:
                          isMe
                              ? ThemeColor.white.withValues(alpha: 0.7)
                              : ThemeColor.grey100,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isMe) 8.widthBox,
          if (isMe)
            const CircleAvatar(
              radius: 14,
              backgroundColor: ThemeColor.darkBlue,
              child: Icon(Icons.face, color: ThemeColor.white, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        border: Border(top: BorderSide(color: ThemeColor.lightGrey)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: ThemeColor.grey100),
            onPressed: () {
              // TODO: 处理发送图片逻辑
            },
          ),

          Expanded(
            child: TextField(
              controller: _textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.grey100,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                filled: true,
                fillColor: ThemeColor.cream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          12.widthBox,

          Consumer(
            builder: (context, ref, child) {
              final chatState = ref.watch(chatNotifierProvider);
              final isSending = chatState.isLoading;

              return GestureDetector(
                onTap: isSending ? null : _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSending ? ThemeColor.grey100 : ThemeColor.darkBlue,
                    shape: BoxShape.circle,
                  ),
                  child:
                      isSending
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: ThemeColor.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(
                            Icons.send,
                            color: ThemeColor.white,
                            size: 20,
                          ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
