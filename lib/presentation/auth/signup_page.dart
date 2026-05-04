import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
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
  bool rememberMe = false;

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
      appBar: AppBar(
        backgroundColor: ThemeColor.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Text('Create your Account', style: AppWidget.h1TextFieldStyle()),
              32.heightBox,

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => setState(() => _selectedRole = UserRole.parent),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color:
                              _selectedRole == UserRole.parent
                                  ? ThemeColor.darkBlue
                                  : ThemeColor.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeColor.darkBlue,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'I am a Parent',
                            style: AppWidget.bodySmall().copyWith(
                              color:
                                  _selectedRole == UserRole.parent
                                      ? ThemeColor.white
                                      : ThemeColor.darkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.widthBox,
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () =>
                              setState(() => _selectedRole = UserRole.trainer),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color:
                              _selectedRole == UserRole.trainer
                                  ? ThemeColor.darkBlue
                                  : ThemeColor.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeColor.darkBlue,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'I am a Coach',
                            style: AppWidget.bodySmall().copyWith(
                              color:
                                  _selectedRole == UserRole.trainer
                                      ? ThemeColor.white
                                      : ThemeColor.darkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              32.heightBox,

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: ThemeColor.aquaBlue,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'Email',
                  hintStyle: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.darkBlue,
                  ),
                  prefixIcon: const Icon(
                    Icons.mail,
                    color: ThemeColor.darkBlue,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              16.heightBox,
              TextField(
                controller: _passwordController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  fillColor: ThemeColor.aquaBlue,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'Password',
                  hintStyle: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.darkBlue,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: ThemeColor.darkBlue,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: ThemeColor.darkBlue,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              28.heightBox,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? newValue) {
                      setState(() {
                        rememberMe = newValue ?? false;
                      });
                    },
                    activeColor: ThemeColor.darkBlue,
                    side: const BorderSide(color: ThemeColor.black, width: 2),
                  ),
                  const Text('Remember me'),
                ],
              ),

              10.heightBox,

              GestureDetector(
                onTap: () async {
                  if (isLoading) {
                    return;
                  }

                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    AppSnackBar.error(context, 'Please fill in all fields');
                    return;
                  }
                  await ref
                      .read(authNotifierProvider.notifier)
                      .register(
                        email: email,
                        password: password,
                        role: _selectedRole,
                      );

                  final authState = ref.read(authNotifierProvider);

                  if (authState.hasError) {
                    final errorMessage = authState.error.toString().replaceAll(
                      'Exception: ',
                      '',
                    );
                    AppSnackBar.error(context, errorMessage);
                  } else if (authState.value != null) {
                    AppSnackBar.success(context, 'Successfully registered!');

                    final user = authState.value!;

                    if (user.role == UserRole.trainer) {
                      context.replaceRoute(const EditProfileRoute());
                    } else {
                      if (user.name?.isEmpty ?? true) {
                        context.replaceRoute(const EditProfileRoute());
                      } else {
                        context.replaceRoute(const ParentBottomNavRoute());
                      }
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeColor.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: ThemeColor.white,
                            )
                            : Text(
                              'Sign up',
                              style: AppWidget.bodyMedium().copyWith(
                                color: ThemeColor.white,
                              ),
                            ),
                  ),
                ),
              ),

              64.heightBox,
              const Text('or continue with'),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(FontAwesomeIcons.google),
                  _buildSocialIcon(FontAwesomeIcons.twitter),
                  _buildSocialIcon(FontAwesomeIcons.facebook),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: ThemeColor.grey100),
                  ),
                  TextButton(
                    onPressed: () => context.replaceRoute(const LoginRoute()),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: ThemeColor.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColor.black,
      ),
      child: FaIcon(icon, color: ThemeColor.white),
    );
  }
}
