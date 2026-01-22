import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  List<AutocompletePrediction> searchResult = [];

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return Scaffold(
          backgroundColor: colors.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  16.verticalSpace,
                  SearchTextField(
                    autofocus: true,
                    isBorder: true,
                    hintText: AppHelpers.getTranslation(TrKeys.search),
                    onChanged: (title) async {
                      final res = await googlePlace.autocomplete.get(title);
                      searchResult = res?.predictions ?? [];
                      setState(() {});
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchResult.length,
                      padding: EdgeInsets.only(bottom: 22.h),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            final placeId = searchResult[index].placeId;
                            final details = await googlePlace.details.get(
                              placeId!,
                            );
                            final location =
                                details?.result?.geometry?.location;

                            if (context.mounted) {
                              context.maybePop(
                                LatLng(location?.lat ?? 0, location?.lng ?? 0),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              22.verticalSpace,
                              Text(
                                searchResult[index]
                                        .structuredFormatting
                                        ?.mainText ??
                                    "",
                                style: AppStyle.interNormal(
                                  size: 14,
                                  color: colors.textBlack,
                                ),
                              ),
                              Text(
                                searchResult[index]
                                        .structuredFormatting
                                        ?.secondaryText ??
                                    "",
                                style: AppStyle.interNormal(size: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(color: AppStyle.borderColor),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: const PopButton(),
          ),
        );
      },
    );
  }
}
