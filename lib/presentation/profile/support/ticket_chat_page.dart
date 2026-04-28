import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/repository_providers.dart';
import '../../../application/support/ticket_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../domain/models/ticket_message_model.dart';
import '../../../domain/models/ticket_model.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class TicketChatPage extends ConsumerStatefulWidget {
  const TicketChatPage({required this.ticket, super.key});
  final TicketModel ticket;

  @override
  ConsumerState<TicketChatPage> createState() => _TicketChatPageState();
}

class _TicketChatPageState extends ConsumerState<TicketChatPage> {
  final _msgController = TextEditingController();
  bool _isSending = false;
  bool _isEscalatedLocally = false;

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() => _isSending = true);
    _msgController.clear();

    try {
      final newMsg = TicketMessageModel(
        id: '',
        isFromAdmin: false,
        message: text,
        createdAt: DateTime.now(),
      );

      await ref
          .read(ticketRepositoryProvider)
          .sendTicketMessage(widget.ticket.id, newMsg, text);
    } catch (e) {
      AppSnackBar.error(context, 'Failed to send message: $e');
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _confirmEscalation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            backgroundColor: ThemeColor.white,
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: ThemeColor.orange,
                ),
                8.widthBox,
                Text('Escalate Ticket?', style: AppWidget.h3TextFieldStyle()),
              ],
            ),
            content: const Text(
              'This ticket was marked as resolved. If you are still experiencing issues, you can escalate this ticket. It will be reopened and sent directly to senior management.',
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, true),
                child: Text(
                  'Yes, Escalate',
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirm ?? false) {
      try {
        await ref
            .read(ticketRepositoryProvider)
            .updateTicketStatus(widget.ticket.id, TicketStatus.escalated);
        setState(() {
          _isEscalatedLocally = true;
        });
        AppSnackBar.success(
          context,
          'Ticket escalated successfully. Management will review it shortly.',
        );
      } catch (e) {
        AppSnackBar.error(context, 'Failed to escalate ticket: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(ticketMessagesProvider(widget.ticket.id));
    final actionRequired =
        widget.ticket.status == TicketStatus.open ||
        widget.ticket.status == TicketStatus.escalated ||
        _isEscalatedLocally;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.white,
        elevation: 0.5,
        title: Column(
          children: [
            Text(widget.ticket.category, style: AppWidget.h3TextFieldStyle()),
            2.heightBox,
            Text(
              'Ticket ID: #${widget.ticket.id.substring(0, 6).toUpperCase()}',
              style: AppWidget.bodyExtraSmall().copyWith(
                color: ThemeColor.grey100,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (!actionRequired)
            IconButton(
              tooltip: 'Escalate Issue',
              icon: const Icon(
                Icons.priority_high_rounded,
                color: ThemeColor.orange,
              ),
              onPressed: _confirmEscalation,
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color:
                actionRequired
                    ? ThemeColor.orange.withValues(alpha: 0.1)
                    : ThemeColor.green.withValues(alpha: 0.1),
            child: Text(
              actionRequired
                  ? 'Our support team will reply to you shortly.'
                  : 'This ticket has been marked as resolved.',
              textAlign: TextAlign.center,
              style: AppWidget.bodySmall().copyWith(
                color: actionRequired ? ThemeColor.orange : ThemeColor.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: messagesAsync.when(
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(
                      color: ThemeColor.darkBlue,
                    ),
                  ),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('Start the conversation...'));
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                );
              },
            ),
          ),

          if (actionRequired) _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(TicketMessageModel msg) {
    final isMe = !msg.isFromAdmin;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: ThemeColor.darkBlue,
              child: Icon(
                Icons.support_agent_rounded,
                size: 18,
                color: ThemeColor.white,
              ),
            ),
            8.widthBox,
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? ThemeColor.blue : ThemeColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColor.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.message,
                    style: AppWidget.bodyMedium().copyWith(
                      color: isMe ? ThemeColor.white : ThemeColor.black,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    DateFormat('hh:mm a').format(msg.createdAt),
                    style: AppWidget.bodyExtraSmall().copyWith(
                      color:
                          isMe
                              ? ThemeColor.white.withValues(alpha: 0.7)
                              : ThemeColor.grey100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: InputDecoration(
                hintText: 'Type your reply here...',
                hintStyle: const TextStyle(color: ThemeColor.grey100),
                filled: true,
                fillColor: ThemeColor.cream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          12.widthBox,
          GestureDetector(
            onTap: _isSending ? null : _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: ThemeColor.darkBlue,
                shape: BoxShape.circle,
              ),
              child:
                  _isSending
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: ThemeColor.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(
                        Icons.send_rounded,
                        color: ThemeColor.white,
                        size: 24,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
