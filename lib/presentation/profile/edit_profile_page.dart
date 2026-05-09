import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/auth/auth_notifier.dart';
import '../../application/providers/repository_providers.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';
import '../../infrastructure/services/image_service.dart';
import '../shared/bottom_action_button.dart';
import '../shared/snack_bar.dart';
import '../shared/user_avatar.dart';
import 'widgets/gender_selector_field.dart';
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

  bool _isUploadingAvatar = false;

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() => _isUploadingAvatar = true);

    try {
      final file = File(picked.path);
      final url = await ImageService.uploadToImgBB(file);

      if (url == null) {
        AppSnackBar.error(context, 'Failed to upload image');
        return;
      }

      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser == null) {
        return;
      }

      await ref
          .read(userRepositoryProvider)
          .updateUser(currentUser.copyWith(userAvatarUrl: url));

      ref.invalidate(authNotifierProvider);
      AppSnackBar.success(context, 'Profile picture updated!');
    } catch (e) {
      AppSnackBar.error(context, 'Error: $e');
    } finally {
      setState(() => _isUploadingAvatar = false);
    }
  }

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
        backgroundColor: ThemeColor.cream,
        appBar: AppBar(
          backgroundColor: ThemeColor.cream,
          leading:
              canPop
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
                    onPressed: () => context.router.pop(),
                  )
                  : null,
          title: Text('Edit profile', style: AppWidget.h2TextFieldStyle()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              _buildAvatarSection(),
              24.heightBox,

              _buildSectionCard(
                title: 'PERSONAL INFO',
                children: [
                  ProfileInputField(
                    label: 'Full name',
                    controller: _nameController,
                  ),
                  16.heightBox,
                  ProfileInputField(
                    label: 'Nickname',
                    controller: _nicknameController,
                  ),
                  16.heightBox,
                  GenderSelectorField(
                    value: _selectedGender,
                    onChanged:
                        (Gender? v) => setState(() => _selectedGender = v),
                  ),
                ],
              ),
              16.heightBox,

              _buildSectionCard(
                title: 'CONTACT',
                children: [
                  ProfileInputField(
                    label: 'Email address',
                    controller: _emailController,
                    readOnly: true,
                  ),
                  16.heightBox,
                  ProfileInputField(
                    label: 'Phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                ],
              ),
              16.heightBox,

              _buildSectionCard(
                title: 'ADDRESS',
                children: [
                  ProfileInputField(
                    label: 'Address',
                    controller: _addressController,
                  ),
                  16.heightBox,
                  GestureDetector(
                    onTap: () async {
                      final result = await context
                          .pushRoute<Map<String, dynamic>>(
                            const MapPickerRoute(),
                          );
                      if (result != null) {
                        _addressController.text = result['address'] as String;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: ThemeColor.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.map_outlined,
                            color: ThemeColor.orange,
                            size: 20,
                          ),
                          8.widthBox,
                          Text(
                            'Pick location on map',
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              32.heightBox,

              BottomActionButton(
                label: 'Save changes',
                onPressed: () async {
                  if (_nameController.text.trim().isEmpty) {
                    AppSnackBar.error(context, 'Full name is required');
                    return;
                  }

                  if (_phoneController.text.trim().isEmpty) {
                    AppSnackBar.error(context, 'Phone number is required');
                    return;
                  }
                  if (_selectedGender == null) {
                    AppSnackBar.error(context, 'Please select a gender');
                    return;
                  }
                  if (_addressController.text.trim().isEmpty) {
                    AppSnackBar.error(context, 'Address is required');
                    return;
                  }

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
                backgroundColor: ThemeColor.orange,
              ),
              40.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    final currentUser = ref.watch(authNotifierProvider).value;
    return Column(
      children: [
        GestureDetector(
          onTap: _isUploadingAvatar ? null : _pickAndUploadAvatar,
          child: Stack(
            children: [
              UserAvatar(
                radius: 44,
                username:
                    currentUser?.name?.trim().isNotEmpty ?? false
                        ? currentUser!.name
                        : 'New User',
                userAvatarUrl: currentUser?.userAvatarUrl,
                fontSize: 36,
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: ThemeColor.orange,
                    shape: BoxShape.circle,
                  ),
                  child:
                      _isUploadingAvatar
                          ? const Padding(
                            padding: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              color: ThemeColor.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(
                            Icons.edit,
                            size: 14,
                            color: ThemeColor.white,
                          ),
                ),
              ),
            ],
          ),
        ),
        8.heightBox,
        Text(
          currentUser?.name?.trim().isNotEmpty ?? false
              ? currentUser!.name!
              : 'New User',
          style: AppWidget.bodyLarge().copyWith(fontWeight: FontWeight.bold),
        ),
        4.heightBox,
        Text(
          currentUser?.role.name ?? '',
          style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppWidget.bodyExtraSmall().copyWith(
              color: ThemeColor.grey100,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          12.heightBox,
          ...children,
        ],
      ),
    );
  }
}
