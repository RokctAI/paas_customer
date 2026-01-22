import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/setting/setting_notifier.dart';
import 'package:foodyman/infrastructure/services/services.dart';

import 'package:foodyman/application/setting/setting_provider.dart';

import 'package:foodyman/presentation/components/components.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  late SettingNotifier event;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingProvider.notifier).getNotificationList(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(settingProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingProvider);
    return state.isLoading
        ? const Loading()
        : Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: state.notifications?.length ?? 0,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CustomToggle(
                        controller: ValueNotifier<bool>(
                          state.notifications?[index].active ?? false,
                        ),
                        title: AppHelpers.getTranslation(
                          state.notifications?[index].type ?? "",
                        ),
                        isChecked: state.notifications?[index].active ?? false,
                        onChange: () {
                          event.updateData(
                            context,
                            index,
                            !(state.notifications?[index].active ?? false),
                          );
                        },
                      ),
                      8.verticalSpace,
                    ],
                  );
                },
              ),
            ],
          );
  }
}
