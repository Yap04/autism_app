import 'package:flutter/widgets.dart';

extension NumWidgetExtension on num {
  Widget get widthBox => SizedBox(width: toDouble());

  Widget get heightBox => SizedBox(height: toDouble());
}

Widget get emptyBox => const SizedBox.shrink();
