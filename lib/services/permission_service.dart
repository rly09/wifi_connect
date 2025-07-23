import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Requests location permission (required for WiFi scanning & GPS)
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) return true;

    final result = await Permission.location.request();
    return result.isGranted;
  }

  /// Checks if all necessary permissions are granted
  static Future<bool> hasAllRequiredPermissions() async {
    return await Permission.location.isGranted;
  }

  /// Opens app settings manually if permission is permanently denied
  static Future<void> openAppSettingsIfDenied() async {
    if (await Permission.location.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
