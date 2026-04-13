import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import 'cached_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.radius,
    super.key,
    this.userAvatarUrl,
    this.username,
    this.fontSize,
  });

  final String? userAvatarUrl;
  final String? username;
  final double radius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final hasImage = userAvatarUrl != null && userAvatarUrl!.isNotEmpty;
    final displayLetter =
        (username != null && username!.isNotEmpty)
            ? username![0].toUpperCase()
            : 'U';

    if (hasImage) {
      return ClipOval(
        child: CachedImage(
          imageUrl: userAvatarUrl,
          width: radius * 2,
          height: radius * 2,
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: ThemeColor.darkBlue,
        child: Text(
          displayLetter,
          style: TextStyle(
            color: ThemeColor.white,
            fontSize: fontSize ?? radius,
          ),
        ),
      );
    }
  }
}
