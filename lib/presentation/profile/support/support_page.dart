import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/support/ticket_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../domain/models/ticket_model.dart';
import '../../shared/ticket_status_color.dart';

@RoutePage()
class SupportPage extends ConsumerWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(userTicketsStreamProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 0,
        title: Text(
          context.l10n.helpAndSupportTitle,
          style: AppWidget.h3TextFieldStyle(),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.push(const CreateTicketRoute()),
        backgroundColor: ThemeColor.darkBlue,
        icon: const Icon(Icons.add, color: ThemeColor.white),
        label: Text(
          context.l10n.newTicketAction,
          style: AppWidget.bodyMedium().copyWith(
            color: ThemeColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeColor.darkBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 48,
                      color: ThemeColor.darkBlue,
                    ),
                  ),
                  16.heightBox,
                  Text(
                    context.l10n.howCanWeHelp,
                    style: AppWidget.h2TextFieldStyle(),
                  ),
                  8.heightBox,
                  Text(
                    context.l10n.trackSupportRequests,
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.grey100,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            32.heightBox,

            Text(
              context.l10n.myTicketsTitle,
              style: AppWidget.h3TextFieldStyle(),
            ),
            16.heightBox,

            ticketsAsync.when(
              loading:
                  () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        color: ThemeColor.darkBlue,
                      ),
                    ),
                  ),
              error:
                  (err, _) => Center(
                    child: Text(
                      context.l10n.errorLoadingTickets(err.toString()),
                    ),
                  ),
              data: (tickets) {
                if (tickets.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tickets.length,
                  separatorBuilder: (context, index) => 12.heightBox,
                  itemBuilder:
                      (context, index) =>
                          _buildTicketCard(context, tickets[index]),
                );
              },
            ),
            80.heightBox,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: ThemeColor.lightGrey,
          ),
          16.heightBox,
          Text(
            context.l10n.noSupportTicketsYet,
            style: AppWidget.bodyMedium().copyWith(fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          Text(
            context.l10n.submitNewTicketPrompt,
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, TicketModel ticket) {
    return InkWell(
      onTap: () => context.router.push(TicketChatRoute(ticket: ticket)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ThemeColor.lightGrey.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticket.category,
                    style: AppWidget.bodyMedium().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                8.widthBox,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(ticket.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.status.name.toUpperCase(),
                    style: AppWidget.bodyExtraSmall().copyWith(
                      color: getStatusColor(ticket.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            8.heightBox,
            Text(
              ticket.lastMessageFromAdmin
                  ? context.l10n.adminMessage(ticket.lastMessage)
                  : context.l10n.youMessage(ticket.lastMessage),
              style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            12.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.updatedAtDate(
                    DateFormat('dd MMM, hh:mm a').format(ticket.updatedAt),
                  ),
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: ThemeColor.grey100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
