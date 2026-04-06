import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/auth/auth_notifier.dart';
import '../../application/chat/chat_notifier.dart';
import '../../application/providers/repository_providers.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';
import '../shared/app_text_field.dart';
import '../shared/curved_header_background.dart';
import 'widgets/chat_list_item.dart';

final chatUserInfoProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  if (userId.isEmpty) {
    return null;
  }
  return ref.read(userRepositoryProvider).getUserById(userId);
});

@RoutePage()
class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final chatRoomsAsync = ref.watch(userChatRoomsProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: Stack(
        children: [
          CurvedHeaderBackground(
            customHeight: MediaQuery.of(context).padding.top + 124,
          ),

          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text('Chats', style: AppWidget.h2TextFieldStyle()),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: AppTextField(
                    controller: _searchController,
                    hintText: 'Search chats...',
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: ThemeColor.grey100,
                    ),
                  ),
                ),

                8.heightBox,
                Expanded(
                  child: chatRoomsAsync.when(
                    loading:
                        () => const Center(
                          child: CircularProgressIndicator(
                            color: ThemeColor.darkBlue,
                          ),
                        ),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (rooms) {
                      final filteredRooms =
                          rooms.where((room) {
                            return !room.participants.contains('chatbot_ai');
                          }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        itemCount: filteredRooms.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            if (_searchQuery.isNotEmpty &&
                                !'ai chatbot'.contains(_searchQuery)) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              children: [
                                ChatListItem(
                                  username: 'AI Assistant',
                                  lastMessage:
                                      'Ask me anything about autism sports training',
                                  time: '',
                                  isOnline: true,
                                  imageUrl: 'asset/image/chatbot.png',
                                  onTap:
                                      () => context.pushRoute(
                                        ChatRoute(
                                          trainerId: 'chatbot_ai',
                                          trainerName: 'AI Assistant',
                                        ),
                                      ),
                                ),
                                if (filteredRooms.isEmpty &&
                                    _searchQuery.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: _buildEmptyState(),
                                  ),
                              ],
                            );
                          }

                          final room = filteredRooms[index - 1];
                          final otherUserId = room.participants.firstWhere(
                            (id) => id != currentUser?.id,
                            orElse: () => '',
                          );

                          final otherUserAsync = ref.watch(
                            chatUserInfoProvider(otherUserId),
                          );

                          return otherUserAsync.when(
                            loading:
                                () => const ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: ThemeColor.lightGrey,
                                  ),
                                  title: SizedBox(
                                    width: 100,
                                    height: 16,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: ThemeColor.lightGrey,
                                      ),
                                    ),
                                  ),
                                ),
                            error: (e, _) => const SizedBox.shrink(),
                            data: (otherUser) {
                              final name = otherUser?.name ?? 'Unknown User';

                              if (_searchQuery.isNotEmpty &&
                                  !name.toLowerCase().contains(_searchQuery)) {
                                return const SizedBox.shrink();
                              }

                              return ChatListItem(
                                username: name,
                                lastMessage:
                                    room.lastMessage ??
                                    'Started a conversation',
                                time: _formatTimestamp(room.lastUpdatedAt),
                                onTap:
                                    () => context.pushRoute(
                                      ChatRoute(
                                        trainerId: otherUserId,
                                        trainerName: name,
                                      ),
                                    ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: ThemeColor.lightGrey,
          ),
          16.heightBox,
          Text(
            'No messages yet',
            style: AppWidget.bodyLarge().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final isToday =
        timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;

    if (isToday) {
      return DateFormat('h:mm a').format(timestamp);
    } else {
      return DateFormat('d MMM').format(timestamp);
    }
  }
}
