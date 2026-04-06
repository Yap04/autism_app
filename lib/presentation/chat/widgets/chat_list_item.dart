import 'package:flutter/material.dart';
import '../../../core/constant/color_constant.dart';

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
          isAiAssistant ? _buildAiAvatar() : _buildUserAvatar(),
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

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 26,
      backgroundColor: ThemeColor.white,
      backgroundImage:
          imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : null,
      child:
          imageUrl == null || imageUrl!.isEmpty
              ? const Icon(Icons.person, color: ThemeColor.grey100, size: 30)
              : null,
    );
  }

  Widget _buildAiAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(child: Image.asset(imageUrl!, fit: BoxFit.contain)),
    );
  }
}
