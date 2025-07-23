# 📡 WiFi Connect App

A cross-platform Flutter app built for the PromptCue Flutter Developer Internship assignment. This app scans available WiFi networks, filters them based on a local base64-encoded JSON database, and attempts to auto-connect using decoded credentials. For platforms like iOS where scanning is restricted, the app gracefully falls back to GPS-based proximity filtering.

---

## 🚀 Features

✅ Scan nearby WiFi networks  
✅ Filter and match against stored database  
✅ Decode base64-encrypted WiFi passwords  
✅ Auto-connect to matching networks (Android only)  
✅ GPS fallback with manual connect instructions (iOS/unsupported)  
✅ Friendly error handling and permission requests  
✅ Fully offline logic and smooth cross-platform support  

---

## 💻 Tech Stack

- **IDE:** Android Studio  
- **Flutter SDK:** ≥ 3.22  
- **Target Platforms:** Android, iOS  

### 📦 Dependencies

| Package              | Purpose                                         |
|----------------------|-------------------------------------------------|
| `wifi_scan`          | Scan nearby WiFi SSIDs                          |
| `permission_handler` | Handle runtime permissions                      |
| `geolocator`         | Get distance between user and saved locations   |
| `location`           | Get current GPS coordinates                     |
| `flutter_blue_plus`  | (Optional) BLE-based experimental extensions    |
| `url_launcher`       | Open device WiFi settings manually              |

---

## 📁 Project Structure

```plaintext
lib/
├── main.dart                       // App entry point
├── screens/
│   └── home_screen.dart           // Main UI
├── services/
│   ├── wifi_network.dart          // WiFi scanning logic
│   ├── permission_service.dart          // Base64 decoding logic
│   └── location_service.dart      // GPS & distance filtering
├── models/
│   └── wifi_network.dart       // WiFi data structure
└── utils/
    └── base64_utils.dart             // UI tile for each network

assets/
└── wifi_database.json        // Local WiFi database
```

---

## 🔐 Permission Handling

**Android**
Requests Location permission at runtime.
Uses wifi_scan to retrieve nearby networks.
Auto-connects (if supported) using platform APIs.

**iOS**
WiFi scanning not allowed; uses GPS fallback.
Filters WiFi networks within ~50 meters radius.
Displays SSID & password for manual connection.

---

## 📎 Submission Info
- **Assignment:** PromptCue Flutter Developer Internship
- **Status:** ✅ Completed & Tested
- **Duration:** 3 Days
- **github:** https://github.com/rly09
