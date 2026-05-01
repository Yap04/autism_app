import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../application/auth/auth_notifier.dart';
import '../../application/user/trainer_verification_provider.dart';
import '../../domain/models/user_model.dart';
import '../shared/app_text_field.dart';
import '../shared/bottom_action_button.dart';
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

  final List<String> _availableSports = [
    'Swimming',
    'Football',
    'Basketball',
    'Tennis',
    'Gymnastics',
    'Yoga',
    'Athletics',
    'Badminton',
  ];
  final List<String> _selectedSports = [];

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 70);

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitApplication() async {
    if (_bioController.text.trim().isEmpty) {
      AppSnackBar.error(context, 'Please write a brief bio about yourself.');
      return;
    }
    if (_selectedSports.isEmpty) {
      AppSnackBar.error(
        context,
        'Please select at least one sport you can teach.',
      );
      return;
    }
    if (_selectedImages.isEmpty) {
      AppSnackBar.error(
        context,
        'Please upload at least one relevant certificate.',
      );
      return;
    }

    if (ref.read(trainerVerificationNotifierProvider).isLoading) {
      return;
    }

    try {
      await ref
          .read(trainerVerificationNotifierProvider.notifier)
          .submitApplication(
            certificateImages: _selectedImages,
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
          verificationStatus: VerificationStatus.pending,
        );
        ref.read(authNotifierProvider.notifier).updateLocalUser(updatedUser);
      }

      if (mounted) {
        AppSnackBar.success(
          context,
          'Application submitted successfully! Please wait for admin approval.',
        );
        context.router.maybePop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Error submitting application: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(trainerVerificationNotifierProvider);
    final isLoading = verificationState.isLoading;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        centerTitle: true,
        title: Text('Become a Trainer', style: AppWidget.h2TextFieldStyle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join our community of specialized trainers and make a difference.',
                style: AppWidget.bodyMedium().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              24.heightBox,

              Text('Personal Bio', style: AppWidget.h3TextFieldStyle()),
              8.heightBox,
              Text(
                'Tell us about your experience working with special needs children.',
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              12.heightBox,
              AppTextField(
                fillColor: ThemeColor.white,
                controller: _bioController,
                label: 'Your Experience',
                hintText:
                    'e.g., I have 3 years of experience teaching swimming to children with ASD...',
                maxLines: 5,
              ),

              32.heightBox,
              const Divider(height: 1),
              24.heightBox,

              Text('Sports You Teach', style: AppWidget.h3TextFieldStyle()),
              8.heightBox,
              Text(
                'Select all the sports you are qualified to teach.',
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              16.heightBox,
              Wrap(
                spacing: 6,
                children:
                    _availableSports.map((sport) {
                      final isSelected = _selectedSports.contains(sport);
                      return FilterChip(
                        label: Text(sport),
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
                  Text('Certificates', style: AppWidget.h3TextFieldStyle()),
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      color: ThemeColor.orange,
                    ),
                    label: Text(
                      'Add Images',
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
                'Upload photos of your coaching certifications or special needs training qualifications.',
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              16.heightBox,

              if (_selectedImages.isEmpty)
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
                        'No certificates uploaded yet',
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
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImages[index],
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
                                color: Colors.white,
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
                label: 'Submit Application',
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
