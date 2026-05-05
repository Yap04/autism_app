import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/appointment/appointment_notifier.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../application/child/child_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/appointment_model.dart';
import '../../../domain/models/child_model.dart';
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
  ChildModel? _selectedChild;
  bool _isLoading = false;

  int _selectedWeeks = 1;
  final int _maxWeeks = 4;

  int _selectedDuration = 60;

  final double _hourlyPrice = 80;
  late PaymentMethod _selectedPaymentMethod;

  String? _selectedSport;

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

  String _getEndTimeString(BuildContext context) {
    if (_selectedTime == null) return '';

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final endDateTime = startDateTime.add(Duration(minutes: _selectedDuration));

    return DateFormat('hh:mm a').format(endDateTime);
  }

  bool _isDaySelectable(DateTime day, List<dynamic>? operatingHours) {
    if (operatingHours == null || operatingHours.isEmpty) {
      return true;
    }

    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final dayString = weekdays[day.weekday - 1];

    final dayConfig = operatingHours.firstWhere(
      (e) => (e as Map)['day'] == dayString,
      orElse: () => null,
    );

    if (dayConfig != null) {
      return (dayConfig as Map)['isOpen'] == true;
    }
    return true;
  }

  //TODO: _AssertionError ('package:flutter/src/material/date_picker.dart': Failed assertion: line 243 pos 5: 'selectableDayPredicate == null || initialDate == null || selectableDayPredicate(initialDate)': Provided initialDate 2026-05-04 00:00:00.000 must satisfy provided selectableDayPredicate.)
  //TODO: if not select chid, prompt user
  Future<void> _pickDate() async {
    final trainer =
        ref.read(fetchTrainerProvider(widget.trainerId)).asData?.value;
    final operatingHours = trainer?.operatingHours;

    var validInitialDate = _selectedDate;
    var attempts = 0;
    while (!_isDaySelectable(validInitialDate, operatingHours) &&
        attempts < 30) {
      validInitialDate = validInitialDate.add(const Duration(days: 1));
      attempts++;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime day) {
        return _isDaySelectable(day, operatingHours);
      },
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: ThemeColor.darkBlue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final pickedMinutes = picked.hour * 60 + picked.minute;

      final now = DateTime.now();
      final isToday =
          _selectedDate.year == now.year &&
          _selectedDate.month == now.month &&
          _selectedDate.day == now.day;

      if (isToday) {
        final nowMinutes = now.hour * 60 + now.minute;
        if (pickedMinutes <= nowMinutes) {
          if (mounted) {
            AppSnackBar.error(context, 'Please select a future time.');
          }
          return;
        }
      }

      final trainer =
          ref.read(fetchTrainerProvider(widget.trainerId)).asData?.value;
      final operatingHours = trainer?.operatingHours;

      var startStr = '08:00 AM';
      var endStr = '10:00 PM';

      if (operatingHours != null && operatingHours.isNotEmpty) {
        final weekdays = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ];
        final dayString = weekdays[_selectedDate.weekday - 1];

        final dayConfig = operatingHours.firstWhere(
          (e) => (e as Map)['day'] == dayString,
          orElse: () => null,
        );

        if (dayConfig != null && (dayConfig as Map)['isOpen'] == true) {
          startStr = dayConfig['start'].toString();
          endStr = dayConfig['end'].toString();
        }
      }

      try {
        final format = DateFormat('hh:mm a');
        final startTime = format.parse(startStr);
        final endTime = format.parse(endStr);

        final pickedMinutes = picked.hour * 60 + picked.minute;
        final startMinutes = startTime.hour * 60 + startTime.minute;
        final endMinutes = endTime.hour * 60 + endTime.minute;

        if (pickedMinutes >= startMinutes && pickedMinutes <= endMinutes) {
          setState(() => _selectedTime = picked);
        } else {
          if (mounted) {
            AppSnackBar.error(
              context,
              'Please select a time between $startStr and $endStr.',
            );
          }
        }
      } catch (e) {
        setState(() => _selectedTime = picked);
      }
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

      if (finalDateTime.isBefore(DateTime.now())) {
        setState(() => _isLoading = false);
        AppSnackBar.error(
          context,
          'Cannot book a session in the past. Please select a future time.',
        );
        return;
      }

      final totalPrice = _hourlyPrice * _selectedWeeks;
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
            childId: _selectedChild!.id,
            childName: _selectedChild!.name,
            childAvatarUrl: _selectedChild?.userAvatarUrl,
            trainerId: widget.trainerId,
            trainerName: widget.trainerName,
            sport: _selectedSport ?? widget.sport,
            location: widget.location,
            dateTime: finalDateTime,
            duration: _selectedDuration,
            paymentMethod: _selectedPaymentMethod,
            recurringWeeks: _selectedWeeks,
            stripePaymentIntentId: stripePaymentId,
          );

      if (_selectedPaymentMethod == PaymentMethod.credit) {
        final currentUser = ref.read(authNotifierProvider).value;
        if (currentUser != null) {
          final requiredCredits = (_selectedDuration ~/ 60) * _selectedWeeks;
          final updatedUser = currentUser.copyWith(
            sessionCredits: currentUser.sessionCredits - requiredCredits,
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

      final requiredCredits = (_selectedDuration ~/ 60) * _selectedWeeks;

      if (currentCredits < requiredCredits &&
          _selectedPaymentMethod == PaymentMethod.credit) {
        _selectedPaymentMethod = PaymentMethod.singlePay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    final credits = user?.sessionCredits ?? 0;

    final trainerAsync = ref.watch(fetchTrainerProvider(widget.trainerId));
    final trainer = trainerAsync.asData?.value;
    final trainerImageUrl = trainer?.userAvatarUrl;
    final operatingHours = trainer?.operatingHours;

    final childrenAsync = ref.watch(userChildrenProvider);

    final availableSports =
        (trainer?.sports != null && trainer!.sports.isNotEmpty)
            ? trainer.sports
            : [widget.sport];

    if (_selectedSport == null && availableSports.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedSport = availableSports.first);
        }
      });
    }

    final displaySport = _selectedSport ?? widget.sport;

    if (operatingHours != null &&
        !_isDaySelectable(_selectedDate, operatingHours)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var nextValidDate = _selectedDate;
        for (var i = 0; i < 30; i++) {
          nextValidDate = nextValidDate.add(const Duration(days: 1));
          if (_isDaySelectable(nextValidDate, operatingHours)) {
            if (mounted) {
              setState(() => _selectedDate = nextValidDate);
            }
            break;
          }
        }
      });
    }

    // Credit Required: 1 hour = 1 credit. 2 hours = 2 credits. Then multiply by weeks.
    final durationInHours = _selectedDuration / 60.0;
    final requiredCredits = (_selectedDuration ~/ 60) * _selectedWeeks;
    final totalPrice = _hourlyPrice * durationInHours * _selectedWeeks;
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
                    _buildTrainerCard(trainerImageUrl, displaySport),

                    24.heightBox,

                    Text('Book for Child', style: AppWidget.h3TextFieldStyle()),
                    8.heightBox,
                    Text(
                      'Select the child profile for this session.',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    16.heightBox,
                    childrenAsync.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error: (e, stack) => Text('Error loading children: $e'),
                      data: (children) {
                        // 极端情况：家长还没有添加任何孩子
                        if (children.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ThemeColor.lightOrange.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ThemeColor.orange.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: ThemeColor.orange,
                                ),
                                12.widthBox,
                                Expanded(
                                  child: Text(
                                    'Please add a child profile first in the "Manage Children" page before booking.',
                                    style: AppWidget.bodySmall().copyWith(
                                      color: ThemeColor.darkBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // 正常情况：展示下拉框
                        return DropdownButtonFormField<ChildModel>(
                          isExpanded: true,
                          initialValue: _selectedChild,
                          hint: Text(
                            'Select your child',
                            style: AppWidget.bodyMedium().copyWith(
                              color: ThemeColor.grey100,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ThemeColor.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: ThemeColor.lightGrey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: ThemeColor.lightGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: ThemeColor.darkBlue,
                                width: 2,
                              ),
                            ),
                          ),
                          items:
                              children.map((ChildModel child) {
                                return DropdownMenuItem<ChildModel>(
                                  value: child,
                                  child: Row(
                                    children: [
                                      // 下拉框里也能显示孩子的名字和年龄，体验更好
                                      Expanded(
                                        child: Text(
                                          child.name,
                                          style: AppWidget.bodyMedium()
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      8.widthBox,
                                      Text(
                                        '(${child.age}y)',
                                        style: AppWidget.bodySmall().copyWith(
                                          color: ThemeColor.grey100,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                          onChanged: (ChildModel? newValue) {
                            setState(() {
                              _selectedChild = newValue;
                            });
                          },
                        );
                      },
                    ),

                    32.heightBox,

                    Text('Select Sport', style: AppWidget.h3TextFieldStyle()),
                    16.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            availableSports.map((sport) {
                              final isSelected = _selectedSport == sport;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  onTap:
                                      () => setState(
                                        () => _selectedSport = sport,
                                      ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? ThemeColor.darkBlue
                                              : ThemeColor.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? ThemeColor.darkBlue
                                                : ThemeColor.lightGrey,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          getSportIcon(sport),
                                          color:
                                              isSelected
                                                  ? ThemeColor.white
                                                  : ThemeColor.darkBlue,
                                          size: 18,
                                        ),
                                        8.widthBox,
                                        Text(
                                          sport,
                                          style: AppWidget.bodyMedium()
                                              .copyWith(
                                                color:
                                                    isSelected
                                                        ? ThemeColor.white
                                                        : ThemeColor.black,
                                                fontWeight:
                                                    isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    24.heightBox,

                    _buildOperatingHoursSection(operatingHours),

                    24.heightBox,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duration', style: AppWidget.h3TextFieldStyle()),
                      ],
                    ),
                    8.heightBox,
                    Text(
                      'Select the length of each session.',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    16.heightBox,
                    Row(
                      children: [
                        _buildDurationOption(60, '1 Hour'),
                        _buildDurationOption(120, '2 Hours'),
                      ],
                    ),

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

                    if (_selectedTime != null) ...[
                      8.heightBox,
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'This session will end at ${_getEndTimeString(context)}.',
                          style: AppWidget.bodyExtraSmall().copyWith(
                            color: ThemeColor.darkBlue,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],

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

  Widget _buildTrainerCard(String? imageUrl, String selectedSport) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                          Icon(
                            getSportIcon(selectedSport),
                            size: 14,
                            color: ThemeColor.darkBlue,
                          ),
                          4.widthBox,
                          Text(
                            selectedSport,
                            style: AppWidget.bodySmall().copyWith(
                              color: ThemeColor.darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          16.heightBox,
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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

  Widget _buildDurationOption(int minutes, String label) {
    final isSelected = _selectedDuration == minutes;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDuration = minutes;
            final user = ref.read(authNotifierProvider).value;
            final currentCredits = user?.sessionCredits ?? 0;
            final requiredCredits = (minutes ~/ 60) * _selectedWeeks;

            if (currentCredits < requiredCredits &&
                _selectedPaymentMethod == PaymentMethod.credit) {
              _selectedPaymentMethod = PaymentMethod.singlePay;
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
              label,
              style: AppWidget.bodyMedium().copyWith(
                color: isSelected ? ThemeColor.white : ThemeColor.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
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

  Widget _buildOperatingHoursSection(List<dynamic>? operatingHours) {
    final defaultSchedule = <Map<String, dynamic>>[
      {'day': 'Monday', 'isOpen': true, 'start': '08:00 AM', 'end': '10:00 PM'},
      {
        'day': 'Tuesday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {
        'day': 'Wednesday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {
        'day': 'Thursday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {'day': 'Friday', 'isOpen': true, 'start': '08:00 AM', 'end': '10:00 PM'},
      {
        'day': 'Saturday',
        'isOpen': true,
        'start': '08:00 AM',
        'end': '10:00 PM',
      },
      {'day': 'Sunday', 'isOpen': true, 'start': '08:00 AM', 'end': '10:00 PM'},
    ];

    final displayHours =
        (operatingHours != null && operatingHours.isNotEmpty)
            ? operatingHours
            : defaultSchedule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Operating Hours', style: AppWidget.h3TextFieldStyle()),
        16.heightBox,
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColor.lightGrey),
          ),
          child: Column(
            children:
                displayHours.map((e) {
                  final schedule = e as Map<dynamic, dynamic>;
                  final isOpen = schedule['isOpen'] as bool? ?? false;
                  final day = schedule['day']?.toString() ?? '';
                  final start = schedule['start']?.toString() ?? '';
                  final end = schedule['end']?.toString() ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            day,
                            style: AppWidget.bodySmall().copyWith(
                              fontWeight:
                                  isOpen ? FontWeight.w600 : FontWeight.normal,
                              color:
                                  isOpen
                                      ? ThemeColor.black
                                      : ThemeColor.grey100,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isOpen ? '$start - $end' : 'Rest Day',
                            textAlign: TextAlign.right,
                            style: AppWidget.bodySmall().copyWith(
                              fontWeight:
                                  isOpen ? FontWeight.bold : FontWeight.normal,
                              color:
                                  isOpen
                                      ? ThemeColor.darkBlue
                                      : ThemeColor.grey100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
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
