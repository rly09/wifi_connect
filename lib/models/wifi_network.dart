class WiFiNetwork {
  final String ssid;
  final String passwordEncrypted;
  final WiFiLocation location;

  WiFiNetwork({
    required this.ssid,
    required this.passwordEncrypted,
    required this.location,
  });

  factory WiFiNetwork.fromJson(Map<String, dynamic> json) {
    return WiFiNetwork(
      ssid: json['ssid'],
      passwordEncrypted: json['password_encrypted'],
      location: WiFiLocation.fromJson(json['location']),
    );
  }
}

class WiFiLocation {
  final double latitude;
  final double longitude;

  WiFiLocation({
    required this.latitude,
    required this.longitude,
  });

  factory WiFiLocation.fromJson(Map<String, dynamic> json) {
    return WiFiLocation(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}
