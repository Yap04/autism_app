import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../application/providers/repository_providers.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';
import '../shared/snack_bar.dart';
import 'widgets/gender_dropdown_field.dart';
import 'widgets/profile_input_field.dart';

@RoutePage()
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();

    final currentUser = ref.read(authNotifierProvider).value;

    if (currentUser != null) {
      _nameController.text = currentUser.name ?? '';
      _nicknameController.text = currentUser.nickname ?? '';
      _addressController.text = currentUser.address ?? '';
      _emailController.text = currentUser.email;

      if (currentUser.phoneNumber != null) {
        final phone = currentUser.phoneNumber!;
        if (phone.startsWith('+60')) {
          _phoneController.text = phone.substring(3);
        } else {
          _phoneController.text = phone;
        }
      }

      _selectedGender = currentUser.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(authNotifierProvider)
      ..listen(authNotifierProvider, (previous, next) {
        final user = next.value;
        if (previous?.value == null && user != null) {
          _nameController.text = user.name ?? '';
          _nicknameController.text = user.nickname ?? '';
          _addressController.text = user.address ?? '';
          _emailController.text = user.email;

          if (user.phoneNumber != null) {
            final phone = user.phoneNumber!;
            if (phone.startsWith('+60')) {
              _phoneController.text = phone.substring(3);
            } else {
              _phoneController.text = phone;
            }
          }

          setState(() => _selectedGender = user.gender);
        }
      });

    final canPop = context.router.canPop();

    return PopScope(
      canPop: canPop,
      child: Scaffold(
        backgroundColor: ThemeColor.white,
        appBar: AppBar(
          backgroundColor: ThemeColor.white,
          leading:
              canPop
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
                    onPressed: () => context.router.pop(),
                  )
                  : null,
          title: Text('Edit profile', style: AppWidget.h2TextFieldStyle()),
          centerTitle: true,

          actions: [
            if (!canPop)
              TextButton(
                onPressed: () {
                  final currentUser = ref.read(authNotifierProvider).value;

                  if (currentUser?.role == UserRole.trainer) {
                    context.router.replace(const TrainerBottomNavRoute());
                    return;
                  } else {
                    context.router.replace(const ParentBottomNavRoute());
                  }
                },
                child: Text(
                  'Skip',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              ProfileInputField(
                label: 'Full name',
                controller: _nameController,
              ),
              16.heightBox,

              ProfileInputField(
                label: 'Nick name',
                controller: _nicknameController,
              ),
              16.heightBox,

              ProfileInputField(
                label: 'Email Address',
                controller: _emailController,
                readOnly: true,
              ),
              16.heightBox,

              ProfileInputField(
                label: 'Phone number',
                controller: _phoneController,
                prefixWidget: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      const Text('🇲🇾', style: TextStyle(fontSize: 20)),
                      8.widthBox,
                      Text(
                        '+60',
                        style: AppWidget.bodyLarge().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.widthBox,
                      Container(
                        width: 1,
                        height: 20,
                        color: ThemeColor.grey100.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              16.heightBox,

              GenderDropdownField(
                value: _selectedGender,
                onChanged: (Gender? newValue) {
                  setState(() => _selectedGender = newValue);
                },
              ),
              16.heightBox,

              ProfileInputField(
                label: 'Address',
                controller: _addressController,
              ),
              40.heightBox,

              GestureDetector(
                onTap: () async {
                  final currentUser = ref.read(authNotifierProvider).value;
                  if (currentUser == null) {
                    return;
                  }

                  final rawPhone = _phoneController.text.trim();
                  final fullPhone = rawPhone.isNotEmpty ? '+60$rawPhone' : null;

                  final updatedUser = currentUser.copyWith(
                    name:
                        _nameController.text.trim().isEmpty
                            ? null
                            : _nameController.text.trim(),
                    nickname:
                        _nicknameController.text.trim().isEmpty
                            ? null
                            : _nicknameController.text.trim(),
                    phoneNumber: fullPhone,
                    gender: _selectedGender,
                    address:
                        _addressController.text.trim().isEmpty
                            ? null
                            : _addressController.text.trim(),
                  );

                  try {
                    await ref
                        .read(userRepositoryProvider)
                        .updateUser(updatedUser);

                    ref.invalidate(authNotifierProvider);

                    AppSnackBar.success(
                      context,
                      'Profile updated successfully!',
                    );

                    if (canPop) {
                      context.router.pop();
                    } else {
                      if (currentUser.role == UserRole.trainer) {
                        context.router.replace(const TrainerBottomNavRoute());
                      } else {
                        context.router.replace(const ParentBottomNavRoute());
                      }
                    }
                  } catch (e) {
                    AppSnackBar.error(context, 'Failed to update profile: $e');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ThemeColor.orange,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColor.orange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'SUBMIT',
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              40.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
