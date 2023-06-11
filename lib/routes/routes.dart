part of 'routes_imports.dart';

@AutoRouterConfig(replaceInRouteName: "Screen,Route")
class AppRouter extends $AppRouter {

  @override
  RouteType get defaultRouteType => Platform.isAndroid? const RouteType.material() : const RouteType.cupertino();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, path: "/"),
    AutoRoute(page: WeatherRoute.page),
  ];
}