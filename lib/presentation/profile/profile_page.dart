import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import '../shared/curved_header_background.dart';
import '../shared/loading_components.dart';
import '../shared/snack_bar.dart';
import '../shared/user_avatar.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState.value;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 155,
              isCurved: true,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    52.heightBox,

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ThemeColor.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ThemeColor.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: UserAvatar(
                            radius: 46,
                            userAvatarUrl: currentUser?.userAvatarUrl,
                            username:
                                currentUser?.name ?? currentUser?.nickname,
                            fontSize: 36,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 70,
                              );

                              if (image != null) {
                                showLoading();

                                try {
                                  final url = await ImageService.uploadToImgBB(
                                    File(image.path),
                                  );
                                  if (url != null && currentUser != null) {
                                    final updatedUser = currentUser.copyWith(
                                      userAvatarUrl: url,
                                    );

                                    await ref
                                        .read(userRepositoryProvider)
                                        .updateUser(updatedUser);

                                    ref.invalidate(authNotifierProvider);

                                    if (context.mounted) {
                                      AppSnackBar.success(
                                        context,
                                        'Profile picture updated successfully!',
                                      );
                                    } else {
                                      if (context.mounted) {
                                        AppSnackBar.error(
                                          context,
                                          'Failed to update profile picture',
                                        );
                                      }
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    AppSnackBar.error(context, 'Error: $e');
                                  }
                                } finally {
                                  closeLoading();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ThemeColor.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: ThemeColor.black.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: ThemeColor.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.heightBox,

                    Text(
                      currentUser?.name ?? currentUser?.nickname ?? 'User',
                      style: AppWidget.h2TextFieldStyle(),
                    ),
                    4.heightBox,
                    Text(
                      '${currentUser?.email ?? ''} | ${currentUser?.phoneNumber ?? 'Please add phone number'}',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    32.heightBox,

                    _buildSettingsGroup(
                      children: [
                        _buildSettingItem(
                          icon: Icons.badge_outlined,
                          title: 'Edit profile information',
                          onTap:
                              () =>
                                  context.router.push(const EditProfileRoute()),
                        ),

                        if (currentUser?.role == UserRole.parent) ...[
                          _buildDivider(),
                          _buildSettingItem(
                            icon: Icons.child_care,
                            title: 'Manage Children',
                            onTap: () {
                              context.router.push(const ManageChildrenRoute());
                            },
                          ),
                        ],

                        if (currentUser?.role == UserRole.trainer) ...[
                          _buildDivider(),
                          _buildSettingItem(
                            icon: Icons.sports_score_outlined,
                            title: 'My Trainer Dashboard',
                            onTap:
                                () => context.router.push(
                                  const TrainerDashboardRoute(),
                                ),
                          ),
                        ],

                        _buildDivider(),
                        _buildSettingItem(
                          icon: Icons.translate,
                          title: 'Language',
                          trailingText: 'English',
                          onTap: () {},
                        ),
                      ],
                    ),

                    _buildSettingsGroup(
                      children: [
                        _buildSettingItem(
                          icon: Icons.wallet_outlined,
                          title: 'Wallet',
                          onTap: () {
                            if (currentUser?.role == UserRole.parent) {
                              context.router.push(const ParentWalletRoute());
                            } else {
                              context.router.push(const TrainerWalletRoute());
                            }
                          },
                        ),

                        _buildDivider(),
                        _buildSettingItem(
                          icon: Icons.chat_bubble_outline,
                          title: 'Contact us',
                          onTap:
                              () => context.router.push(const SupportRoute()),
                        ),
                      ],
                    ),

                    _buildSettingsGroup(
                      children: [
                        _buildSettingItem(
                          icon: Icons.logout_outlined,
                          title: 'Log Out',
                          onTap: () async {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .signOut();

                            context.router.replaceAll([const LoginRoute()]);
                          },
                        ),
                      ],
                    ),

                    8.heightBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56, right: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: ThemeColor.lightGrey.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: ThemeColor.black),
            16.widthBox,
            Expanded(
              child: Text(
                title,
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//TODO: 被approve后应该user自己点击该选项才被redirect到trainer route
