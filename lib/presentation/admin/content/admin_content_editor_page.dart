import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/admin/content/admin_content_editor_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/content_model.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class AdminContentEditorPage extends ConsumerStatefulWidget {
  const AdminContentEditorPage({super.key});

  @override
  ConsumerState<AdminContentEditorPage> createState() =>
      _AdminContentEditorPageState();
}

class _AdminContentEditorPageState
    extends ConsumerState<AdminContentEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();
  final _cpdPointsController = TextEditingController();

  ContentTarget _selectedTarget = ContentTarget.parent;
  ContentType _selectedType = ContentType.article;
  bool _isPublished = false;
  bool _isAdvanced = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _urlController.dispose();
    _cpdPointsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(adminContentEditorNotifierProvider.notifier);

    final cpdPoints =
        (_selectedTarget == ContentTarget.trainer &&
                _selectedType == ContentType.quiz)
            ? (int.tryParse(_cpdPointsController.text.trim()) ?? 0)
            : 0;

    final finalIsAdvanced =
        _selectedTarget == ContentTarget.trainer && _isAdvanced;

    final success = await notifier.createContent(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      contentUrl: _urlController.text.trim(),
      target: _selectedTarget,
      type: _selectedType,
      isPublished: _isPublished,
      cpdPoints: cpdPoints,
      isAdvanced: finalIsAdvanced,
    );

    if (success && mounted) {
      AppSnackBar.success(context, 'Content created successfully!');
      context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(adminContentEditorNotifierProvider);
    final isLoading = editorState is AsyncLoading;

    ref.listen(adminContentEditorNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        AppSnackBar.error(context, 'Failed to create: ${next.error}');
      }
    });

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.white,
        title: Text('Create New Content', style: AppWidget.h3TextFieldStyle()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title *',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      TextFormField(
                        controller: _titleController,
                        decoration: _inputDecoration('Enter content title'),
                        validator:
                            (v) => v!.isEmpty ? 'Title is required' : null,
                      ),
                      24.heightBox,

                      Text(
                        'Description',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: _inputDecoration(
                          'Brief summary of the content',
                        ),
                      ),
                      24.heightBox,

                      Text(
                        'Resource URL (Youtube / Google Drive, etc.) *',
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      TextFormField(
                        controller: _urlController,
                        decoration: _inputDecoration(
                          'e.g., YouTube link or Google Drive PDF',
                        ),
                        validator:
                            (v) =>
                                v!.isEmpty ? 'Resource URL is required' : null,
                      ),
                      24.heightBox,

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Audience',
                                  style: AppWidget.bodyMedium().copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                8.heightBox,
                                DropdownButtonFormField<ContentTarget>(
                                  initialValue: _selectedTarget,
                                  decoration: _inputDecoration(''),
                                  items:
                                      ContentTarget.values.map((target) {
                                        return DropdownMenuItem(
                                          value: target,
                                          child: Text(
                                            target.name.toUpperCase(),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged:
                                      (v) =>
                                          setState(() => _selectedTarget = v!),
                                ),
                              ],
                            ),
                          ),
                          16.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Format Type',
                                  style: AppWidget.bodyMedium().copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                8.heightBox,
                                DropdownButtonFormField<ContentType>(
                                  initialValue: _selectedType,
                                  decoration: _inputDecoration(''),
                                  items:
                                      ContentType.values.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type.name.toUpperCase()),
                                        );
                                      }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      _selectedType = v!;
                                      if (v != ContentType.quiz) {
                                        _cpdPointsController.text = '0';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      24.heightBox,

                      if (_selectedTarget == ContentTarget.trainer) ...[
                        if (_selectedType == ContentType.quiz) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ThemeColor.orange.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ThemeColor.orange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.stars_rounded,
                                      color: ThemeColor.orange,
                                      size: 18,
                                    ),
                                    8.widthBox,
                                    Text(
                                      'CPD Points *',
                                      style: AppWidget.bodyMedium().copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColor.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                4.heightBox,
                                Text(
                                  'Points awarded to trainers upon completing this content.',
                                  style: AppWidget.bodySmall().copyWith(
                                    color: ThemeColor.grey100,
                                  ),
                                ),
                                12.heightBox,
                                TextFormField(
                                  controller: _cpdPointsController,
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration(
                                    'e.g. 10',
                                  ).copyWith(
                                    suffixText: 'pts',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: ThemeColor.orange,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'CPD points is required for trainer content';
                                    }
                                    final pts = int.tryParse(v);
                                    if (pts == null || pts < 0) {
                                      return 'Enter a valid number (0 or more)';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          16.heightBox,
                        ],

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ThemeColor.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ThemeColor.lightGrey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Is Advanced Course?',
                                    style: AppWidget.bodyMedium().copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _isAdvanced
                                        ? 'For approved trainers (earns points)'
                                        : 'For new trainer onboarding (no points)',
                                    style: AppWidget.bodySmall().copyWith(
                                      color:
                                          _isAdvanced
                                              ? ThemeColor.blue
                                              : ThemeColor.grey100,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isAdvanced,
                                activeThumbColor: ThemeColor.blue,
                                onChanged: (v) {
                                  setState(() {
                                    _isAdvanced = v;
                                    if (!v) {
                                      _cpdPointsController.text = '0';
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        24.heightBox,
                      ],

                      // 32.heightBox,
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeColor.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ThemeColor.lightGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Publish Immediately?',
                                  style: AppWidget.bodyMedium().copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'If off, it will be saved as Draft.',
                                  style: AppWidget.bodySmall().copyWith(
                                    color: ThemeColor.grey100,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _isPublished,
                              activeThumbColor: ThemeColor.green,
                              onChanged:
                                  (v) => setState(() => _isPublished = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: ThemeColor.white,
              child: BottomActionButton(
                label: 'Save Content',
                isLoading: isLoading,
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ThemeColor.grey100),
      filled: true,
      fillColor: ThemeColor.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeColor.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeColor.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeColor.darkBlue),
      ),
    );
  }
}
