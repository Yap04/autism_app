import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/admin/support/admin_ticket_provider.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/support/ticket_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/ticket_message_model.dart';
import '../../../domain/models/ticket_model.dart';
import '../../shared/snack_bar.dart';
import '../../shared/ticket_status_color.dart';

@RoutePage()
class AdminSupportPage extends ConsumerStatefulWidget {
  const AdminSupportPage({super.key});

  @override
  ConsumerState<AdminSupportPage> createState() => _AdminSupportPageState();
}

class _AdminSupportPageState extends ConsumerState<AdminSupportPage> {
  final TextEditingController _replyController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String ticketId) async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    _replyController.clear();

    try {
      final newMsg = TicketMessageModel(
        id: '',
        isFromAdmin: true,
        message: text,
        createdAt: DateTime.now(),
      );

      await ref
          .read(ticketRepositoryProvider)
          .sendTicketMessage(ticketId, newMsg, text);
    } catch (e) {
      AppSnackBar.error(context, 'Failed to send message: $e');
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _markAsResolved(String ticketId) async {
    try {
      await ref
          .read(ticketRepositoryProvider)
          .updateTicketStatus(ticketId, TicketStatus.resolved);
      AppSnackBar.success(context, 'Ticket marked as resolved.');
    } catch (e) {
      AppSnackBar.error(context, 'Failed to update status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(adminTicketsStreamProvider);
    final selectedId = ref.watch(selectedTicketIdProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Help & Support', style: AppWidget.h2TextFieldStyle()),
        8.heightBox,
        Text(
          'Manage incoming tickets, disputes, and technical issues.',
          style: AppWidget.bodyMedium().copyWith(color: ThemeColor.grey100),
        ),
        24.heightBox,

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ThemeColor.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ThemeColor.lightGrey.withValues(alpha: 0.5),
              ),
            ),
            child: ticketsAsync.when(
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(
                      color: ThemeColor.darkBlue,
                    ),
                  ),
              error:
                  (err, _) =>
                      Center(child: Text('Error loading tickets: $err')),
              data: (tickets) {
                if (tickets.isEmpty) {
                  return const Center(child: Text('No support tickets found.'));
                }

                final activeId =
                    selectedId ??
                    tickets
                        .where((t) => t.status == TicketStatus.open)
                        .firstOrNull
                        ?.id ??
                    tickets.first.id;
                final activeTicket = tickets.firstWhere(
                  (t) => t.id == activeId,
                  orElse: () => tickets.first,
                );

                return Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: Column(
                        children: [
                          _buildTicketListHeader(tickets),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.separated(
                              itemCount: tickets.length,
                              separatorBuilder:
                                  (context, index) => const Divider(height: 1),
                              itemBuilder:
                                  (context, index) => _buildTicketListItem(
                                    tickets[index],
                                    activeId,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalDivider(width: 1),

                    Expanded(
                      child: Column(
                        children: [
                          _buildChatHeader(activeTicket),
                          const Divider(height: 1),

                          Expanded(child: _buildChatMessages(activeTicket.id)),

                          const Divider(height: 1),

                          if (activeTicket.status == TicketStatus.open ||
                              activeTicket.status == TicketStatus.escalated)
                            _buildChatInputArea(activeTicket.id)
                          else
                            Container(
                              padding: const EdgeInsets.all(24),
                              color: ThemeColor.cream.withValues(alpha: 0.3),
                              alignment: Alignment.center,
                              child: Text(
                                'This ticket has been resolved.',
                                style: AppWidget.bodyMedium().copyWith(
                                  color: ThemeColor.grey100,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketListHeader(List<TicketModel> tickets) {
    final actionRequiredCount =
        tickets.where((t) => t.status != TicketStatus.resolved).length;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('All Tickets', style: AppWidget.h3TextFieldStyle()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  actionRequiredCount > 0
                      ? ThemeColor.red.withValues(alpha: 0.1)
                      : ThemeColor.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$actionRequiredCount Action Required',
              style: AppWidget.bodySmall().copyWith(
                color:
                    actionRequiredCount > 0 ? ThemeColor.red : ThemeColor.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketListItem(TicketModel ticket, String activeId) {
    final isSelected = ticket.id == activeId;
    final isResolved = ticket.status == TicketStatus.resolved;

    final isParent = ticket.userRole == 'parent';
    final roleColor = isParent ? ThemeColor.darkBlue : ThemeColor.orange;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ref.read(selectedTicketIdProvider.notifier).set(ticket.id);
        },
        child: Container(
          color:
              isSelected
                  ? ThemeColor.darkBlue.withValues(alpha: 0.05)
                  : Colors.transparent,
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    isResolved
                        ? ThemeColor.lightGrey
                        : roleColor.withValues(alpha: 0.1),
                child: Icon(
                  isParent ? Icons.family_restroom : Icons.sports,
                  color: isResolved ? ThemeColor.grey100 : roleColor,
                  size: 20,
                ),
              ),
              16.widthBox,
              Expanded(
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
                        Text(
                          DateFormat('hh:mm a').format(ticket.updatedAt),
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    4.heightBox,
                    Text(
                      ticket.lastMessage,
                      style: AppWidget.bodySmall().copyWith(
                        color:
                            isResolved ? ThemeColor.grey100 : ThemeColor.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatHeader(TicketModel ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ticket.category, style: AppWidget.h3TextFieldStyle()),
              4.heightBox,
              Row(
                children: [
                  Text(
                    'User ID: ${ticket.userId}',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                  12.widthBox,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(
                        ticket.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
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
            ],
          ),
          if (ticket.status == TicketStatus.open ||
              ticket.status == TicketStatus.escalated)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _markAsResolved(ticket.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColor.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Mark as Resolved',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.green,
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

  Widget _buildChatMessages(String ticketId) {
    final messagesAsync = ref.watch(ticketMessagesProvider(ticketId));

    return messagesAsync.when(
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: ThemeColor.darkBlue),
          ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (messages) {
        if (messages.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(24),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isFromAdmin = msg.isFromAdmin;

            return Align(
              alignment:
                  isFromAdmin ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: isFromAdmin ? ThemeColor.darkBlue : ThemeColor.cream,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isFromAdmin ? 12 : 0),
                    bottomRight: Radius.circular(isFromAdmin ? 0 : 12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg.message,
                      style: AppWidget.bodyMedium().copyWith(
                        color:
                            isFromAdmin ? ThemeColor.white : ThemeColor.black,
                      ),
                    ),
                    4.heightBox,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        DateFormat('hh:mm a').format(msg.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isFromAdmin
                                  ? ThemeColor.lightGrey
                                  : ThemeColor.grey100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatInputArea(String ticketId) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Type your reply here...',
                filled: true,
                fillColor: ThemeColor.cream.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (value) => _sendMessage(ticketId),
            ),
          ),
          16.widthBox,
          MouseRegion(
            cursor:
                _isSending
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _isSending ? null : () => _sendMessage(ticketId),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ThemeColor.darkBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _isSending
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: ThemeColor.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(
                          Icons.send_rounded,
                          color: ThemeColor.white,
                          size: 20,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
