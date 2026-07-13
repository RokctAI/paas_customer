import 'package:get_it/get_it.dart';
import 'package:map_sdk/src/infrastructure/services/places/places_service.dart';

/// [MapSdkDependencies.register] registers a [GooglePlacesService] during
/// bootstrap; map_sdk resolves it lazily here.
GooglePlacesService get googlePlaces => GetIt.I.get<GooglePlacesService>();
