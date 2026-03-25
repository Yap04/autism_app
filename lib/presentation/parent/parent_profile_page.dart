import 'package:flutter/material.dart';
import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 120,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profile',
                        style: AppWidget.h1TextFieldStyle(),
                      ),
                    ),
                    10.heightBox,

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColor.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeColor.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 46,
                        backgroundColor: ThemeColor.grey100,
                        child: Icon(
                          Icons.person,
                          color: ThemeColor.white,
                          size: 50,
                        ),
                      ),
                    ),

                    12.heightBox,

                    Text('Sarah', style: AppWidget.h2TextFieldStyle()),

                    4.heightBox,

                    const Text(
                      'sarah.sarah@gmail.com',
                      style: TextStyle(fontSize: 14, color: ThemeColor.grey100),
                    ),

                    24.heightBox,

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(24),
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
                          Text('Wallet', style: AppWidget.h3TextFieldStyle()),

                          16.heightBox,

                          Text(
                            'Current Balance:',
                            style: AppWidget.bodyMedium(),
                          ),

                          8.heightBox,

                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: ThemeColor.aquaBlue,
                                child: Icon(
                                  Icons.sync,
                                  color: ThemeColor.white,
                                  size: 20,
                                ),
                              ),

                              12.widthBox,

                              Text(
                                'RM 350.00',
                                style: AppWidget.h2TextFieldStyle(),
                              ),
                            ],
                          ),

                          24.heightBox,

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColor.darkBlue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              icon: const Icon(
                                Icons.account_balance_wallet,
                                color: ThemeColor.white,
                              ),
                              label: Text(
                                'Top-Up Dompet',
                                style: AppWidget.bodyLarge().copyWith(
                                  color: ThemeColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    32.heightBox,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment History',
                          style: AppWidget.h3TextFieldStyle(),
                        ),

                        16.heightBox,

                        _buildTransactionCard(
                          '11 Mac: Sesi Renang\n(Ahmad)',
                          '- RM 80',
                          ThemeColor.aquaBlue,
                        ),
                        _buildTransactionCard(
                          '5 Mac: Top-Up',
                          '+ RM 150',
                          ThemeColor.aquaBlue,
                        ),
                        _buildTransactionCard(
                          '1 Mac: Football Session',
                          '- RM 50',
                          ThemeColor.aquaBlue,
                        ),

                        40.heightBox,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(String title, String amount, Color aquaBlue) {
    final isDeduction = amount.contains('-');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: aquaBlue.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.white, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppWidget.bodyMedium().copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
          Text(
            amount,
            style: AppWidget.bodyLarge().copyWith(
              fontWeight: FontWeight.bold,
              color: isDeduction ? ThemeColor.black : ThemeColor.blue,
            ),
          ),
        ],
      ),
    );
  }
}
