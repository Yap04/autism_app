import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/admin/appointment/admin_appointments_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/appointment_model.dart';
import '../../../infrastructure/services/remote_notification_service.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class AdminAppointmentsPage extends ConsumerWidget {
  const AdminAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(allAppointmentsStreamProvider);
    final currentFilter = ref.watch(appointmentFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Global Appointments', style: AppWidget.h2TextFieldStyle()),
        8.heightBox,
        Text(
          'Monitor and manage all training sessions across the platform.',
          style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
        ),
        32.heightBox,

        _buildFilterTabs(ref, currentFilter),
        24.heightBox,

        Expanded(
          child: appointmentsAsync.when(
            data: (allAppointments) {
              final filteredList =
                  allAppointments.where((app) {
                    if (currentFilter == 'All') {
                      return true;
                    }
                    return app.status.name.toLowerCase() ==
                        currentFilter.toLowerCase();
                  }).toList();

              if (filteredList.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                itemCount: filteredList.length,
                separatorBuilder: (context, index) => 16.heightBox,
                itemBuilder:
                    (context, index) => _buildAppointmentListItem(
                      context,
                      ref,
                      filteredList[index],
                    ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(WidgetRef ref, String activeFilter) {
    final filters = [
      'All',
      'Pending',
      'Accepted',
      'Completed',
      'Cancelled',
      'Rejected',
    ];
    return Row(
      children:
          filters.map((f) {
            final isSelected = activeFilter == f;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap:
                    () => ref
                        .read(appointmentFilterProvider.notifier)
                        .updateFilter(f),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? ThemeColor.darkBlue : ThemeColor.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color:
                          isSelected
                              ? ThemeColor.darkBlue
                              : ThemeColor.lightGrey,
                    ),
                  ),
                  child: Text(
                    f,
                    style: AppWidget.bodyMedium().copyWith(
                      color: isSelected ? ThemeColor.white : ThemeColor.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildAppointmentListItem(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel app,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(app.dateTime),
                  style: AppWidget.bodyLarge().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(app.dateTime),
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parent: ${app.parentName}',
                  style: AppWidget.bodyMedium(),
                ),
                Text(
                  'Trainer: ${app.trainerName}',
                  style: AppWidget.bodyMedium(),
                ),

                Text(
                  'ID: ${app.id}',
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),

                if (app.sequenceInfo != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColor.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Recurring Session: ${app.sequenceInfo}',
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.paymentMethod == PaymentMethod.credit
                      ? 'Wallet Credit'
                      : 'Stripe / Card',
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                4.heightBox,
                _buildPaymentStatusChip(app.paymentStatus),
              ],
            ),
          ),

          _buildStatusChip(app.status),

          32.widthBox,

          _buildAdminActionBtn(context, ref, app),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color color;
    switch (status) {
      case AppointmentStatus.pending:
        color = ThemeColor.orange;
      case AppointmentStatus.accepted:
        color = ThemeColor.blue;
      case AppointmentStatus.completed:
        color = ThemeColor.green;
      case AppointmentStatus.cancelled:
        color = ThemeColor.red;
      case AppointmentStatus.rejected:
        color = ThemeColor.negative;
    }
    return Container(
      width: 100,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(PaymentStatus status) {
    Color color;
    switch (status) {
      case PaymentStatus.paid:
        color = ThemeColor.green;
      case PaymentStatus.pendingPayment:
        color = ThemeColor.orange;
      case PaymentStatus.refunded:
        color = ThemeColor.grey100;
    }
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: color),
        6.widthBox,
        Text(
          status.name.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminActionBtn(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel app,
  ) {
    final isDisabled =
        app.status == AppointmentStatus.cancelled ||
        app.status == AppointmentStatus.completed ||
        app.status == AppointmentStatus.rejected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled ? null : () => _confirmForceCancel(context, ref, app),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                isDisabled
                    ? ThemeColor.lightGrey.withValues(alpha: 0.2)
                    : ThemeColor.red.withValues(alpha: 0.05),
            border: Border.all(
              color:
                  isDisabled
                      ? ThemeColor.lightGrey.withValues(alpha: 0.5)
                      : ThemeColor.red.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.gavel_rounded,
            color: isDisabled ? ThemeColor.lightGrey : ThemeColor.red,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _confirmForceCancel(
    BuildContext context,
    WidgetRef ref,
    AppointmentModel app,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Force Intervention?'),
            content: Text(
              'Intervening in appointment ${app.id}.\n\nThis will cancel the session and notify both parties. This action is recorded in the system log.',
            ),
            actions: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text('Dismiss', style: AppWidget.bodyMedium()),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await ref
                          .read(appointmentRepositoryProvider)
                          .updateAppointmentStatus(
                            app.id,
                            AppointmentStatus.cancelled,
                          );

                      try {
                        final userRepo = ref.read(userRepositoryProvider);

                        final parentToken = await userRepo.getUserFcmToken(
                          app.parentId,
                        );
                        if (parentToken != null && parentToken.isNotEmpty) {
                          await RemoteNotificationService.notifyOtherUser(
                            targetFcmToken: parentToken,
                            title: 'Session Cancelled ⚠️',
                            body:
                                'Your ${app.sport} session has been cancelled by the system administrator.',
                          );
                        }

                        final trainerToken = await userRepo.getUserFcmToken(
                          app.trainerId,
                        );
                        if (trainerToken != null && trainerToken.isNotEmpty) {
                          await RemoteNotificationService.notifyOtherUser(
                            targetFcmToken: trainerToken,
                            title: 'Session Cancelled ⚠️',
                            body:
                                'The ${app.sport} session with ${app.parentName} has been cancelled by the system administrator.',
                          );
                        }
                      } catch (notifyError) {
                        debugPrint(
                          'Failed to send admin intervention notification: $notifyError',
                        );
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                        AppSnackBar.success(
                          context,
                          'Intervention successful: Session cancelled.',
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppSnackBar.error(context, 'Failed to cancel: $e');
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColor.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Confirm Intervention',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: ThemeColor.lightGrey,
          ),
          16.heightBox,
          Text(
            'No appointments found.',
            style: AppWidget.bodyLarge().copyWith(color: ThemeColor.grey100),
          ),
        ],
      ),
    );
  }
}
