import 'package:flutter/material.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';

class RateReviewBottomSheet extends StatefulWidget {
  const RateReviewBottomSheet({super.key});

  @override
  State<RateReviewBottomSheet> createState() => _RateReviewBottomSheetState();
}

class _RateReviewBottomSheetState extends State<RateReviewBottomSheet> {
  int _rating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _rating > 0;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: ThemeColor.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: ThemeColor.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            24.heightBox,

            Text('Rate Your Trainer', style: AppWidget.h2TextFieldStyle()),
            4.heightBox,
            Text(
              'How was your experience?',
              style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
            ),
            24.heightBox,

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = star),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        _rating >= star
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 48,
                        color:
                            _rating >= star
                                ? ThemeColor.orange
                                : ThemeColor.lightGrey,
                      ),
                    ),
                  );
                }),
              ),
            ),
            8.heightBox,
            Center(
              child: Text(
                _rating == 0
                    ? 'Tap to rate'
                    : [
                      '',
                      'Poor',
                      'Fair',
                      'Good',
                      'Very Good',
                      'Excellent',
                    ][_rating],
                style: AppWidget.bodySmall().copyWith(
                  color: _rating == 0 ? ThemeColor.grey100 : ThemeColor.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            24.heightBox,

            Text(
              'Write a Review (Optional)',
              style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
            ),
            8.heightBox,
            TextField(
              controller: _reviewController,
              maxLines: 4,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: 'Share your experience with this trainer...',
                hintStyle: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.lightGrey,
                ),
                filled: true,
                fillColor: ThemeColor.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ThemeColor.lightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ThemeColor.lightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ThemeColor.darkBlue),
                ),
              ),
            ),
            16.heightBox,

            GestureDetector(
              onTap:
                  canSubmit
                      ? () => Navigator.pop(context, {
                        'rating': _rating,
                        'review': _reviewController.text.trim(),
                      })
                      : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      canSubmit
                          ? ThemeColor.darkBlue
                          : ThemeColor.darkBlue.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Submit Review',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
