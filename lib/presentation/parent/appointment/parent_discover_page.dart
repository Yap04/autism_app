import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../application/user/trainer_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/sport_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../../core/routes/app_router.dart';
import '../../../domain/models/user_model.dart';
import '../../shared/app_text_field.dart';
import '../../shared/snack_bar.dart';
import '../../shared/trainer_card.dart';
import '../../shared/user_avatar.dart';

class ParentDiscoverPage extends ConsumerStatefulWidget {
  const ParentDiscoverPage({super.key});

  @override
  ConsumerState<ParentDiscoverPage> createState() => _ParentDiscoverPageState();
}

class _ParentDiscoverPageState extends ConsumerState<ParentDiscoverPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasLocationPermission = false;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  Set<Marker> _markers = {};

  LatLng? _userLocation;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(3.1390, 101.6869),
    zoom: 14.5,
  );

  Future<void> _goToMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        AppSnackBar.info(context, 'Please turn on GPS location services.');
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          AppSnackBar.error(context, 'Location permission denied.');
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        AppSnackBar.error(
          context,
          'Location permission permanently denied. Please enable in settings.',
        );
      }
      return;
    }

    setState(() {
      _hasLocationPermission = true;
    });

    final position = await Geolocator.getCurrentPosition();

    if (mounted) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    }

    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  Future<void> _checkInitialLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (mounted) {
      setState(() {
        _hasLocationPermission = true;
      });
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
      }

      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.5,
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<BitmapDescriptor> _createAvatarMarker(
    String? url,
    String fallbackName,
  ) async {
    const size = 130;
    const strokeWidth = 6.0;

    const radius = (size / 2) - (strokeWidth / 2);
    const center = Offset(size / 2, size / 2);

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final borderPaint =
        Paint()
          ..color = ThemeColor.darkBlue
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final bgPaint = Paint()..color = ThemeColor.white;

    canvas.drawCircle(center, radius, bgPaint);

    if (url != null && url.trim().isNotEmpty) {
      try {
        final request = await HttpClient()
            .getUrl(Uri.parse(url))
            .timeout(const Duration(seconds: 5));
        final response = await request.close().timeout(
          const Duration(seconds: 5),
        );
        final bytes = await consolidateHttpClientResponseBytes(response);

        final codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: size,
          targetHeight: size,
        );
        final fi = await codec.getNextFrame();

        final clipPath =
            Path()..addOval(Rect.fromCircle(center: center, radius: radius));
        canvas
          ..save()
          ..clipPath(clipPath)
          ..drawImage(fi.image, Offset.zero, Paint())
          ..restore();
      } catch (e) {
        print('Error: $e');
      }
    }

    canvas.drawCircle(center, radius, borderPaint);

    final image = await pictureRecorder.endRecording().toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  bool _isGeneratingMarkers = false;

  Future<void> _generateMarkers(List<UserModel> trainers) async {
    if (_isGeneratingMarkers) {
      return;
    }
    _isGeneratingMarkers = true;

    final newMarkers = <Marker>{};
    for (final trainer in trainers) {
      if (trainer.latitude != null && trainer.longitude != null) {
        final icon = await _createAvatarMarker(
          trainer.userAvatarUrl,
          trainer.name ?? 'Trainer',
        );

        newMarkers.add(
          Marker(
            markerId: MarkerId(trainer.id),
            position: LatLng(trainer.latitude!, trainer.longitude!),
            icon: icon,
            infoWindow: InfoWindow(
              title: trainer.name,
              snippet: trainer.sports.isNotEmpty ? trainer.sports.first : '',
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _markers = Set.from(newMarkers);
      });
    }
    _isGeneratingMarkers = false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _checkInitialLocation();

    final initialTrainers = ref.read(trainerListProvider).value;
    if (initialTrainers != null && initialTrainers.isNotEmpty) {
      _generateMarkers(initialTrainers);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<UserModel>>>(trainerListProvider, (
      previous,
      next,
    ) {
      next.whenData(_generateMarkers);
    });

    final trainersAsync = ref.watch(trainerListProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.backgroundAquaBlue,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Find Coaches Near You',
          style: AppWidget.h2TextFieldStyle(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _searchController,
                    hintText: 'Search by name, sport or location...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ThemeColor.grey100,
                    ),
                  ),
                ),
                12.widthBox,
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ThemeColor.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: ThemeColor.black),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: _initialPosition,
                      onMapCreated: _mapController.complete,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationEnabled: _hasLocationPermission,
                      markers: _markers,
                      gestureRecognizers: const {
                        Factory<OneSequenceGestureRecognizer>(
                          EagerGestureRecognizer.new,
                        ),
                      },
                    ),
                  ),

                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _goToMyLocation,
                      child: const CircleAvatar(
                        backgroundColor: ThemeColor.white,
                        child: Icon(
                          Icons.my_location,
                          color: ThemeColor.grey100,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 140,
                      child: trainersAsync.maybeWhen(
                        data: (trainers) {
                          if (trainers.isEmpty) {
                            return const SizedBox();
                          }

                          final sorted = List<UserModel>.from(trainers);
                          if (_userLocation != null) {
                            sorted.sort((a, b) {
                              if (a.latitude == null || a.longitude == null) {
                                return 1;
                              }
                              if (b.latitude == null || b.longitude == null) {
                                return -1;
                              }
                              final dA = Geolocator.distanceBetween(
                                _userLocation!.latitude,
                                _userLocation!.longitude,
                                a.latitude!,
                                a.longitude!,
                              );
                              final dB = Geolocator.distanceBetween(
                                _userLocation!.latitude,
                                _userLocation!.longitude,
                                b.latitude!,
                                b.longitude!,
                              );
                              return dA.compareTo(dB);
                            });
                          }

                          final displayTrainers = sorted.take(5).toList();

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: displayTrainers.length,
                            itemBuilder: (context, index) {
                              return _buildHorizontalCoachCard(
                                displayTrainers[index],
                              );
                            },
                          );
                        },
                        orElse: () => const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (!_hasLocationPermission || _userLocation == null) ...[
              16.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeColor.lightOrange.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColor.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_off_outlined,
                        color: ThemeColor.lightOrange,
                      ),
                      12.widthBox,
                      Expanded(
                        child: Text(
                          'Turn on location services to find the closest trainers to you.',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.grey100,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _goToMyLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColor.backgroundAquaBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Enable',
                            style: AppWidget.bodySmall().copyWith(
                              color: ThemeColor.darkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              8.heightBox,
            ] else ...[
              24.heightBox,
            ],

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Certified Trainers',
                    style: AppWidget.h3TextFieldStyle(),
                  ),
                  GestureDetector(
                    onTap: () => context.pushRoute(const TrainerListRoute()),
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: AppWidget.bodySmall().copyWith(
                            color: ThemeColor.darkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: ThemeColor.darkBlue,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            12.heightBox,

            trainersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
              data: (trainers) {
                if (trainers.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'No trainers found.',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                  );
                }

                final sortedTrainers = List<UserModel>.from(trainers);
                if (_userLocation != null) {
                  sortedTrainers.sort((a, b) {
                    if (a.latitude == null || a.longitude == null) {
                      return 1;
                    }
                    if (b.latitude == null || b.longitude == null) {
                      return -1;
                    }
                    final dA = Geolocator.distanceBetween(
                      _userLocation!.latitude,
                      _userLocation!.longitude,
                      a.latitude!,
                      a.longitude!,
                    );
                    final dB = Geolocator.distanceBetween(
                      _userLocation!.latitude,
                      _userLocation!.longitude,
                      b.latitude!,
                      b.longitude!,
                    );
                    return dA.compareTo(dB);
                  });
                }

                final topTrainers = trainers.take(3).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: topTrainers.length,
                  itemBuilder: (context, index) {
                    return TrainerCard(trainer: topTrainers[index]);
                  },
                );
              },
            ),
            30.heightBox,
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCoachCard(UserModel trainer) {
    var distanceText = 'Distance unknown';

    if (_userLocation != null &&
        trainer.latitude != null &&
        trainer.longitude != null) {
      final distanceInMeters = Geolocator.distanceBetween(
        _userLocation!.latitude,
        _userLocation!.longitude,
        trainer.latitude!,
        trainer.longitude!,
      );

      if (distanceInMeters < 1000) {
        distanceText = '${distanceInMeters.toStringAsFixed(0)} m away';
      } else {
        distanceText =
            '${(distanceInMeters / 1000).toStringAsFixed(1)} km away';
      }
    }

    final coachName = trainer.name ?? trainer.nickname ?? 'Coach';
    final displaySports = trainer.sports.take(3).toList();

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                radius: 24,
                userAvatarUrl: trainer.userAvatarUrl,
                username: coachName,
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coachName,
                      style: AppWidget.bodyLarge().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      distanceText,
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.heightBox,
                    Row(
                      children:
                          displaySports.isEmpty
                              ? [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.sports,
                                    size: 16,
                                    color: ThemeColor.grey100.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Not specified',
                                  style: AppWidget.bodyExtraSmall().copyWith(
                                    color: ThemeColor.grey100,
                                  ),
                                ),
                              ]
                              : displaySports.map((sport) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    getSportIcon(sport),
                                    size: 16,
                                    color: ThemeColor.black,
                                  ),
                                );
                              }).toList(),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(
                Icons.verified,
                color: ThemeColor.lightOrange,
                size: 18,
              ),
              8.widthBox,
              Text(
                'Autism Training Certified',
                style: AppWidget.bodySmall().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
