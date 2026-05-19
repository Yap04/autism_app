import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/fees_config_model.dart';
import '../../domain/repositories/fees_repository.dart';

class FirebaseFeesRepository implements FeesRepository {
  FirebaseFeesRepository(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentReference get _feesDoc =>
      _firestore.collection('settings').doc('fees');

  @override
  Future<FeesConfigModel> getFeesConfig() async {
    try {
      final snapshot = await _feesDoc.get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()! as Map<String, dynamic>;
        return FeesConfigModel.fromJson(data);
      } else {
        return const FeesConfigModel(
          slaPenaltyRate: 0.3,
          slaTravelPenaltyHours: 4,
          commStandardRate: 0.2,
          commMasterRate: 0.1,
          commThreshold: 30,
          baseHourlyRate: 80,
          remoteDiscountAmount: 10,
        );
      }
    } catch (e) {
      throw Exception('Failed to load fees config from Firestore: $e');
    }
  }

  @override
  Future<void> updateFeesConfig(FeesConfigModel newConfig) async {
    try {
      final jsonData = newConfig.toJson();
      await _feesDoc.set(jsonData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update fees config in Firestore: $e');
    }
  }
}
