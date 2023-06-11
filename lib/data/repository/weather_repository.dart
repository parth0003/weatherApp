import 'package:dio/dio.dart';
import 'package:weather_app/data/models/Geo_location_model.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/repository/api/api.dart';

class WeatherRepository {

  API api = API();
  final String appID = "926fbac8b929f1552d12fc3a52ddc51e";
  Future<WeatherModel> fetchWeatherData(num lat, num lon) async {
    try {
      Response response = await api.sendRequest.get("/data/2.5/forecast", queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': appID,
        'units': 'metric'
      });
      if(response.statusCode == 200) {
        WeatherModel weatherData = WeatherModel.fromJson(response.data);
        return weatherData;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<GeoLocationModel>> fetchGeoLocationData(String query) async {
    try {
      Response response = await api.sendRequest.get("/geo/1.0/direct", queryParameters: {
        'q': query,
        'limit': 10,
        'appid': appID
      });
      if(response.statusCode == 200) {
        List<dynamic> geoMaps = response.data;
        return geoMaps.map((geoMap) => GeoLocationModel.fromJson(geoMap)).toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (ex) {
      rethrow;
    }
  }

}