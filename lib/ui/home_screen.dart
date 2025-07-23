import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/wifi_service.dart';
import '../services/location_service.dart';
import '../models/wifi_network.dart';
import '../utils/base64_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WiFiNetwork> matchedNetworks = [];
  bool isLoading = false;
  String message = '';

  Future<void> handleScanAndConnect() async {
    setState(() {
      isLoading = true;
      message = '';
      matchedNetworks = [];
    });

    // Ask permissions
    final status = await Permission.location.request();
    if (!status.isGranted) {
      setState(() {
        message = 'Location permission denied.';
        isLoading = false;
      });
      return;
    }

    try {
      final supported = await WiFiService.isWiFiScanSupported();
      if (supported) {
        // Android: scan and match
        final scanResults = await WiFiService.scanForNetworks();
        final filtered = WiFiService.matchWithDatabase(scanResults);
        setState(() {
          matchedNetworks = filtered;
          isLoading = false;
        });
      } else {
        // iOS fallback: use GPS to filter nearby
        final userLocation = await LocationService.getCurrentLocation();
        final nearby = WiFiService.getNearbyNetworks(userLocation);
        setState(() {
          matchedNetworks = nearby;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void connectToWiFi(WiFiNetwork network) async {
    final password = Base64Utils.decode(network.passwordEncrypted);

    final success = await WiFiService.connectToNetwork(network.ssid, password);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Connected to ${network.ssid}'
            : 'Failed to connect to ${network.ssid}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Connect'),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : matchedNetworks.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message.isNotEmpty
                  ? message
                  : 'Tap below to scan and connect.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleScanAndConnect,
              child: const Text('Scan & Connect to WiFi'),
            ),
          ],
        )
            : ListView.builder(
          itemCount: matchedNetworks.length,
          itemBuilder: (context, index) {
            final network = matchedNetworks[index];
            return ListTile(
              title: Text(network.ssid),
              subtitle: Text(
                'Lat: ${network.location.latitude}, Lng: ${network.location.longitude}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.wifi),
                onPressed: () => connectToWiFi(network),
              ),
            );
          },
        ),
      ),
    );
  }
}
