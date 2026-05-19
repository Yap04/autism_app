import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/fees_config_model.dart';
import '../../providers/repository_providers.dart';

class FeesConfigNotifier extends AsyncNotifier<FeesConfigModel> {
  @override
  Future<FeesConfigModel> build() async {
    return ref.read(feesRepositoryProvider).getFeesConfig();
  }

  Future<void> updateFees(FeesConfigModel newConfig) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(feesRepositoryProvider).updateFeesConfig(newConfig);

      state = AsyncValue.data(newConfig);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void forceUpdateLocalState(FeesConfigModel config) {
    state = AsyncValue.data(config);
  }
}

final feesConfigProvider =
    AsyncNotifierProvider<FeesConfigNotifier, FeesConfigModel>(() {
      return FeesConfigNotifier();
    });
