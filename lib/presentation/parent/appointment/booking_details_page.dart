import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/appointment_model.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/snack_bar.dart';
import '../../shared/user_avatar.dart';

@RoutePage()
class BookingDetailsPage extends ConsumerStatefulWidget {
  const BookingDetailsPage({
    required this.trainerId,
    required this.trainerName,
    required this.sport,
    required this.location,
    super.key,
  });
  final String trainerId;
  final String trainerName;
  final String sport;
  final String location;

  @override
  ConsumerState<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends ConsumerState<BookingDetailsPage> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  int _selectedWeeks = 1;
  final int _maxWeeks = 4;

  final double _sessionPrice = 80;
  late PaymentMethod _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authNotifierProvider).value;
    final initialCredits = user?.sessionCredits ?? 0;

    _selectedPaymentMethod =
        initialCredits >= _selectedWeeks
            ? PaymentMethod.credit
            : PaymentMethod.singlePay;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ThemeColor.darkBlue,
              onSurface: ThemeColor.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: ThemeColor.darkBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitBooking() async {
    if (_selectedTime == null) {
      AppSnackBar.error(context, 'Please select a time.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final totalPrice = _sessionPrice * _selectedWeeks;
      String? stripePaymentId;

      if (_selectedPaymentMethod == PaymentMethod.singlePay) {
        stripePaymentId = await ref
            .read(stripeServiceProvider)
            .makePayment(amount: totalPrice, currency: 'myr');

        if (stripePaymentId == null) {
          if (mounted) {
            AppSnackBar.error(context, 'Payment cancelled or failed.');
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      await ref
          .read(appointmentNotifierProvider.notifier)
          .createAppointment(
            trainerId: widget.trainerId,
            trainerName: widget.trainerName,
            sport: widget.sport,
            location: widget.location,
            dateTime: finalDateTime,
            paymentMethod: _selectedPaymentMethod,
            recurringWeeks: _selectedWeeks,
            stripePaymentIntentId: stripePaymentId,
          );

      if (_selectedPaymentMethod == PaymentMethod.credit) {
        final currentUser = ref.read(authNotifierProvider).value;
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            sessionCredits: currentUser.sessionCredits - _selectedWeeks,
          );
          ref.read(authNotifierProvider.notifier).updateLocalUser(updatedUser);
        }
      }

      if (mounted) {
        context.router.maybePop();
        AppSnackBar.success(context, '$_selectedWeeks Booking(s) Confirmed!');
      }
    } catch (e) {
      AppSnackBar.error(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateWeeks(int weeks) {
    setState(() {
      _selectedWeeks = weeks;
      final user = ref.read(authNotifierProvider).value;
      final currentCredits = user?.sessionCredits ?? 0;

      if (currentCredits < _selectedWeeks &&
          _selectedPaymentMethod == PaymentMethod.credit) {
        _selectedPaymentMethod = PaymentMethod.singlePay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    final credits = user?.sessionCredits ?? 0;

    final trainerImageUrl =
        ref
            .watch(fetchTrainerProvider(widget.trainerId))
            .asData
            ?.value
            ?.userAvatarUrl;

    final requiredCredits = _selectedWeeks;
    final totalPrice = _sessionPrice * _selectedWeeks;
    final hasEnoughCredits = credits >= requiredCredits;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        title: Text('Booking Details', style: AppWidget.h3TextFieldStyle()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTrainerCard(trainerImageUrl),

                    32.heightBox,

                    Text('Schedule', style: AppWidget.h3TextFieldStyle()),
                    16.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: _buildSelectionContainer(
                            icon: Icons.calendar_month,
                            text:
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            onTap: _pickDate,
                          ),
                        ),
                        12.widthBox,
                        Expanded(
                          child: _buildSelectionContainer(
                            icon: Icons.access_time,
                            text:
                                _selectedTime?.format(context) ?? 'Select Time',
                            onTap: _pickTime,
                          ),
                        ),
                      ],
                    ),

                    24.heightBox,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Repeat Booking',
                          style: AppWidget.h3TextFieldStyle(),
                        ),
                        Text(
                          'Max $_maxWeeks weeks',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                          ),
                        ),
                      ],
                    ),
                    8.heightBox,
                    Text(
                      'Book this same time slot for consecutive weeks.',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    16.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_maxWeeks, (index) {
                        final weeks = index + 1;
                        return _buildWeekOption(weeks);
                      }),
                    ),

                    32.heightBox,

                    Text('Payment Method', style: AppWidget.h3TextFieldStyle()),
                    16.heightBox,
                    _buildPaymentOption(
                      method: PaymentMethod.credit,
                      title: 'Use Session Credit',
                      subtitle:
                          hasEnoughCredits
                              ? 'Balance: $credits | Required: $requiredCredits'
                              : 'Not enough credits (Need $requiredCredits, Have $credits)',
                      isDisabled: !hasEnoughCredits,
                    ),
                    12.heightBox,
                    _buildPaymentOption(
                      method: PaymentMethod.singlePay,
                      title: 'Pay Per Session',
                      subtitle: 'Total: RM ${totalPrice.toStringAsFixed(2)}',
                      isDisabled: false,
                    ),

                    16.heightBox,
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: ThemeColor.cream,
              child: BottomActionButton(
                label:
                    _selectedPaymentMethod == PaymentMethod.credit
                        ? 'Confirm & Deduct $requiredCredits Credit(s)'
                        : 'Proceed to Pay RM ${totalPrice.toStringAsFixed(2)}',
                isLoading: _isLoading,
                onPressed: _submitBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerCard(String? imageUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(
            radius: 36,
            userAvatarUrl: imageUrl,
            username: widget.trainerName,
          ),
          16.widthBox,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.trainerName,
                  style: AppWidget.bodyLarge().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                8.heightBox,

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColor.aquaBlue.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        size: 14,
                        color: ThemeColor.darkBlue,
                      ),
                      4.widthBox,
                      Text(
                        widget.sport,
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                8.heightBox,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: ThemeColor.grey100,
                    ),
                    4.widthBox,
                    Expanded(
                      child: Text(
                        widget.location,
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.grey100,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionContainer({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeColor.lightGrey),
        ),
        child: Row(
          children: [
            Icon(icon, color: ThemeColor.darkBlue, size: 20),
            8.widthBox,
            Expanded(
              child: Text(
                text,
                style: AppWidget.bodyLarge().copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekOption(int weeks) {
    final isSelected = _selectedWeeks == weeks;
    return GestureDetector(
      onTap: () => _updateWeeks(weeks),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColor.darkBlue : ThemeColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ThemeColor.darkBlue : ThemeColor.lightGrey,
          ),
        ),
        child: Center(
          child: Text(
            weeks == 1 ? '1 Wk' : '$weeks Wks',
            style: AppWidget.bodyMedium().copyWith(
              color: isSelected ? ThemeColor.white : ThemeColor.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required bool isDisabled,
  }) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap:
          isDisabled
              ? null
              : () => setState(() => _selectedPaymentMethod = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? ThemeColor.grey100.withValues(alpha: 0.1)
                  : ThemeColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ThemeColor.darkBlue : ThemeColor.lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  isDisabled
                      ? ThemeColor.grey100
                      : (isSelected
                          ? ThemeColor.darkBlue
                          : ThemeColor.lightGrey),
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppWidget.bodyLarge().copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDisabled ? ThemeColor.grey100 : ThemeColor.black,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    subtitle,
                    style: AppWidget.bodySmall().copyWith(
                      color:
                          isDisabled
                              ? ThemeColor.grey100
                              : (isSelected
                                  ? ThemeColor.darkBlue
                                  : ThemeColor.grey100),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
