import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/logic/cubits/splashCubit/splash_cubit.dart';
import 'package:weather_app/routes/routes_imports.gr.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SplashCubit(),
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state == SplashState.moveNext) {
              AutoRouter.of(context).replace(const WeatherRoute());
            }
          },
          builder: (context, state) {
            return (state == SplashState.loading) ? const Center(
              child: Text("Splash Screen"),
            ) : const SizedBox();
          },
        ),
      ),
    );
  }
}
