import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/localization_ext.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/snack_bar.dart';

@RoutePage()
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  GoogleMapController? _mapController;

  LatLng _currentCenter = const LatLng(3.1390, 101.6869);

  String? _currentAddress;
  bool _isDragging = false;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng(_currentCenter);
  }

  Future<void> _initUserLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final userLatLng = LatLng(position.latitude, position.longitude);

      setState(() => _currentCenter = userLatLng);
      _mapController?.animateCamera(CameraUpdate.newLatLng(userLatLng));

      _getAddressFromLatLng(userLatLng);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, context.l10n.unableToGetLocation);
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() => _isLoadingAddress = true);
    try {
      await setLocaleIdentifier('en_US');

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final addressParts = <String>[];
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          addressParts.add(place.postalCode!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        setState(() {
          _currentAddress = addressParts.join(', ');
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentAddress = context.l10n.locationSelected;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingAddress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayAddress =
        _currentAddress ?? context.l10n.moveMapToSelectLocation;
    final isDisabled =
        _isLoadingAddress || _isDragging || _currentAddress == null;

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          context.l10n.selectLocationTitle,
          style: AppWidget.h3TextFieldStyle(),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentCenter,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
            onCameraMoveStarted: () {
              setState(() => _isDragging = true);
            },
            onCameraMove: (position) {
              _currentCenter = position.target;
            },
            onCameraIdle: () {
              setState(() => _isDragging = false);
              _getAddressFromLatLng(_currentCenter);
            },
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _isDragging ? -15 : -10, 0),
            child: const Icon(
              Icons.location_on,
              size: 50,
              color: ThemeColor.red,
            ),
          ),

          Positioned(
            right: 16,
            top: 16,
            child: FloatingActionButton(
              heroTag: 'my_location_btn',
              backgroundColor: ThemeColor.white,
              onPressed: _initUserLocation,
              child: const Icon(Icons.my_location, color: ThemeColor.blue),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ThemeColor.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColor.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.selectedAddressLabel,
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                    8.heightBox,
                    Row(
                      children: [
                        if (_isLoadingAddress)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ThemeColor.darkBlue,
                            ),
                          )
                        else
                          const Icon(
                            Icons.location_city,
                            color: ThemeColor.darkBlue,
                          ),
                        12.widthBox,
                        Expanded(
                          child: Text(
                            displayAddress,
                            style: AppWidget.bodyLarge().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    24.heightBox,

                    GestureDetector(
                      onTap:
                          isDisabled
                              ? null
                              : () {
                                context.router.maybePop({
                                  'address': displayAddress,
                                  'latLng': _currentCenter,
                                });
                              },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDisabled ? Colors.grey : ThemeColor.darkBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          context.l10n.confirmLocationButton,
                          style: AppWidget.bodyMedium().copyWith(
                            color:
                                isDisabled ? Colors.white70 : ThemeColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
