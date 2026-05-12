import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/chat/chat_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/message_model.dart';
import '../../application/chat/chat_user_provider.dart';
import '../../domain/models/user_model.dart';
import '../../infrastructure/services/image_service.dart';
import '../shared/cached_image.dart';
import '../shared/snack_bar.dart';
import '../shared/user_avatar.dart';
import 'widgets/ai_avatar.dart';

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
  bool _isUploadingImage = false;

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

  Future<void> _pickAndSendImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) {
      return;
    }

    setState(() => _isUploadingImage = true);

    try {
      final file = File(picked.path);
      final url = await ImageService.uploadToImgBB(file);

      if (url != null) {
        await ref
            .read(chatNotifierProvider.notifier)
            .sendMessage(
              receiverId: widget.trainerId,
              text: url,
              isImage: true,
            );
        _scrollToBottom();
      } else {
        if (mounted) {
          AppSnackBar.error(context, context.l10n.failedToUploadImage);
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, context.l10n.errorMessage(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: ThemeColor.darkBlue,
                  ),
                  title: Text(context.l10n.takeAPhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSendImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: ThemeColor.darkBlue,
                  ),
                  title: Text(context.l10n.chooseFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSendImage(ImageSource.gallery);
                  },
                ),
                16.heightBox,
              ],
            ),
          ),
    );
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
      AppSnackBar.error(
        context,
        context.l10n.failedToSendMessage(e.toString()),
      );
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
    final isAiAssistant =
        widget.trainerId == 'chatbot_ai' ||
        widget.trainerName == 'AI Assistant';

    final otherUser = ref.watch(userByIdProvider(widget.trainerId)).valueOrNull;
    final isSuspended =
        !isAiAssistant && otherUser?.status == UserStatus.suspended;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 1,
        shadowColor: ThemeColor.black.withValues(alpha: 0.1),
        title: Row(
          children: [
            isAiAssistant
                ? const AiAvatar(radius: 18)
                : ref
                    .watch(userByIdProvider(widget.trainerId))
                    .when(
                      data:
                          (user) => Stack(
                            children: [
                              UserAvatar(
                                radius: 18,
                                username: widget.trainerName,
                                userAvatarUrl: user?.userAvatarUrl,
                              ),
                              if (isSuspended)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: ThemeColor.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ThemeColor.cream,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.block,
                                      size: 8,
                                      color: ThemeColor.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      loading:
                          () => const CircleAvatar(
                            radius: 18,
                            backgroundColor: ThemeColor.lightGrey,
                          ),
                      error:
                          (err, _) => UserAvatar(
                            radius: 18,
                            username: widget.trainerName,
                          ),
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
                    error:
                        (err, stack) => Center(
                          child: Text(
                            context.l10n.errorMessage(err.toString()),
                          ),
                        ),
                    data: (messages) {
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            context.l10n.startConversationWith(
                              widget.trainerName,
                            ),
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

            isSuspended ? _buildSuspendedBanner() : _buildBottomInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuspendedBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        border: Border(top: BorderSide(color: ThemeColor.lightGrey)),
      ),
      child: Row(
        children: [
          const Icon(Icons.block, color: ThemeColor.red, size: 20),
          12.widthBox,
          Expanded(
            child: Text(
              context.l10n.accountSuspendedNotice,
              style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
            ),
          ),
        ],
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
                  if (message.isImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder:
                                (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: EdgeInsets.zero,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: InteractiveViewer(
                                      child: CachedImage(
                                        imageUrl: message.text,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.contain,
                                        borderRadius: 0,
                                      ),
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: CachedImage(
                          imageUrl: message.text,
                          width: 200,
                          height: 150,
                          borderRadius: 12,
                        ),
                      ),
                    )
                  else
                    Text(
                      message.text,
                      style: AppWidget.bodyLarge().copyWith(
                        color: isMe ? ThemeColor.white : ThemeColor.black,
                      ),
                    ),
                  4.heightBox,
                  Text(
                    timeString,
                    style: AppWidget.bodyExtraSmall().copyWith(
                      color:
                          isMe
                              ? ThemeColor.white.withValues(alpha: 0.7)
                              : ThemeColor.grey100,
                    ),
                  ),
                ],
              ),
            ),
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
          _isUploadingImage
              ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ThemeColor.darkBlue,
                  ),
                ),
              )
              : IconButton(
                icon: const Icon(Icons.attach_file, color: ThemeColor.grey100),
                onPressed: _showImageSourceSheet,
              ),

          Expanded(
            child: TextField(
              controller: _textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: context.l10n.typeAMessage,
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
