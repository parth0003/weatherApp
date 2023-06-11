import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/logic/cubits/weatherCubit/weather_cubit.dart';

@RoutePage()
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => WeatherCubit(),
          child: BlocConsumer<WeatherCubit, WeatherState>(
            listener: (context, state) {
              if (state is WeatherDataLoading) {
                context.loaderOverlay.show();
              } else if (state is WeatherDataLoaded) {
                context.loaderOverlay.hide();
              } else if (state is WeatherError) {
                context.loaderOverlay.hide();
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg), backgroundColor: Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const SearchBarWidget(),
                  if (state is WeatherInitial)
                    Expanded(
                      child: Center(
                        child: Text("Search city", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.sp)),
                      ),
                    ),
                  if (state is GeoLocationDataLoaded)
                    (state.geoLocationList.isNotEmpty)
                        ? Expanded(
                            child: ListView.separated(
                              itemCount: state.geoLocationList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var geoLocationItem = state.geoLocationList[index];
                                return ListTile(
                                  onTap: () {
                                    context.read<WeatherCubit>().geoLocationItemClick(geoLocationItem);
                                  },
                                  title: Text("${geoLocationItem.name ?? ""}, ${geoLocationItem.state ?? ""}, ${geoLocationItem.country ?? ""}", style: TextStyle(color: Colors.white)),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                          )
                        : Expanded(
                            child: Center(
                              child: Text("No Result Found", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.sp)),
                            ),
                          ),
                  if (state is WeatherDataLoaded)
                    () {
                      var (currentTemp, minOfDay, maxOfDay, weather, icon, dayName) = context.read<WeatherCubit>().filterWeatherData(state.weatherData);
                      var cityName = context.read<WeatherCubit>().cityName;
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 2.h,
                                width: double.infinity,
                              ),
                              Text(cityName, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 20.sp)),
                              Text("$currentTemp°", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w300, fontSize: 60.sp)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network("http://openweathermap.org/img/wn/$icon@2x.png", width: 12.w,),
                                  Text(weather, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 20.sp)),
                                ],
                              ),
                              Text("H:$minOfDay°  L:$maxOfDay°", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 18.sp)),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 0.16),
                                  borderRadius: BorderRadius.circular(2.w)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 2.h,),
                                    Text("5-Day Forecast".toUpperCase(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 14.sp)),
                                    forecastItem(context.read<WeatherCubit>().filterWeatherData(state.weatherData, day: 0)),
                                    const Divider(height: 0),
                                    forecastItem(context.read<WeatherCubit>().filterWeatherData(state.weatherData, day: 1)),
                                    const Divider(height: 0),
                                    forecastItem(context.read<WeatherCubit>().filterWeatherData(state.weatherData, day: 2)),
                                    const Divider(height: 0),
                                    forecastItem(context.read<WeatherCubit>().filterWeatherData(state.weatherData, day: 3)),
                                    const Divider(height: 0),
                                    forecastItem(context.read<WeatherCubit>().filterWeatherData(state.weatherData, day: 4)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }(),
                ],
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Center(child: Text("Weather App", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14.sp))),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

forecastItem((num, num, num, String, String, String) filterWeatherData) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(filterWeatherData.$6, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.sp)),
        Text("H:${filterWeatherData.$2}°  L:${filterWeatherData.$3}°", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 12.sp)),
      ],
    ),
  );
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 1.8.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 3.w,
            ),
            const Icon(
              Icons.search,
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: TextField(
                key: const Key('searchBar_textField'),
                onSubmitted: (content) => {context.read<WeatherCubit>().contentChanged(content)},
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(hintText: "Search City", border: InputBorder.none),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
          ],
        ),
      ),
    );
  }
}
