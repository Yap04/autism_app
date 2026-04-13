import 'package:flutter/material.dart';
import '../../../core/constant/color_constant.dart';
import '../../shared/user_avatar.dart';
import 'ai_avatar.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    required this.username,
    required this.lastMessage,
    required this.time,
    this.imageUrl,
    this.onTap,
    this.isOnline = false,
    super.key,
  });

  final String username;
  final String lastMessage;
  final String time;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final isAiAssistant = username == 'AI Assistant';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Stack(
        children: [
          isAiAssistant
              ? AiAvatar(imageUrl: imageUrl)
              : UserAvatar(
                radius: 26,
                userAvatarUrl: imageUrl,
                username: username,
              ),

          if (isOnline)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColor.cream, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: onTap,
    );
  }
}
