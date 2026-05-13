import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/auth/auth_notifier.dart';
import '../../application/locale/locale_provider.dart';
import '../../application/providers/repository_providers.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/localization_ext.dart';
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

    final currentLocaleCode = ref.watch(localeProvider).languageCode;
    var currentLanguageText = 'English';
    if (currentLocaleCode == 'zh') {
      currentLanguageText = '中文';
    }

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
                                        context
                                            .l10n
                                            .profilePictureUpdatedSuccessfully,
                                      );
                                    } else {
                                      if (context.mounted) {
                                        AppSnackBar.error(
                                          context,
                                          context
                                              .l10n
                                              .failedToUpdateProfilePicture,
                                        );
                                      }
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    AppSnackBar.error(
                                      context,
                                      context.l10n.errorMessage(e.toString()),
                                    );
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
                      currentUser?.name ??
                          currentUser?.nickname ??
                          context.l10n.defaultUser,
                      style: AppWidget.h2TextFieldStyle(),
                    ),
                    4.heightBox,
                    Text(
                      '${currentUser?.email ?? ''} | ${currentUser?.phoneNumber ?? context.l10n.pleaseAddPhoneNumber}',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    32.heightBox,

                    _buildSettingsGroup(
                      children: [
                        _buildSettingItem(
                          icon: Icons.badge_outlined,
                          title: context.l10n.editProfileInformation,
                          onTap:
                              () =>
                                  context.router.push(const EditProfileRoute()),
                        ),

                        if (currentUser?.role == UserRole.parent) ...[
                          _buildDivider(),
                          _buildSettingItem(
                            icon: Icons.child_care,
                            title: context.l10n.manageChildren,
                            onTap: () {
                              context.router.push(const ManageChildrenRoute());
                            },
                          ),
                        ],

                        if (currentUser?.role == UserRole.trainer) ...[
                          _buildDivider(),
                          _buildSettingItem(
                            icon: Icons.sports_score_outlined,
                            title: context.l10n.myTrainerDashboard,
                            onTap:
                                () => context.router.push(
                                  const TrainerDashboardRoute(),
                                ),
                          ),
                        ],

                        _buildDivider(),
                        _buildSettingItem(
                          icon: Icons.translate,
                          title: context.l10n.language,
                          trailingText: currentLanguageText,
                          onTap: () {
                            _showLanguageBottomSheet(context);
                          },
                        ),
                      ],
                    ),

                    _buildSettingsGroup(
                      children: [
                        _buildSettingItem(
                          icon: Icons.wallet_outlined,
                          title: context.l10n.wallet,
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
                          title: context.l10n.contactUs,
                          onTap:
                              () => context.router.push(const SupportRoute()),
                        ),
                      ],
                    ),

                    _buildSettingsGroup(
                      children: [
                        _buildSettingItem(
                          icon: Icons.logout_outlined,
                          title: context.l10n.logOut,
                          onTap: _handleLogout,
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

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: ThemeColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              context.l10n.logOut,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.darkBlue,
              ),
            ),
            content: Text(
              context.l10n.logOutConfirmation,
              style: TextStyle(color: Colors.grey[600]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  context.l10n.cancel,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(dialogContext, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    context.l10n.logOut,
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmed ?? false) {
      await ref.read(authNotifierProvider.notifier).signOut();
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.selectLanguage,
                      style: AppWidget.h2TextFieldStyle(),
                    ),
                    16.heightBox,
                    _buildLanguageOption(context, 'English', 'en'),
                    _buildLanguageOption(context, '中文', 'zh'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
  ) {
    final currentLocaleCode = ref.watch(localeProvider).languageCode;
    final isSelected = currentLocaleCode == languageCode;

    return InkWell(
      onTap: () {
        Navigator.pop(context);

        ref.read(localeProvider.notifier).changeLocale(languageCode);

        AppSnackBar.success(
          context,
          context.l10n.languageChangedTo(languageName),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color:
            isSelected
                ? ThemeColor.orange.withValues(alpha: 0.1)
                : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languageName,
              style: AppWidget.bodyMedium().copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? ThemeColor.orange : ThemeColor.black,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: ThemeColor.orange,
                size: 20,
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
