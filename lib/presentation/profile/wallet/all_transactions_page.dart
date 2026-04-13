import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/payment/payment_notifier.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../domain/models/credit_transaction_model.dart';
import 'shared/empty_transaction_state.dart';
import 'shared/transaction_card.dart';

@RoutePage()
class AllTransactionsPage extends ConsumerStatefulWidget {
  const AllTransactionsPage({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  ConsumerState<AllTransactionsPage> createState() =>
      _AllTransactionsPageState();
}

class _AllTransactionsPageState extends ConsumerState<AllTransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
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
    final transactionsAsync = ref.watch(
      userTransactionsStreamProvider(currentUser?.id ?? ''),
    );

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        title: Text('History', style: AppWidget.h2TextFieldStyle()),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
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
                tabs: const [Tab(text: 'Credit'), Tab(text: 'Single Pay')],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(transactionsAsync, true),
          _buildList(transactionsAsync, false),
        ],
      ),
    );
  }

  Widget _buildList(
    AsyncValue<List<CreditTransactionModel>> asyncData,
    bool isCreditTab,
  ) {
    return asyncData.when(
      data: (transactions) {
        final filtered =
            transactions.where((tx) {
              if (isCreditTab) {
                return tx.paymentChannel == PaymentChannel.credit ||
                    tx.type == TransactionType.topUp;
              } else {
                return tx.paymentChannel == PaymentChannel.stripe;
              }
            }).toList();

        if (filtered.isEmpty) {
          return const EmptyTransactionState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return TransactionCard(
              transaction: filtered[index],
              isCreditTab: isCreditTab,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
