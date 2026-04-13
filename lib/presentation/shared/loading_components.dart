import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constant/color_constant.dart';

bool _loadingIsOpen = false;

void closeLoading() {
  if (_loadingIsOpen) {
    BotToast.closeAllLoading();
    _loadingIsOpen = false;
  }
}

void showLoading() {
  if (!_loadingIsOpen) {
    _loadingIsOpen = true;

    BotToast.showCustomLoading(
      toastBuilder: (_) {
        return Container(
          alignment: Alignment.center,
          color: Colors.black.withValues(alpha: 0.8),
          child: const LoadingIndicator(),
        );
      },
      useSafeArea: false,
      clickClose: false,
      allowClick: false,
      crossPage: false,
      backgroundColor: Colors.transparent,
      backButtonBehavior: BackButtonBehavior.ignore,
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.child,
    this.height = 16,
    this.width = 100,
    this.borderRadius = 5,
  }) : shape = BoxShape.rectangle;

  const ShimmerLoading.rounded({
    super.key,
    this.child,
    this.height = 16,
    this.width = 100,
    this.borderRadius = 100,
  }) : shape = BoxShape.rectangle;

  const ShimmerLoading.circular({
    super.key,
    this.child,
    this.height = 64,
    this.width = 64,
  }) : borderRadius = null,
       shape = BoxShape.circle;

  final Widget? child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFDADADE),
      highlightColor: const Color(0xFFF5F5F8),
      child:
          child ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius:
                  borderRadius == null
                      ? null
                      : BorderRadius.circular(borderRadius!),
              color: const Color(0xFFE6E6E9),
            ),
          ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size, this.color, this.value})
    : centered = false;

  const LoadingIndicator.centered({
    super.key,
    this.size,
    this.color,
    this.value,
  }) : centered = true;

  final double? size;
  final bool centered;
  final Color? color;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final widget = SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        value: value,
        color: color ?? ThemeColor.negative,
        strokeWidth: 2,
      ),
    );

    return centered ? Center(child: widget) : widget;
  }
}
