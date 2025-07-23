import 'package:flutter/material.dart';
import 'package:wifi_connect/ui/home_screen.dart';

void main() {
  runApp(const WiFiConnectApp());
}

class WiFiConnectApp extends StatelessWidget {
  const WiFiConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3:false,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
