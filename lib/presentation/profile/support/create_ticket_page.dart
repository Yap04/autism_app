import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/ticket_model.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({super.key});

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  final List<String> _categories = [
    'Billing & Payment',
    'Appointment / Reschedule',
    'Technical Issue',
    'Trainer Feedback',
    'Other',
  ];
  String? _selectedCategory;

  bool _isLoading = false;

  String _getCategoryName(BuildContext context, String category) {
    switch (category) {
      case 'Billing & Payment':
        return context.l10n.categoryBillingAndPayment;
      case 'Appointment / Reschedule':
        return context.l10n.categoryAppointmentReschedule;
      case 'Technical Issue':
        return context.l10n.categoryTechnicalIssue;
      case 'Trainer Feedback':
        return context.l10n.categoryTrainerFeedback;
      case 'Other':
        return context.l10n.categoryOther;
      default:
        return category;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedCategory == null) {
      AppSnackBar.error(context, context.l10n.pleaseSelectCategory);
      return;
    }

    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final newTicket = TicketModel(
        id: '',
        userId: currentUser.id,
        userRole: currentUser.role.name,
        category: _selectedCategory!,
        lastMessage: _messageController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(ticketRepositoryProvider).createTicket(newTicket);

      if (mounted) {
        AppSnackBar.success(context, context.l10n.ticketSubmittedSuccessfully);
        context.router.maybePop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          context.l10n.failedToSubmitTicket(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 0,
        title: Text(
          context.l10n.newSupportTicketTitle,
          style: AppWidget.h3TextFieldStyle(),
        ),
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeColor.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeColor.blue.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: ThemeColor.blue,
                            ),
                            12.widthBox,
                            Expanded(
                              child: Text(
                                context.l10n.supportTeamResponseTime,
                                style: AppWidget.bodySmall().copyWith(
                                  color: ThemeColor.darkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      32.heightBox,

                      Text(
                        context.l10n.whatDoYouNeedHelpWith,
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        hint: Text(
                          context.l10n.selectCategoryHint,
                          style: const TextStyle(color: ThemeColor.grey100),
                        ),
                        decoration: _inputDecoration(),
                        items:
                            _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  _getCategoryName(context, category),
                                ),
                              );
                            }).toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v),
                      ),
                      24.heightBox,

                      Text(
                        context.l10n.detailsLabel,
                        style: AppWidget.bodyMedium().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      TextFormField(
                        controller: _messageController,
                        maxLines: 6,
                        decoration: _inputDecoration().copyWith(
                          hintText: context.l10n.describeIssueHint,
                        ),
                        validator:
                            (v) =>
                                v!.trim().isEmpty
                                    ? context.l10n.pleaseEnterMessage
                                    : null,
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
                label: context.l10n.submitTicketAction,
                isLoading: _isLoading,
                onPressed: _submitTicket,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
