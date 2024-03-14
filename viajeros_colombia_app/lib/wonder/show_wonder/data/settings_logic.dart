import 'package:flutter/material.dart';
import 'package:travel_app_colombia/wonder/show_wonder/data/save_load_mixin.dart';

class SettingsLogic with ThrottledSaveLoadMixin {
  @override
  String get fileName => 'settings.dat';

  late final hasCompletedOnboarding = ValueNotifier<bool>(false)
    ..addListener(scheduleSave);
  late final hasDismissedSearchMessage = ValueNotifier<bool>(false)
    ..addListener(scheduleSave);
  late final isSearchPanelOpen = ValueNotifier<bool>(true)
    ..addListener(scheduleSave);
  late final currentLocale = ValueNotifier<String?>(null)
    ..addListener(scheduleSave);
  late final prevWonderIndex = ValueNotifier<int?>(null)
    ..addListener(scheduleSave);

  final bool useBlurs = true;

  @override
  void copyFromJson(Map<String, dynamic> value) {
    hasCompletedOnboarding.value = value['hasCompletedOnboarding'] ?? false;
    hasDismissedSearchMessage.value =
        value['hasDismissedSearchMessage'] ?? false;
    currentLocale.value = value['currentLocale'];
    isSearchPanelOpen.value = value['isSearchPanelOpen'] ?? false;
    prevWonderIndex.value = value['lastWonderIndex'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'hasCompletedOnboarding': hasCompletedOnboarding.value,
      'hasDismissedSearchMessage': hasDismissedSearchMessage.value,
      'currentLocale': currentLocale.value,
      'isSearchPanelOpen': isSearchPanelOpen.value,
      'lastWonderIndex': prevWonderIndex.value,
    };
  }
}
