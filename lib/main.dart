import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/routes/routes_imports.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GlobalLoaderOverlay(
          child: MaterialApp.router(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: _appRouter.config(),
          ),
        );
      }
    );
  }
}