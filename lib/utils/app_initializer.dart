// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_constants.dart';
import '../application/poidata/poi_data_provider.dart';
import '../infrastructure/models/data/poi_data.dart';
//import 'package:foodyman/utils/excluded_product_ids.dart';

class AppInitializer extends StatefulWidget {
  final ProviderContainer providerContainer;
  //final List<int> excludedProductIds = [];
  //final List<int> excludedCategoryIds = [];

  const AppInitializer({super.key, required this.providerContainer});

  Future<void> initializeApp() async {
    await initializeRemoteConfigWithoutAPICall();
    await checkAppStatusFromAPI();
    // Add other app initialization tasks here
  }

  Future<void> initializeRemoteConfigWithoutAPICall() async {
    final initializer = _AppInitializerState(providerContainer);
    await initializer._initializeRemoteConfigWithoutAPICall();
  }

  Future<void> checkAppStatusFromAPI() async {
    final initializer = _AppInitializerState(providerContainer);
    await initializer._checkAppStatusFromAPI();
  }

  @override
  _AppInitializerState createState() => _AppInitializerState(providerContainer);
}

class _AppInitializerState extends State<AppInitializer> {
  final ProviderContainer providerContainer;

  _AppInitializerState(this.providerContainer);

  @override
  void initState() {
    super.initState();
    // You can perform additional setup here if needed
  }

  Future<void> _initializeRemoteConfigWithoutAPICall() async {
    // Use AppConstants.baseUrl as the site identifier (Tenant Site Name)
    // This assumes AppConstants.baseUrl is pre-configured with the tenant's site domain (e.g. juvo.tenant.rokct.ai)
    final String tenantSite = AppConstants.baseUrl;
    const String controlPanelUrl = "https://platform.rokct.ai";

    try {
      // Fetch remote config for 'Customer' app type
      final response = await http.get(Uri.parse('$tenantSite/api/method/paas.api.remote_config.get_remote_config?app_type=Customer'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Frappe 'whitelist' responses wrap data in 'message'
        final config = responseData['message'];

        if (config != null) {
            // Helper functions to safely extract types from the JSON map
            String? getString(String key) => config[key]?.toString();
            // Frappe Check fields are returned as 0 or 1 (int)
            bool? getBool(String key) => config[key] == 1 || config[key] == true || config[key] == "true";
            int? getInt(String key) => int.tryParse(config[key]?.toString() ?? "");

            // Update AppConstants with values from Remote Config
            if (getString('drawingBaseUrl') != null) AppConstants.drawingBaseUrl = getString('drawingBaseUrl')!;
            if (getString('adminPageUrl') != null) AppConstants.adminPageUrl = getString('adminPageUrl')!;
            if (getString('routingKey') != null) AppConstants.routingKey = getString('routingKey')!;
            if (getString('googleApiKey') != null) AppConstants.googleApiKey = getString('googleApiKey')!;
            if (getString('firebaseWebKey') != null) AppConstants.firebaseWebKey = getString('firebaseWebKey')!;
            if (getString('uriPrefix') != null) AppConstants.uriPrefix = getString('uriPrefix')!;
            if (getString('isOpen') != null) AppConstants.isOpen = getString('isOpen')!;
            if (getString('isClosed') != null) AppConstants.isClosed = getString('isClosed')!;
            if (getBool('showGooglePOILayer') != null) AppConstants.showGooglePOILayer = getBool('showGooglePOILayer')!;
            if (getString('localeCodeEn') != null) AppConstants.localeCodeEn = getString('localeCodeEn')!;

            if (getString('demoLatitude') != null) AppConstants.demoLatitude = double.tryParse(getString('demoLatitude')!) ?? 0.0;
            if (getString('demoLongitude') != null) AppConstants.demoLongitude = double.tryParse(getString('demoLongitude')!) ?? 0.0;
            if (getString('pinLoadingMin') != null) AppConstants.pinLoadingMin = double.tryParse(getString('pinLoadingMin')!) ?? 0.0;
            if (getString('pinLoadingMax') != null) AppConstants.pinLoadingMax = double.tryParse(getString('pinLoadingMax')!) ?? 0.0;

            if (getInt('newShopDays') != null) AppConstants.newShopDays = getInt('newShopDays')!;
            if (getBool('cardDirect') != null) AppConstants.cardDirect = getBool('cardDirect')!;
            if (getBool('isNumberLengthAlwaysSame') != null) AppConstants.isNumberLengthAlwaysSame = getBool('isNumberLengthAlwaysSame')!;
            if (getString('countryCodeISO') != null) AppConstants.countryCodeISO = getString('countryCodeISO')!;
            if (getBool('showFlag') != null) AppConstants.showFlag = getBool('showFlag')!;
            if (getBool('showFlag') != null) AppConstants.showFlag = getBool('showFlag')!;
            if (getBool('showArrowIcon') != null) AppConstants.showArrowIcon = getBool('showArrowIcon')!;

            if (getBool('enableMarketplace') != null) AppConstants.enableMarketplace = getBool('enableMarketplace')!;
            if (getString('defaultShopId') != null) AppConstants.defaultShopId = getString('defaultShopId')!;

            // Handle POI Data
            if (config['poiData'] != null) {
                try {
                    String poiDataString = config['poiData'];
                    List<dynamic> poiDataJson = jsonDecode(poiDataString);

                    if (kDebugMode) {
                        print("poiDataJson: $poiDataJson");
                    }

                    List<POIData> poiDataList = [];
                    for (var poiDataMap in poiDataJson) {
                        poiDataList.add(
                            POIData(
                                name: poiDataMap['name'],
                                latitude: poiDataMap['latitude'].toDouble(),
                                longitude: poiDataMap['longitude'].toDouble(),
                                titleColor: Color(int.parse(poiDataMap['titleColor'].substring(2), radix: 16) + 0xFF000000),
                                pin: poiDataMap['pin'],
                            ),
                        );
                    }
                     providerContainer.read(poiDataProvider.notifier).updatePOIData(poiDataList);
                } catch (e) {
                     if (kDebugMode) {
                        print("Error processing poiData: $e");
                     }
                }
            }
        }
      } else {
         if (kDebugMode) {
             print("Failed to fetch remote config. Status: ${response.statusCode}");
         }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching remote config: $e");
      }
    }
  }

  Future<void> _checkAppStatusFromAPI() async {
    // Check the app status from the API with a 5-second timeout
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.baseUrl}/public/api/v1/rest/status'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppConstants.isMaintain = data['status'] != 'OK';
      } else {
        AppConstants.isMaintain = true; // Set isMaintain to true if API response is not successful
      }
    } on TimeoutException {
      AppConstants.isMaintain = true; // Set isMaintain to true if the API call times out
    } catch (e) {
      AppConstants.isMaintain = true; // Set isMaintain to true if an exception occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // No UI needed here
  }
}
