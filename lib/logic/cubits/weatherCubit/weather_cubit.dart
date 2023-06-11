import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/models/Geo_location_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/logic/extensions/date_extension.dart';
import 'package:intl/intl.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial()) {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('city') != null) {
        cityName = prefs.getString('city') ?? "";
        emit(WeatherDataLoading());
        fetchWeatherData();
      }
    });
  }
  var cityName = "--";

  WeatherRepository weatherRepository = WeatherRepository();

  TextEditingController citySearchController = TextEditingController();

  void fetchWeatherData() async {
    try {
      SharedPreferences.getInstance().then((prefs) async {
        WeatherModel weatherData =
            await weatherRepository.fetchWeatherData(num.parse(prefs.getString("lat") ?? "0"), num.parse(prefs.getString("lon") ?? "0"));
        emit(WeatherDataLoaded(weatherData));
      });
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.unknown) {
        emit(WeatherError("Can't fetch weather data, please check your internet connection!"));
      } else {
        emit(WeatherError(ex.type.toString()));
      }
    } catch (ex) {
      emit(WeatherError(ex.toString()));
    }
  }

  void contentChanged(String city) {
    if (city.trim().isNotEmpty && city.trim().length >= 3) {
      fetchGeoLocationFromCity(city);
    }
  }

  Future<void> fetchGeoLocationFromCity(String city) async {
    try {
      List<GeoLocationModel> geoLocationList = await weatherRepository.fetchGeoLocationData(city);
      emit(GeoLocationDataLoaded(geoLocationList));
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.unknown) {
        emit(WeatherError("Can't fetch city data, please check your internet connection!"));
      } else {
        emit(WeatherError(ex.type.toString()));
      }
    } catch (ex) {
      emit(WeatherError(ex.toString()));
    }
  }

  void geoLocationItemClick(GeoLocationModel geoLocationItem) {
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setString("city", geoLocationItem.name ?? "");
      prefs.setString("lat", "${geoLocationItem.lat ?? 0}");
      prefs.setString("lon", "${geoLocationItem.lon ?? 0}");
      cityName = geoLocationItem.name ?? "";
      emit(WeatherDataLoading());
      fetchWeatherData();
    });
  }

  (num, num, num, String, String, String) filterWeatherData(WeatherModel weatherModel, {day = 0}) {
    var dayName = DateFormat('EEEE').format(DateTime.now().add(Duration(days: day)));
    var filterData = (weatherModel.list ?? [])
        .where((weatherData) =>
            DateTime.now().add(Duration(days: day)).isSameDate(DateTime.fromMillisecondsSinceEpoch(int.parse("${weatherData.dt}000"))))
        .toList();
    if (filterData.isEmpty) {
      return (0, 0, 0, "-", "--", dayName);
    } else {
      //(CurrentTemp, minOfDay, maxOfDay, weather, icon, dayName, cityName)
      return (
        (filterData.first.main!.temp ?? 0).round(),
        (filterData.first.main!.tempMin ?? 0).round(),
        (filterData.last.main!.tempMax ?? 0).round(),
        ((filterData.first.weather ?? []).isEmpty) ? "--" : filterData.first.weather!.first.main ?? "--",
        ((filterData.first.weather ?? []).isEmpty) ? "--" : filterData.first.weather!.first.icon ?? "--",
        dayName
      );
    }
  }
}
