import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../application/auth/auth_notifier.dart';
import '../../application/user/trainer_verification_provider.dart';
import '../../core/constant/sport_constant.dart';
import '../../core/extension/sport_ext.dart';
import '../../core/routes/app_router.dart';
import '../../domain/models/user_model.dart';
import '../shared/app_text_field.dart';
import '../shared/bottom_action_button.dart';
import '../shared/cached_image.dart';
import '../shared/snack_bar.dart';

@RoutePage()
class TrainerVerificationPage extends ConsumerStatefulWidget {
  const TrainerVerificationPage({super.key});

  @override
  ConsumerState<TrainerVerificationPage> createState() =>
      _TrainerVerificationPageState();
}

class _TrainerVerificationPageState
    extends ConsumerState<TrainerVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();

  final List<String> _selectedSports = [];

  final List<File> _selectedLocalImages = [];
  final List<String> _existingImagesUrls = [];

  final ImagePicker _picker = ImagePicker();

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        if (user.bio != null) {
          _bioController.text = user.bio!;
        }
        if (user.sports.isNotEmpty) {
          _selectedSports.addAll(user.sports);
        }
        if (user.certificateUrls != null && user.certificateUrls!.isNotEmpty) {
          _existingImagesUrls.addAll(user.certificateUrls!);
        }
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 70);

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedLocalImages.addAll(
          pickedFiles.map((xFile) => File(xFile.path)),
        );
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedLocalImages.removeAt(index);
    });
  }

  Future<void> _submitApplication() async {
    if (_bioController.text.trim().isEmpty) {
      AppSnackBar.error(context, context.l10n.pleaseWriteBriefBio);
      return;
    }
    if (_selectedSports.isEmpty) {
      AppSnackBar.error(context, context.l10n.pleaseSelectAtLeastOneSport);
      return;
    }
    if (_selectedLocalImages.isEmpty && _existingImagesUrls.isEmpty) {
      AppSnackBar.error(context, context.l10n.pleaseUploadCertificate);
      return;
    }

    if (ref.read(trainerVerificationNotifierProvider).isLoading) {
      return;
    }

    try {
      await ref
          .read(trainerVerificationNotifierProvider.notifier)
          .submitApplication(
            certificateImages: _selectedLocalImages,
            existingUrls: _existingImagesUrls,
            selectedSports: _selectedSports,
            bio: _bioController.text.trim(),
          );

      final notifierState = ref.read(trainerVerificationNotifierProvider);
      if (notifierState.hasError) {
        throw Exception(notifierState.error.toString());
      }

      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          certificateUrls: ['submitted'],
          verificationStatus: VerificationStatus.pending,
        );
        ref.read(authNotifierProvider.notifier).updateLocalUser(updatedUser);
      }

      if (mounted) {
        AppSnackBar.success(
          context,
          context.l10n.applicationSubmittedWaitAdmin,
        );
        context.replaceRoute(const TrainerBottomNavRoute());
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          context.l10n.errorSubmittingApplication(e.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(trainerVerificationNotifierProvider);
    final isLoading = verificationState.isLoading;

    final currentUser = ref.watch(authNotifierProvider).value;
    final isPending =
        currentUser?.verificationStatus == VerificationStatus.pending;
    final isRejected =
        currentUser?.verificationStatus == VerificationStatus.rejected;

    final totalImagesCount =
        _existingImagesUrls.length + _selectedLocalImages.length;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        centerTitle: true,
        leading:
            isPending || isRejected
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
                  onPressed: () {
                    context.router.replaceAll([const LoginRoute()]);
                  },
                )
                : null,
        title: Text(
          context.l10n.becomeTrainerTitle,
          style: AppWidget.h2TextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isRejected) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeColor.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeColor.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: ThemeColor.red,
                            size: 20,
                          ),
                          8.widthBox,
                          Text(
                            'Application Rejected',
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      8.heightBox,
                      Text(
                        currentUser?.rejectReason ??
                            'Your application was rejected. Please update your details and resubmit.',
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.red,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                24.heightBox,
              ],

              Text(
                context.l10n.joinTrainerCommunityDescription,
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              24.heightBox,

              Text(
                context.l10n.personalBioTitle,
                style: AppWidget.h3TextFieldStyle(),
              ),
              8.heightBox,
              Text(
                context.l10n.experienceWithSpecialNeedsDescription,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              12.heightBox,
              AppTextField(
                fillColor: ThemeColor.white,
                controller: _bioController,
                label: context.l10n.yourExperienceLabel,
                hintText: context.l10n.experienceHintText,
                maxLines: 5,
              ),

              32.heightBox,
              const Divider(height: 1),
              24.heightBox,

              Text(
                context.l10n.sportsYouTeachTitle,
                style: AppWidget.h3TextFieldStyle(),
              ),
              8.heightBox,
              Text(
                context.l10n.selectQualifiedSportsDescription,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              16.heightBox,
              Wrap(
                spacing: 6,
                children:
                    sportCategories.skip(1).map((sport) {
                      final isSelected = _selectedSports.contains(sport);
                      return FilterChip(
                        label: Text(sport.toLocalizedSport(context)),
                        labelStyle: AppWidget.bodySmall().copyWith(
                          color:
                              isSelected ? ThemeColor.white : ThemeColor.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: ThemeColor.white,
                        selectedColor: ThemeColor.darkBlue,
                        checkmarkColor: ThemeColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? ThemeColor.darkBlue
                                    : ThemeColor.lightGrey,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedSports.add(sport);
                            } else {
                              _selectedSports.remove(sport);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),

              32.heightBox,
              const Divider(height: 1),
              24.heightBox,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.icAndCertificatesTitle,
                    style: AppWidget.h3TextFieldStyle(),
                  ),
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      color: ThemeColor.orange,
                    ),
                    label: Text(
                      context.l10n.addImagesAction,
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              8.heightBox,
              Text(
                context.l10n.uploadIcAndCertificatesDescription,
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              16.heightBox,

              if (totalImagesCount == 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: ThemeColor.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ThemeColor.lightGrey),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.upload_file,
                        size: 40,
                        color: ThemeColor.lightGrey,
                      ),
                      8.heightBox,
                      Text(
                        context.l10n.noPhotosUploadedYet,
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.grey100,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: totalImagesCount,
                  itemBuilder: (context, index) {
                    final isExistingImage = index < _existingImagesUrls.length;

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              isExistingImage
                                  ? CachedImage(
                                    imageUrl: _existingImagesUrls[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    borderRadius: 0,
                                  )
                                  : Image.file(
                                    _selectedLocalImages[index -
                                        _existingImagesUrls.length],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: ThemeColor.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              40.heightBox,
              BottomActionButton(
                label:
                    isRejected
                        ? 'Resubmit Application'
                        : context.l10n.submitApplicationAction,
                isLoading: isLoading,
                onPressed: isLoading ? null : _submitApplication,
              ),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
