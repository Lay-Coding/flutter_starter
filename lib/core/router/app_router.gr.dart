// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:flutter_rapid_framework/features/webview/view/webview_page.dart'
    as _i1;

abstract class $AppRouter extends _i2.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    WebviewRoute.name: (routeData) {
      final args = routeData.argsAs<WebviewRouteArgs>();
      return _i2.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.WebviewPage(
          key: args.key,
          url: args.url,
        ),
      );
    }
  };
}

/// generated route for
/// [_i1.WebviewPage]
class WebviewRoute extends _i2.PageRouteInfo<WebviewRouteArgs> {
  WebviewRoute({
    _i3.Key? key,
    required String url,
    List<_i2.PageRouteInfo>? children,
  }) : super(
          WebviewRoute.name,
          args: WebviewRouteArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'WebviewRoute';

  static const _i2.PageInfo<WebviewRouteArgs> page =
      _i2.PageInfo<WebviewRouteArgs>(name);
}

class WebviewRouteArgs {
  const WebviewRouteArgs({
    this.key,
    required this.url,
  });

  final _i3.Key? key;

  final String url;

  @override
  String toString() {
    return 'WebviewRouteArgs{key: $key, url: $url}';
  }
}
