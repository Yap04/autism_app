import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../application/auth/auth_notifier.dart';
import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';
import '../../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/app_text_field.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class TrainerDashboardPage extends ConsumerWidget {
  const TrainerDashboardPage({super.key});

  static const List<String> availableSports = [
    'Swimming',
    'Football',
    'Basketball',
    'Tennis',
    'Gymnastics',
    'Yoga',
    'Athletics',
    'Badminton',
  ];

  void _showUpdateProfileModal(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
  ) {
    final bioController = TextEditingController(text: currentUser.bio);
    final locationController = TextEditingController(
      text: currentUser.location,
    );
    final selectedSports = List<String>.from(currentUser.sports);

    var tempLatitude = currentUser.latitude;
    var tempLongitude = currentUser.longitude;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: ThemeColor.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ThemeColor.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  24.heightBox,
                  Text('Update Profile', style: AppWidget.h2TextFieldStyle()),
                  16.heightBox,

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location (City/Area)',
                            style: AppWidget.bodyMedium().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          8.heightBox,
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: locationController,
                                  hintText: 'e.g., Kuala Lumpur, Petaling Jaya',
                                  fillColor: ThemeColor.white,
                                ),
                              ),
                              12.widthBox,
                              GestureDetector(
                                onTap: () async {
                                  final result = await context.pushRoute(
                                    const MapPickerRoute(),
                                  );

                                  if (result != null &&
                                      result is Map<String, dynamic>) {
                                    final selectedAddress =
                                        result['address'].toString();
                                    final selectedLatLng =
                                        result['latLng'] as LatLng?;

                                    if (selectedAddress.isNotEmpty) {
                                      setModalState(() {
                                        locationController.text =
                                            selectedAddress;
                                        if (selectedLatLng != null) {
                                          tempLatitude =
                                              selectedLatLng.latitude;
                                          tempLongitude =
                                              selectedLatLng.longitude;
                                        }
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: ThemeColor.blue.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: ThemeColor.blue.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.map_rounded,
                                    color: ThemeColor.darkBlue,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          24.heightBox,

                          Text(
                            'About You (Bio)',
                            style: AppWidget.bodyMedium().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          8.heightBox,
                          AppTextField(
                            controller: bioController,
                            hintText:
                                'Tell parents about your experience and teaching style...',
                            fillColor: ThemeColor.white,
                            maxLines: 4,
                          ),
                          24.heightBox,

                          Text(
                            'Sports You Teach',
                            style: AppWidget.bodyMedium().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          8.heightBox,
                          Wrap(
                            spacing: 6,
                            children:
                                availableSports.map((sport) {
                                  final isSelected = selectedSports.contains(
                                    sport,
                                  );
                                  return FilterChip(
                                    label: Text(sport),
                                    selected: isSelected,
                                    selectedColor: ThemeColor.darkBlue,
                                    labelStyle: TextStyle(
                                      color:
                                          isSelected
                                              ? ThemeColor.white
                                              : ThemeColor.black,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                    checkmarkColor: ThemeColor.white,
                                    backgroundColor: ThemeColor.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color:
                                            isSelected
                                                ? ThemeColor.darkBlue
                                                : ThemeColor.lightGrey,
                                      ),
                                    ),
                                    onSelected: (bool selected) {
                                      setModalState(() {
                                        if (selected) {
                                          selectedSports.add(sport);
                                        } else {
                                          selectedSports.remove(sport);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                          10.heightBox,
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      try {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .updatePublicProfile(
                              bio: bioController.text.trim(),
                              location: locationController.text.trim(),
                              sports: selectedSports,
                              longitude: tempLongitude,
                              latitude: tempLatitude,
                            );

                        if (context.mounted) {
                          Navigator.pop(context);
                          AppSnackBar.success(
                            context,
                            'Profile updated successfully!',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AppSnackBar.error(context, e.toString());
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ThemeColor.darkBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Save Profile',
                        style: AppWidget.bodyMedium().copyWith(
                          color: ThemeColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).value;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
          tooltip: 'Go Back',
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Trainer Dashboard',
          style: AppWidget.h2TextFieldStyle().copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentUser != null)
              _buildPublicProfileCard(context, ref, currentUser),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicProfileCard(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
  ) {
    final bioText =
        (currentUser.bio?.isNotEmpty ?? false)
            ? currentUser.bio!
            : 'Tell parents about your experience...';
    final locationText =
        (currentUser.location?.isNotEmpty ?? false)
            ? currentUser.location!
            : 'Location not set';
    final sportsList =
        currentUser.sports.isNotEmpty
            ? currentUser.sports
            : ['No sports selected'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Public Profile',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.public, color: ThemeColor.aquaBlue, size: 20),
            ],
          ),

          12.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.location_on,
                  size: 16,
                  color: ThemeColor.grey100,
                ),
              ),
              4.widthBox,
              Expanded(
                child: Text(
                  locationText,
                  style: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          8.heightBox,
          Text(bioText, style: AppWidget.bodySmall()),

          16.heightBox,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                sportsList.map((sport) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColor.lightGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sport,
                      style: AppWidget.bodyExtraSmall().copyWith(
                        color: ThemeColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
          ),

          20.heightBox,

          GestureDetector(
            onTap: () => _showUpdateProfileModal(context, ref, currentUser),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ThemeColor.lightGrey, width: 1.5),
              ),
              child: Text(
                'Update Profile',
                style: AppWidget.bodyMedium().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
