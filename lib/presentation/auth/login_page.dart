import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/localization_ext.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';
import '../shared/snack_bar.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotEmailController = TextEditingController();

  bool isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgotEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F4FD), Color(0xFFF0F8FF), Color(0xFFDFF0F8)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ThemeColor.darkBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    color: ThemeColor.white,
                    size: 32,
                  ),
                ),
                16.heightBox,
                Text(
                  context.l10n.welcomeBack,
                  style: AppWidget.h1TextFieldStyle().copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.darkBlue,
                  ),
                ),
                6.heightBox,
                Text(
                  context.l10n.signInToContinue,
                  style: AppWidget.bodySmall().copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                36.heightBox,

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeColor.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColor.black.withValues(alpha: 0.07),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(context.l10n.emailAddressInputLabel),
                      8.heightBox,
                      _buildTextField(
                        controller: _emailController,
                        hint: context.l10n.emailHint,
                        icon: Icons.mail_outline_rounded,
                      ),
                      20.heightBox,
                      _buildLabel(context.l10n.passwordInputLabel),
                      8.heightBox,
                      _buildTextField(
                        controller: _passwordController,
                        hint: context.l10n.passwordHint,
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isObscure: isObscure,
                        onToggleObscure:
                            () => setState(() => isObscure = !isObscure),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showForgotPasswordDialog,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            context.l10n.forgotPassword,
                            style: AppWidget.bodySmall().copyWith(
                              color: ThemeColor.darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // ─────────────────────────────────────────────────────
                      20.heightBox,

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.darkBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: ThemeColor.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    context.l10n.signInButton,
                                    style: AppWidget.bodyLarge().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ThemeColor.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                24.heightBox,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.dontHaveAccountPrompt,
                      style: AppWidget.bodyMedium().copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => context.replaceRoute(const SignupRoute()),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        context.l10n.signUpTextButton,
                        style: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    _forgotEmailController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        var isSending = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: ThemeColor.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                context.l10n.forgotPassword,
                style: AppWidget.h3TextFieldStyle().copyWith(
                  color: ThemeColor.darkBlue,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.forgotPasswordDescription,
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                  16.heightBox,
                  _buildTextField(
                    controller: _forgotEmailController,
                    hint: context.l10n.emailHint,
                    icon: Icons.mail_outline_rounded,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSending ? null : () => Navigator.pop(dialogContext),
                  child: Text(
                    context.l10n.cancel,
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:
                      isSending
                          ? null
                          : () async {
                            final email = _forgotEmailController.text.trim();
                            if (email.isEmpty) {
                              AppSnackBar.error(
                                context,
                                context.l10n.fillAllFieldsError,
                              );
                              return;
                            }
                            setDialogState(() => isSending = true);
                            await _handleForgotPassword(email, dialogContext);
                            setDialogState(() => isSending = false);
                          },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColor.darkBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        isSending
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: ThemeColor.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              context.l10n.sendResetLink,
                              style: AppWidget.bodyMedium().copyWith(
                                color: ThemeColor.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleForgotPassword(
    String email,
    BuildContext dialogContext,
  ) async {
    await ref.read(authNotifierProvider.notifier).forgotPassword(email: email);

    if (!dialogContext.mounted) {
      return;
    }
    Navigator.pop(dialogContext);

    final authState = ref.read(authNotifierProvider);
    if (authState.hasError) {
      final errorMessage = authState.error.toString().replaceAll(
        'Exception: ',
        '',
      );
      AppSnackBar.error(context, errorMessage);
    } else {
      AppSnackBar.success(context, context.l10n.resetLinkSent);
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF444444),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && isObscure,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: ThemeColor.darkBlue, size: 20),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: onToggleObscure,
                )
                : null,
        filled: true,
        fillColor: const Color(0xFFF7FAFD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0EAF4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0EAF4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThemeColor.darkBlue, width: 1.5),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.error(context, context.l10n.fillAllFieldsError);
      return;
    }

    await ref
        .read(authNotifierProvider.notifier)
        .login(email: email, password: password);

    final authState = ref.read(authNotifierProvider);

    if (authState.hasError) {
      final errorMessage = authState.error.toString().replaceAll(
        'Exception: ',
        '',
      );
      AppSnackBar.error(context, errorMessage);
    } else if (authState.value != null) {
      AppSnackBar.success(context, context.l10n.signInSuccess);
      final userRole = authState.value!.role;
      if (userRole == UserRole.trainer) {
        context.replaceRoute(const TrainerBottomNavRoute());
      } else if (userRole == UserRole.parent) {
        context.replaceRoute(const ParentBottomNavRoute());
      } else if (userRole == UserRole.admin) {
        context.replaceRoute(const AdminLayoutRoute());
      }
    }
  }
}
