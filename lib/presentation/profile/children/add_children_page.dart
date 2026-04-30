import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../application/child/child_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/app_text_field.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class AddChildrenPage extends ConsumerStatefulWidget {
  const AddChildrenPage({super.key});

  @override
  ConsumerState<AddChildrenPage> createState() => _AddChildrenPageState();
}

class _AddChildrenPageState extends ConsumerState<AddChildrenPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _remarksController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female'];

  final List<String> _availableTags = [
    'ASD Level 1',
    'ASD Level 2',
    'ASD Level 3',
    'ADHD',
    'Non-verbal',
    'Sensory sensitive',
    'High energy',
    'Loves visual schedules',
  ];

  final List<String> _selectedTags = [];
  final bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChildProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref
          .read(childNotifierProvider.notifier)
          .addChild(
            name: _nameController.text.trim(),
            ageString: _ageController.text.trim(),
            gender: _selectedGender,
            specialNeeds: _selectedTags,
            remarks: _remarksController.text.trim(),
            selectedImage: _selectedImage,
          );

      final notifierState = ref.read(childNotifierProvider);
      if (notifierState.hasError) {
        throw Exception(notifierState.error.toString());
      }

      AppSnackBar.success(context, 'Child profile created successfully!');
      context.pop();
    } catch (e) {
      AppSnackBar.error(context, 'Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        centerTitle: true,
        title: Text('Add Child Profile', style: AppWidget.h2TextFieldStyle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Basic Information', style: AppWidget.h3TextFieldStyle()),
              16.heightBox,

              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: ThemeColor.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeColor.lightGrey,
                            width: 2,
                          ),
                          image:
                              _selectedImage != null
                                  ? DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                        child:
                            _selectedImage == null
                                ? const Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 32,
                                  color: ThemeColor.grey100,
                                )
                                : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: ThemeColor.darkBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: ThemeColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              24.heightBox,

              AppTextField(
                fillColor: ThemeColor.white,
                controller: _nameController,
                label: "Child's Name",
                hintText: 'e.g. Leo',
              ),
              16.heightBox,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      fillColor: ThemeColor.white,
                      controller: _ageController,
                      label: 'Age',
                      hintText: 'e.g. 8',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  16.widthBox,
                  Expanded(flex: 2, child: _buildDropdown()),
                ],
              ),

              32.heightBox,
              const Divider(height: 1),
              24.heightBox,

              Text(
                'Special Needs & Traits',
                style: AppWidget.h3TextFieldStyle(),
              ),
              8.heightBox,
              Text(
                "Select all that apply. This helps our trainers tailor their sessions to your child's needs.",
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              16.heightBox,

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        labelStyle: AppWidget.bodySmall().copyWith(
                          color:
                              isSelected
                                  ? ThemeColor.orange
                                  : ThemeColor.grey100,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: ThemeColor.white,
                        selectedColor: ThemeColor.lightOrange.withValues(
                          alpha: 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? ThemeColor.orange
                                    : ThemeColor.lightGrey,
                          ),
                        ),
                        showCheckmark: false,
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),

              24.heightBox,

              AppTextField(
                fillColor: ThemeColor.white,
                controller: _remarksController,
                label: 'Additional Remarks for Trainer (Optional)',
                hintText:
                    'e.g., Prefers a quiet environment, loves high-fives as reward, allergic to peanuts...',
                maxLines: 4,
              ),

              40.heightBox,

              BottomActionButton(
                label: 'Save Profile',
                onPressed: _isLoading ? null : _saveChildProfile,
              ),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppWidget.bodySmall().copyWith(fontWeight: FontWeight.w600),
        ),
        8.heightBox,
        DropdownButtonFormField<String>(
          initialValue: _selectedGender,
          decoration: InputDecoration(
            filled: true,
            fillColor: ThemeColor.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items:
              _genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender, style: AppWidget.bodyMedium()),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedGender = newValue;
              });
            }
          },
        ),
      ],
    );
  }
}
