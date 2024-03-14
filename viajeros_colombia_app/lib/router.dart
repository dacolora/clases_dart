import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app_colombia/ui/screens/entry_point.dart';
import 'package:travel_app_colombia/wonder/show_wonder_page.dart';

import 'wonder/detail_wonder_page.dart';
import 'departamento/departamentos_data/wonder_data.dart';
import 'wonder/show_wonder/widgets/app_scaffold.dart';
import 'wonder/show_wonder/widgets/wonders_logic.dart';

class ScreenPaths {
  static String splash = '/';
  static String intro = '/welcome';
  static String home = '/home';
  static String bottom = '/bottom';
  static String entryPoint = '/entry';

  static String wonderDetails(WonderType type, {required int tabIndex}) {
    return '$home/wonder/${type.name}?t=$tabIndex';
  }
}

final appRouter = GoRouter(
  redirect: _handleRedirect,
  errorPageBuilder: (context, state) => MaterialPage(child: Container()),
  routes: [
    ShellRoute(
        builder: (context, router, navigator) {
          return WondersAppScaffold(child: navigator);
        },
        routes: [
          AppRoute(
            ScreenPaths.splash,
            (_) => Container(
              color: const Color(0xFF272625),
            ),
          ),
          AppRoute(ScreenPaths.entryPoint, (_) => const EntryPoint()),
          AppRoute(ScreenPaths.home, (_) => ShowWonder(), routes: [
            AppRoute(
              'wonder/:detailsType',
              (s) {
                WondersLogic wondersLogic = WondersLogic();
                final wonder = wondersLogic
                    .getData(_parseWonderType(s.pathParameters['detailsType']));
                const menuPadding = EdgeInsets.only(left: 0.0);
                return WonderEditorialScreen(wonder,
                    contentPadding: menuPadding);
              },
              useFade: true,
              routes: const [],
            ),
          ]),
        ]),
  ],
);

class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}

String? get initialDeeplink => _initialDeeplink;
String? _initialDeeplink;

String? _handleRedirect(BuildContext context, GoRouterState state) {
  //primera interaccion de la app
  return ScreenPaths.entryPoint;
}

WonderType _parseWonderType(String? value) {
  const fallback = WonderType.chichenItza;
  if (value == null) return fallback;
  return _tryParseWonderType(value) ?? fallback;
}

WonderType? _tryParseWonderType(String value) =>
    WonderType.values.asNameMap()[value];
