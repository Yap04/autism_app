import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/sport_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/app_text_field.dart';
import '../../shared/bottom_action_button.dart';
import '../../shared/trainer_card.dart';

@RoutePage()
class TrainerListPage extends ConsumerStatefulWidget {
  const TrainerListPage({super.key});

  @override
  ConsumerState<TrainerListPage> createState() => _TrainerListPageState();
}

class _TrainerListPageState extends ConsumerState<TrainerListPage> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedSportFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: ThemeColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ThemeColor.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  24.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.filterTrainersTitle,
                        style: AppWidget.h2TextFieldStyle(),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() => _selectedSportFilter = 'All');
                          setState(() => _selectedSportFilter = 'All');
                        },
                        child: Text(
                          context.l10n.resetAction,
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.heightBox,
                  Text(
                    context.l10n.bySportCategory,
                    style: AppWidget.h3TextFieldStyle(),
                  ),
                  16.heightBox,
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        sportCategories.map((sport) {
                          final isSelected = _selectedSportFilter == sport;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() => _selectedSportFilter = sport);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? ThemeColor.darkBlue
                                        : ThemeColor.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? ThemeColor.darkBlue
                                          : ThemeColor.lightGrey,
                                ),
                              ),
                              child: Text(
                                sport.toLocalizedSport(context),
                                style: AppWidget.bodySmall().copyWith(
                                  color:
                                      isSelected
                                          ? ThemeColor.white
                                          : ThemeColor.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  32.heightBox,
                  BottomActionButton(
                    label: context.l10n.applyFiltersAction,
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  16.heightBox,
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trainersAsync = ref.watch(trainerListProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        iconTheme: const IconThemeData(color: ThemeColor.black),
        title: Text(
          context.l10n.trainerListTitle,
          style: AppWidget.h2TextFieldStyle(),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    fillColor: ThemeColor.white,
                    controller: _searchController,
                    hintText: context.l10n.searchByNameHint,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ThemeColor.grey100,
                    ),
                  ),
                ),
                12.widthBox,
                GestureDetector(
                  onTap: _openFilterBottomSheet,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color:
                          _selectedSportFilter != 'All'
                              ? ThemeColor.darkBlue
                              : ThemeColor.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      color:
                          _selectedSportFilter != 'All'
                              ? ThemeColor.white
                              : ThemeColor.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                context.l10n.noTrainersAvailableYet,
                textAlign: TextAlign.center,
                style: AppWidget.bodyLarge().copyWith(
                  color: ThemeColor.grey100,
                ),
              ),
            );
          }

          final filteredTrainers =
              trainers.where((trainer) {
                final nameMatch =
                    trainer.name!.toLowerCase().contains(_searchQuery) ||
                    (trainer.nickname ?? '').toLowerCase().contains(
                      _searchQuery,
                    );

                final matchesSearch = _searchQuery.isEmpty || nameMatch;

                var matchesSport = true;
                if (_selectedSportFilter != 'All') {
                  final sportsStr = trainer.sports.join(' ').toLowerCase();
                  matchesSport = sportsStr.contains(
                    _selectedSportFilter.toLowerCase(),
                  );
                }

                return matchesSearch && matchesSport;
              }).toList();

          if (filteredTrainers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 48,
                    color: ThemeColor.lightGrey,
                  ),
                  16.heightBox,
                  Text(
                    context.l10n.noTrainersMatchCriteria,
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredTrainers.length,
            itemBuilder: (context, index) {
              final trainer = filteredTrainers[index];
              return TrainerCard(trainer: trainer);
            },
          );
        },
      ),
    );
  }
}
