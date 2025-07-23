import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as loc;
import 'package:wifi_iot/wifi_iot.dart';
import '../models/wifi_network.dart';
import 'location_service.dart';

class WiFiService {
  static const String _jsonDbAsset = 'assets/wifi_database.json';
  static List<WiFiNetwork> _dbNetworks = [];

  /// Load database (only once)
  static Future<void> loadDatabase() async {
    if (_dbNetworks.isEmpty) {
      final String data = await rootBundle.loadString(_jsonDbAsset);
      final List<dynamic> jsonList = json.decode(data);
      _dbNetworks = jsonList.map((e) => WiFiNetwork.fromJson(e)).toList();
    }
  }

  /// Check if WiFi scan is supported (Android only)
  static Future<bool> isWiFiScanSupported() async {
    // On iOS, this usually returns false
    return await WiFiForIoTPlugin.isWiFiAPEnabled();
  }

  /// Scan for available networks (Android)
  static Future<List<String>> scanForNetworks() async {
    await loadDatabase();
    final List<WifiNetwork?> scanned = await WiFiForIoTPlugin.loadWifiList() ?? [];
    return scanned.map((e) => e?.ssid ?? '').where((e) => e.isNotEmpty).toList();
  }

  /// Match scanned SSIDs with entries in database
  static List<WiFiNetwork> matchWithDatabase(List<String> scannedSSIDs) {
    return _dbNetworks
        .where((network) => scannedSSIDs.contains(network.ssid))
        .toList();
  }

  /// Get nearby networks based on user location (for iOS fallback)
  static List<WiFiNetwork> getNearbyNetworks(loc.LocationData userLocation, {double radiusMeters = 50}) {
    return _dbNetworks.where((network) {
      final distance = LocationService.calculateDistanceMeters(
        userLocation.latitude ?? 0.0,
        userLocation.longitude ?? 0.0,
        network.location.latitude,
        network.location.longitude,
      );
      return distance <= radiusMeters;
    }).toList();
  }

  /// Connect to WiFi programmatically (Android only)
  static Future<bool> connectToNetwork(String ssid, String password) async {
    try {
      return await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
        joinOnce: true,
      );
    } catch (e) {
      return false;
    }
  }
}
