import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/payment/payment_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/transaction_model.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/loading_components.dart';
import '../../shared/snack_bar.dart';
import 'shared/empty_transaction_state.dart';
import 'shared/transaction_card.dart';

@RoutePage()
class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final currentCredits = currentUser?.sessionCredits ?? 0;
    final transactionsAsync = ref.watch(
      userTransactionsStreamProvider(currentUser?.id ?? ''),
    );

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        title: Text('Wallet', style: AppWidget.h2TextFieldStyle()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Text(
                      'Training Credits',
                      style: AppWidget.h3TextFieldStyle(),
                    ),
                    16.heightBox,
                    Text('Available Sessions:', style: AppWidget.bodyMedium()),
                    8.heightBox,
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: ThemeColor.orange,
                          child: Icon(
                            Icons.local_activity,
                            color: ThemeColor.white,
                            size: 20,
                          ),
                        ),
                        12.widthBox,
                        Text(
                          '$currentCredits',
                          style: AppWidget.h1TextFieldStyle(),
                        ),
                        8.widthBox,
                        Text(
                          currentCredits == 1 ? 'Credit' : 'Credits',
                          style: AppWidget.bodyLarge().copyWith(
                            color: ThemeColor.grey100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    24.heightBox,
                    GestureDetector(
                      onTap: () {
                        if (currentUser != null) {
                          _showPackagesBottomSheet(context, ref, currentUser);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ThemeColor.darkBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_shopping_cart,
                              color: ThemeColor.white,
                            ),
                            16.widthBox,
                            Text(
                              'Buy Credit Packages',
                              style: AppWidget.bodyLarge().copyWith(
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.white,
                              ),
                            ),
                          ],
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
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: ThemeColor.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: ThemeColor.darkBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: ThemeColor.white,
                      unselectedLabelColor: ThemeColor.grey100,
                      labelStyle: AppWidget.bodyMedium().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: const [
                        Tab(text: 'Credit'),
                        Tab(text: 'Single Pay'),
                      ],
                    ),
                  ),
                  20.heightBox,

                  transactionsAsync.when(
                    data: (transactions) {
                      final isCreditTab = _tabController.index == 0;

                      final filteredTransactions =
                          transactions.where((tx) {
                            if (isCreditTab) {
                              return tx.paymentChannel ==
                                      PaymentChannel.credit ||
                                  tx.type == TransactionType.topUp;
                            } else {
                              return tx.paymentChannel == PaymentChannel.stripe;
                            }
                          }).toList();

                      if (filteredTransactions.isEmpty) {
                        return const EmptyTransactionState();
                      }

                      final displayList = filteredTransactions.take(3).toList();

                      return Column(
                        children: [
                          ...displayList.map(
                            (tx) => TransactionCard(
                              transaction: tx,
                              isCreditTab: isCreditTab,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: GestureDetector(
                              onTap: () {
                                context.pushRoute(
                                  AllTransactionsRoute(
                                    initialTab: _tabController.index,
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View All History',
                                    style: AppWidget.bodyMedium().copyWith(
                                      color: ThemeColor.darkBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: ThemeColor.darkBlue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading:
                        () => const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ThemeColor.darkBlue,
                            ),
                          ),
                        ),
                    error:
                        (err, _) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text('Error loading history: $err'),
                          ),
                        ),
                  ),
                ],
              ),
              40.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  void _showPackagesBottomSheet(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: ThemeColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select a Package', style: AppWidget.h2TextFieldStyle()),
              8.heightBox,
              Text(
                'Buy more credits to enjoy bulk discounts.',
                style: AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
              24.heightBox,

              _buildPackageOption(
                context: context,
                ref: ref,
                currentUser: currentUser,
                title: 'Single Session',
                credits: 1,
                price: 'RM 80',
                isPopular: false,
              ),
              12.heightBox,
              _buildPackageOption(
                context: context,
                ref: ref,
                currentUser: currentUser,
                title: 'Starter Pack',
                credits: 5,
                price: 'RM 380',
                isPopular: true,
              ),
              12.heightBox,
              _buildPackageOption(
                context: context,
                ref: ref,
                currentUser: currentUser,
                title: 'Pro Pack',
                credits: 10,
                price: 'RM 700',
                isPopular: false,
              ),
              32.heightBox,
            ],
          ),
        );
      },
    );
  }

  Widget _buildPackageOption({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel currentUser,
    required String title,
    required int credits,
    required String price,
    required bool isPopular,
  }) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        await _processPurchase(
          context,
          ref,
          currentUser,
          credits,
          price,
          title,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isPopular
                  ? ThemeColor.aquaBlue.withValues(alpha: 0.3)
                  : ThemeColor.white,
          border: Border.all(
            color: isPopular ? ThemeColor.darkBlue : ThemeColor.lightGrey,
            width: isPopular ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppWidget.bodyLarge().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isPopular) ...[
                      8.widthBox,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColor.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'POPULAR',
                          style: AppWidget.bodyExtraSmall().copyWith(
                            color: ThemeColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                4.heightBox,
                Text(
                  '$credits ${credits == 1 ? 'Credit' : 'Credits'}',
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ],
            ),
            Text(
              price,
              style: AppWidget.h3TextFieldStyle().copyWith(
                color: ThemeColor.darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPurchase(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
    int creditsToAdd,
    String priceString,
    String title,
  ) async {
    showLoading();

    try {
      await ref
          .read(paymentNotifierProvider.notifier)
          .buyCreditPackage(
            currentUser: currentUser,
            creditsToAdd: creditsToAdd,
            priceString: priceString,
            packageTitle: title,
          );

      final paymentState = ref.read(paymentNotifierProvider);
      if (paymentState.hasError) {
        throw Exception(paymentState.error);
      }

      if (context.mounted) {
        AppSnackBar.success(
          context,
          'Payment successful! Added $creditsToAdd credits.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        AppSnackBar.error(context, errorMsg);
      }
    } finally {
      closeLoading();
    }
  }
}
