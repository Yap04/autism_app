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
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
  bool rememberMe = false;

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
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Text(
                'Sign In to your Account',
                style: AppWidget.h1TextFieldStyle(),
              ),
              48.heightBox,
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
                      .login(email: email, password: password);

                  final authState = ref.read(authNotifierProvider);

                  if (authState.hasError) {
                    final errorMessage = authState.error.toString().replaceAll(
                      'Exception: ',
                      '',
                    );
                    AppSnackBar.error(context, errorMessage);
                  } else if (authState.value != null) {
                    AppSnackBar.success(context, 'Successfully sign in!');

                    final userRole = authState.value!.role;

                    if (userRole == UserRole.trainer) {
                      context.replaceRoute(const TrainerBottomNavRoute());
                    } else if (userRole == UserRole.parent) {
                      context.replaceRoute(const ParentBottomNavRoute());
                    } else if (userRole == UserRole.admin) {
                      context.replaceRoute(const AdminLayoutRoute());
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
                    child: Text(
                      'Sign in',
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
                    'Does not have an account?',
                    style: TextStyle(color: ThemeColor.grey100),
                  ),
                  TextButton(
                    onPressed: () => context.replaceRoute(const SignupRoute()),
                    child: const Text(
                      'Sign up',
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
