import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/appointment_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/child_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../infrastructure/repositories/firebase_appointment_repository.dart';
import '../../infrastructure/repositories/firebase_auth_repository.dart';
import '../../infrastructure/repositories/firebase_chat_repository.dart';
import '../../infrastructure/repositories/firebase_child_repository.dart';
import '../../infrastructure/repositories/firebase_content_repository.dart';
import '../../infrastructure/repositories/firebase_dashboard_repository.dart';
import '../../infrastructure/repositories/firebase_ticket_repository.dart';
import '../../infrastructure/repositories/firebase_transaction_repository.dart';
import '../../infrastructure/repositories/firebase_user_repository.dart';
import '../../infrastructure/services/gemini_service.dart';
import '../../infrastructure/services/local_notification_service.dart';
import '../../infrastructure/services/stripe_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Repository Providers

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(auth);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseUserRepository(firestore);
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseAppointmentRepository(firestore);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseChatRepository(firestore);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseTransactionRepository(firestore);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseDashboardRepository(firestore);
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseContentRepository(firestore);
});

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseTicketRepository(firestore);
});

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseChildRepository(firestore);
});

// Service Providers

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final stripeServiceProvider = Provider<StripeService>((ref) {
  return StripeService();
});

final notificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});
