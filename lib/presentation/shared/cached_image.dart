import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading_components.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.placeholderColor = const Color(0xFFE0E0E0),
    this.borderRadius = 8,
    super.key,
  });
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Color placeholderColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _shimmerPlaceholder();
    }

    if (imageUrl!.startsWith('asset/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imageUrl!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder:
              (_, _, _) => _shimmerPlaceholder(icon: Icons.broken_image),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => _shimmerPlaceholder(),
        errorWidget: (_, _, _) => _shimmerPlaceholder(icon: Icons.broken_image),
      ),
    );
  }

  Widget _shimmerPlaceholder({IconData? icon}) {
    if (icon != null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(child: Icon(icon, size: width * 0.5, color: Colors.grey)),
      );
    }

    return ShimmerLoading(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
