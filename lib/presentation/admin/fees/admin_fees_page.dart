import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/admin/fees/fees_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';

import '../../../domain/models/fees_config_model.dart';

@RoutePage()
class AdminFeesPage extends ConsumerStatefulWidget {
  const AdminFeesPage({super.key});

  @override
  ConsumerState<AdminFeesPage> createState() => _AdminFeesPageState();
}

class _AdminFeesPageState extends ConsumerState<AdminFeesPage> {
  final _slaPenaltyCtrl = TextEditingController();
  final _slaTravelPenaltyHoursCtrl = TextEditingController();

  final _commStandardCtrl = TextEditingController();
  final _commMasterCtrl = TextEditingController();
  final _commThresholdCtrl = TextEditingController();

  final _baseRateCtrl = TextEditingController();
  final _remoteDiscountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _slaPenaltyCtrl.dispose();
    _slaTravelPenaltyHoursCtrl.dispose();
    _commStandardCtrl.dispose();
    _commMasterCtrl.dispose();
    _commThresholdCtrl.dispose();
    _baseRateCtrl.dispose();
    _remoteDiscountCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    FocusScope.of(context).unfocus();

    final newConfig = FeesConfigModel(
      slaPenaltyRate: (double.tryParse(_slaPenaltyCtrl.text) ?? 30) / 100,
      slaTravelPenaltyHours: int.tryParse(_slaTravelPenaltyHoursCtrl.text) ?? 4,
      commStandardRate: (double.tryParse(_commStandardCtrl.text) ?? 20) / 100,
      commMasterRate: (double.tryParse(_commMasterCtrl.text) ?? 10) / 100,
      commThreshold: int.tryParse(_commThresholdCtrl.text) ?? 30,
      remoteDiscountAmount: double.tryParse(_remoteDiscountCtrl.text) ?? 10.0,
      baseHourlyRate: double.tryParse(_baseRateCtrl.text) ?? 80.0,
    );

    await ref.read(feesConfigProvider.notifier).updateFees(newConfig);

    if (!mounted) {
      return;
    }

    if (ref.read(feesConfigProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save: ${ref.read(feesConfigProvider).error}',
          ),
          backgroundColor: ThemeColor.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fees configuration saved successfully!'),
          backgroundColor: ThemeColor.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final feesConfigAsync = ref.watch(feesConfigProvider);

    return feesConfigAsync.when(
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: ThemeColor.darkBlue),
          ),
      error:
          (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: ThemeColor.red,
                  size: 48,
                ),
                16.heightBox,
                Text(
                  'Error loading configurations: $err',
                  style: AppWidget.bodyMedium(),
                ),
                16.heightBox,
                ElevatedButton(
                  onPressed: () => ref.invalidate(feesConfigProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
      data: (config) {
        if (_slaPenaltyCtrl.text.isEmpty) {
          _slaPenaltyCtrl.text = (config.slaPenaltyRate * 100).toStringAsFixed(
            0,
          );
          _slaTravelPenaltyHoursCtrl.text =
              config.slaTravelPenaltyHours.toString();
          _commStandardCtrl.text = (config.commStandardRate * 100)
              .toStringAsFixed(0);
          _commMasterCtrl.text = (config.commMasterRate * 100).toStringAsFixed(
            0,
          );
          _commThresholdCtrl.text = config.commThreshold.toString();
          _remoteDiscountCtrl.text = config.remoteDiscountAmount
              .toStringAsFixed(2);
          _baseRateCtrl.text = config.baseHourlyRate.toStringAsFixed(2);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Financial & Fees Settings',
                    style: AppWidget.h2TextFieldStyle(),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save_rounded, size: 20),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.darkBlue,
                      foregroundColor: ThemeColor.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
              32.heightBox,

              _buildSectionTitle('Platform Policies (SLA & Commission)'),
              16.heightBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCard(
                      title: 'SLA Cancellation Policy',
                      icon: Icons.access_time_rounded,
                      children: [
                        _buildInputRow(
                          'Cancellation Penalty',
                          _slaPenaltyCtrl,
                          suffix: '%',
                        ),
                        _buildInputRow(
                          'Travel Penalty Threshold',
                          _slaTravelPenaltyHoursCtrl,
                          suffix: 'Hours',
                        ),
                      ],
                    ),
                  ),
                  24.widthBox,
                  Expanded(
                    child: _buildCard(
                      title: 'Coach Commission Rate',
                      icon: Icons.account_balance_wallet_rounded,
                      children: [
                        _buildInputRow(
                          'Standard Take Rate',
                          _commStandardCtrl,
                          suffix: '%',
                        ),
                        _buildInputRow(
                          'Master Coach Take Rate',
                          _commMasterCtrl,
                          suffix: '%',
                        ),
                        _buildInputRow(
                          'Master Coach Threshold',
                          _commThresholdCtrl,
                          suffix: 'Sessions',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              32.heightBox,

              _buildSectionTitle('Domain Base Fees (Sports & Sessions)'),
              16.heightBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildCard(
                      title: 'Platform Base Hourly Rate',
                      icon: Icons.attach_money_rounded,
                      children: [
                        _buildInputRow(
                          'All Sports (Per Hour)',
                          _baseRateCtrl,
                          prefix: 'RM ',
                        ),
                        12.heightBox,
                        Text(
                          'Note: This base rate applies to all sports sessions on the platform.',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.widthBox,
                  Expanded(
                    flex: 2,
                    child: _buildCard(
                      title: 'Remote Session Discount',
                      icon: Icons.computer_rounded,
                      children: [
                        _buildInputRow(
                          'Price Deduction',
                          _remoteDiscountCtrl,
                          prefix: '- RM ',
                        ),
                        12.heightBox,
                        Text(
                          'Note: Home-based transport fees are set individually by trainers in their profile.',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              64.heightBox,
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.lightGrey.withValues(alpha: 0.2),
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
              Icon(icon, color: ThemeColor.darkBlue, size: 24),
              12.widthBox,
              Text(
                title,
                style: AppWidget.bodySmall().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          24.heightBox,
          ...children.expand((widget) => [widget, 16.heightBox]).toList()
            ..removeLast(),
        ],
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller, {
    String? prefix,
    String? suffix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppWidget.bodyMedium().copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              prefixText: prefix,
              suffixText: suffix,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: ThemeColor.lightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: ThemeColor.darkBlue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
