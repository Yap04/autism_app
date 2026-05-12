import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/extension/localization_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';
import '../shared/snack_bar.dart';

@RoutePage()
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  UserRole _selectedRole = UserRole.parent;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  context.l10n.createAccount,
                  style: AppWidget.h1TextFieldStyle().copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.darkBlue,
                  ),
                ),
                6.heightBox,
                Text(
                  context.l10n.joinUsTodayFree,
                  style: AppWidget.bodySmall().copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                32.heightBox,

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Text(
                        context.l10n.iAmA,
                        style: AppWidget.bodySmall().copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                      10.heightBox,
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildRoleTab(
                              label: context.l10n.roleParent,
                              icon: Icons.family_restroom,
                              role: UserRole.parent,
                            ),
                            _buildRoleTab(
                              label: context.l10n.roleCoach,
                              icon: Icons.sports,
                              role: UserRole.trainer,
                            ),
                          ],
                        ),
                      ),

                      24.heightBox,

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
                        hint: context.l10n.passwordMinLengthHint,
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isObscure: isObscure,
                        onToggleObscure:
                            () => setState(() => isObscure = !isObscure),
                      ),

                      32.heightBox,

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.darkBlue,
                            foregroundColor: ThemeColor.white,
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
                                    context.l10n.createAccount,
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
                      context.l10n.alreadyHaveAccountPrompt,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () => context.replaceRoute(const LoginRoute()),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        context.l10n.signInTextButton,
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

  Widget _buildRoleTab({
    required String label,
    required IconData icon,
    required UserRole role,
  }) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? ThemeColor.darkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? ThemeColor.white : Colors.grey[500],
              ),
              6.widthBox,
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _handleSignup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.error(context, context.l10n.fillAllFieldsError);
      return;
    }

    await ref
        .read(authNotifierProvider.notifier)
        .register(email: email, password: password, role: _selectedRole);

    final authState = ref.read(authNotifierProvider);

    if (authState.hasError) {
      final errorMessage = authState.error.toString().replaceAll(
        'Exception: ',
        '',
      );
      AppSnackBar.error(context, errorMessage);
    } else if (authState.value != null) {
      AppSnackBar.success(context, context.l10n.signUpSuccess);
      final user = authState.value!;
      if (user.role == UserRole.trainer || (user.name?.isEmpty ?? true)) {
        context.replaceRoute(const EditProfileRoute());
      } else {
        context.replaceRoute(const ParentBottomNavRoute());
      }
    }
  }
}
