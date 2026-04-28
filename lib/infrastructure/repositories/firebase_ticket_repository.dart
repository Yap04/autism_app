import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/ticket_message_model.dart';
import '../../domain/models/ticket_model.dart';
import '../../domain/repositories/ticket_repository.dart';

class FirebaseTicketRepository implements TicketRepository {
  FirebaseTicketRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _ticketsRef =>
      _firestore.collection('tickets');

  @override
  Stream<List<TicketModel>> watchUserTickets(String userId) {
    return _ticketsRef
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return TicketModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> createTicket(TicketModel ticket) async {
    final docRef = _ticketsRef.doc();
    final newTicket = ticket.copyWith(id: docRef.id);
    await docRef.set(newTicket.toJson());
  }

  @override
  Stream<List<TicketMessageModel>> watchTicketMessages(String ticketId) {
    return _ticketsRef
        .doc(ticketId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return TicketMessageModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> sendTicketMessage(
    String ticketId,
    TicketMessageModel message,
    String text,
  ) async {
    final msgDocRef = _ticketsRef.doc(ticketId).collection('messages').doc();

    final batch =
        _firestore.batch()
          ..set(msgDocRef, message.copyWith(id: msgDocRef.id).toJson())
          ..update(_ticketsRef.doc(ticketId), {
            'lastMessage': text,
            'lastMessageFromAdmin': message.isFromAdmin,
            'updatedAt': FieldValue.serverTimestamp(),
          });

    await batch.commit();
  }

  @override
  Future<void> updateTicketStatus(String ticketId, TicketStatus status) async {
    await _ticketsRef.doc(ticketId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<TicketModel>> watchAllTickets() {
    return _ticketsRef.orderBy('updatedAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TicketModel.fromJson(data);
      }).toList();
    });
  }
}
