part of 'weather_cubit.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class SearchCityState extends WeatherState {
  TextEditingController citySearchController;

  SearchCityState(this.citySearchController);
}

class WeatherDataLoading extends WeatherState {}

class WeatherDataLoaded extends WeatherState {
  final WeatherModel weatherData;

  WeatherDataLoaded(this.weatherData);
}

class WeatherError extends WeatherState {
  final String errorMsg;

  WeatherError(this.errorMsg);
}

class GeoLocationDataLoaded extends WeatherState {
  final List<GeoLocationModel> geoLocationList;

  GeoLocationDataLoaded(this.geoLocationList);
}
