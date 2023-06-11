class GeoLocationModel {
  GeoLocationModel({
      this.name, 
      this.localNames, 
      this.lat, 
      this.lon, 
      this.country, 
      this.state,});

  GeoLocationModel.fromJson(dynamic json) {
    name = json['name'];
    localNames = json['local_names'] != null ? LocalNames.fromJson(json['local_names']) : null;
    lat = json['lat'];
    lon = json['lon'];
    country = json['country'];
    state = json['state'];
  }
  String? name;
  LocalNames? localNames;
  num? lat;
  num? lon;
  String? country;
  String? state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    if (localNames != null) {
      map['local_names'] = localNames?.toJson();
    }
    map['lat'] = lat;
    map['lon'] = lon;
    map['country'] = country;
    map['state'] = state;
    return map;
  }

}

class LocalNames {
  LocalNames({
      this.fr, 
      this.uk,});

  LocalNames.fromJson(dynamic json) {
    fr = json['fr'];
    uk = json['uk'];
  }
  String? fr;
  String? uk;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fr'] = fr;
    map['uk'] = uk;
    return map;
  }

}