import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../shared/trainer_card.dart';

@RoutePage()
class TrainerListPage extends ConsumerWidget {
  const TrainerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainersAsync = ref.watch(trainerListProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        iconTheme: const IconThemeData(color: ThemeColor.black),
        title: Text('All Trainers', style: AppWidget.h3TextFieldStyle()),
        centerTitle: true,
      ),
      body: trainersAsync.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: ThemeColor.darkBlue),
            ),
        error:
            (e, stack) => Center(
              child: Text(
                e.toString(),
                style: const TextStyle(color: ThemeColor.negative),
              ),
            ),
        data: (trainers) {
          if (trainers.isEmpty) {
            return Center(
              child: Text(
                'No trainers available yet',
                textAlign: TextAlign.center,
                style: AppWidget.bodyLarge().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              final trainer = trainers[index];
              return TrainerCard(trainer: trainer);
            },
          );
        },
      ),
    );
  }
}
