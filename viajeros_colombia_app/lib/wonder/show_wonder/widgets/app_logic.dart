import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:travel_app_colombia/router.dart';

class AppLogic {
  Size _appSize = Size.zero;

  /// Indicates to the rest of the app that bootstrap has not completed.
  /// The router will use this to prevent redirects while bootstrapping.
  bool isBootstrapComplete = false;

  /// Indicates which orientations the app will allow be default. Affects Android/iOS devices only.
  /// Defaults to both landscape (hz) and portrait (vt)
  List<Axis> supportedOrientations = [Axis.vertical, Axis.horizontal];

  /// Allow a view to override the currently supported orientations. For example, [FullscreenVideoViewer] always wants to enable both landscape and portrait.
  /// If a view sets this override, they are responsible for setting it back to null when finished.
  List<Axis>? _supportedOrientationsOverride;
  set supportedOrientationsOverride(List<Axis>? value) {
    if (_supportedOrientationsOverride != value) {
      _supportedOrientationsOverride = value;
    }
  }

  void handleAppSizeChanged(Size appSize) {
    /// Disable landscape layout on smaller form factors
    bool isSmall = true;
    supportedOrientations =
        isSmall ? [Axis.vertical] : [Axis.vertical, Axis.horizontal];
    _appSize = appSize;
  }

  /// Initialize the app and all main actors.
  /// Loads settings, sets up services etc.
  Future<void> bootstrap() async {
    debugPrint('bootstrap start...');
    // Set min-sizes for desktop apps

    if (kIsWeb) {
      // SB: This is intentionally not a debugPrint, as it's a message for users who open the console on web.

      // Required on web to automatically enable accessibility features
      WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
    }

    // Load any bitmaps the views might need
    //await AppBitmaps.init();

    // Set preferred refresh rate to the max possible (the OS may ignore this)
    // if (!kIsWeb && PlatformInfo.isAndroid) {
    //   await FlutterDisplayMode.setHighRefreshRate();
    // }

    // // Settings
    // await settingsLogic.load();

    // // Localizations
    // await localeLogic.load();

    // // Wonders Data
    // wondersLogic.init();

    // // Events
    // timelineLogic.init();

    // Flag bootStrap as complete
    isBootstrapComplete = true;

    // Load initial view (replace empty initial view which is covered by a native splash screen)

    appRouter.go(initialDeeplink ?? ScreenPaths.home);
  }

  bool shouldUseNavRail() =>
      _appSize.width > _appSize.height && _appSize.height > 250;
}

class AppImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    this.imageCache.maximumSizeBytes = 250 << 20; // 250mb
    return super.createImageCache();
  }
}
