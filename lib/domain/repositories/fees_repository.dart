import '../models/fees_config_model.dart';

abstract class FeesRepository {
  Future<FeesConfigModel> getFeesConfig();

  Future<void> updateFeesConfig(FeesConfigModel newConfig);
}
