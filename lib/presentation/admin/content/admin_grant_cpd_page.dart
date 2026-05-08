import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/admin/content/admin_grant_cpd_notifier.dart';
import '../../../core/constant/badge_constant.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class AdminGrantCpdPage extends ConsumerStatefulWidget {
  const AdminGrantCpdPage({super.key});

  @override
  ConsumerState<AdminGrantCpdPage> createState() => _AdminGrantCpdPageState();
}

class _AdminGrantCpdPageState extends ConsumerState<AdminGrantCpdPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final points = int.parse(_pointsController.text.trim());

    final notifier = ref.read(adminGrantCpdNotifierProvider.notifier);

    final result = await notifier.grantPoints(email: email, points: points);

    if (result['success'] == true && mounted) {
      final newBadges = result['newBadges'] as List<BadgeDef>? ?? [];

      var successMessage = 'Successfully granted $points pts to $email!';

      if (newBadges.isNotEmpty) {
        final badgeNames = newBadges
            .map((b) => b.label.replaceAll('\n', ' '))
            .join(', ');
        successMessage += ' 🎉 Unlocked: $badgeNames';
      }

      AppSnackBar.success(context, successMessage);

      _emailController.clear();
      _pointsController.clear();
      context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminGrantCpdNotifierProvider);
    final isLoading = state is AsyncLoading;

    ref.listen(adminGrantCpdNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        AppSnackBar.error(context, next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.white,
        title: Text('Grant CPD Points', style: AppWidget.h3TextFieldStyle()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeColor.darkBlue.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeColor.darkBlue.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: ThemeColor.darkBlue,
                            ),
                            12.widthBox,
                            Expanded(
                              child: Text(
                                'Manually award CPD points to a trainer after verifying their Google Form assessment.',
                                style: AppWidget.bodySmall().copyWith(
                                  color: ThemeColor.darkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      32.heightBox,

                      Text(
                        'Trainer Email *',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('e.g., trainer@email.com'),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Email is required';
                          }
                          if (!v.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      24.heightBox,

                      Text(
                        'CPD Points to Award *',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      TextFormField(
                        controller: _pointsController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          'e.g., 50',
                        ).copyWith(suffixText: 'pts'),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Points are required';
                          }
                          if (int.tryParse(v) == null || int.parse(v) <= 0) {
                            return 'Enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: ThemeColor.white,
              child: BottomActionButton(
                label: 'Grant Points',
                isLoading: isLoading,
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ThemeColor.grey100),
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
    );
  }
}
