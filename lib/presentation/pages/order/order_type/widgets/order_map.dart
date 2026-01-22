import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:foodyman/presentation/components/components.dart';

class OrderMap extends StatelessWidget {
  final Set<Marker> markers;
  final bool isLoading;
  final LatLng latLng;
  final List<LatLng> polylineCoordinates;

  const OrderMap({
    super.key,
    required this.markers,
    required this.latLng,
    required this.polylineCoordinates,
    required this.isLoading,
  });

  LatLngBounds _bounds(Set<Marker> markers) {
    if (markers.isEmpty) {
      return LatLngBounds(southwest: LatLng(0, 0), northeast: LatLng(0, 0));
    }

    final list = markers.map((m) => m.position).toList();

    double minLat = list.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = list.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = list
        .map((e) => e.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = list
        .map((e) => e.longitude)
        .reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: ThemeWrapper(
        builder: (colors, theme) {
          return Container(
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.all(16.r),
            height: 260.h,

            child: isLoading
                ? const Center(child: Loading())
                : Listener(
                    behavior: HitTestBehavior.opaque,
                    child: GoogleMap(
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },

                      padding: REdgeInsets.only(bottom: 15),
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,

                      markers: markers,

                      onMapCreated: (GoogleMapController controller) {
                        if (markers.isNotEmpty) {
                          controller.animateCamera(
                            CameraUpdate.newLatLngBounds(_bounds(markers), 50),
                          );
                        }
                      },

                      polylines: {
                        Polyline(
                          polylineId: const PolylineId("market"),
                          points: polylineCoordinates,
                          color: colors.primary,
                          width: 6,
                        ),
                      },

                      initialCameraPosition: CameraPosition(
                        target: latLng,
                        zoom: 10,
                      ),

                      mapToolbarEnabled: false,
                      zoomControlsEnabled: true,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
