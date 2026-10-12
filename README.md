# Taxi Ale (ታክሲ አለ)
> **Real-Time Minibus Transit Tracking & Seat Availability for Addis Ababa**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Figma](https://img.shields.io/badge/Figma-Design_System_%26_Prototype-F24E1E?logo=figma&logoColor=white)](https://www.figma.com/design/Fn2plgWvIrb6sldOW1LkiZ/Taxi-Ale-%E2%80%94-Public-Transit-UI-UX---Design-System?node-id=0-1&t=pWrU9bunlFsE7xq1-1)
[![OpenStreetMap](https://img.shields.io/badge/Maps-OpenStreetMap-7EBC6F?logo=openstreetmap&logoColor=white)](https://www.openstreetmap.org)
[![OSRM](https://img.shields.io/badge/Routing-OSRM_Free_API-blue?logo=openstreetmap&logoColor=white)](https://project-osrm.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Table of Contents
- [ Problem & Motivation](#problem--motivation)
- [ UI/UX Design System & Figma Prototype](#uiux-design-system--figma-prototype)
- [ Key Features](#key-features)
  - [ Passenger Experience](#1-passenger-experience)
  - [ Driver Dashboard](#2-driver-dashboard)
- [ System Architecture & Technology Stack](#system-architecture--technology-stack)
- [ Project Structure](#project-structure)
- [ Getting Started](#getting-started)
- [ Engineering Highlights for Reviewers](#engineering-highlights-for-reviewers)
- [ License](#license)

---

## Problem & Motivation
In Addis Ababa, millions of commuters rely daily on white-and-blue minibus taxis (ታክሲ). However, daily transit presents major hurdles:
- **Unpredictable Wait Times**: Long terminal queues without visibility into when the next vehicle is approaching.
- **Unknown Seat Capacity**: Inability to determine whether an approaching minibus has empty seats or is already full.
- **Route Information Gaps**: Lack of live route tracking along congested corridors (*Bole, Megenagna, Mexico, Piazza, Torhailoch*).

**Taxi Ale** bridges this information gap by directly linking commuters and minibus operators:
- Drivers broadcast their live GPS location and available seat count in real time.
- Commuters discover approaching taxis, check available seats, view precise ETAs, and plan boarding before the taxi arrives at their stop.

---

## UI/UX Design System & Figma Prototype

> **Interactive Prototype & Wireframes**: [View Taxi Ale on Figma](https://www.figma.com/design/Fn2plgWvIrb6sldOW1LkiZ/Taxi-Ale-%E2%80%94-Public-Transit-UI-UX---Design-System?node-id=0-1&t=pWrU9bunlFsE7xq1-1)

The application was designed and wireframed in **Figma** prior to engineering implementation:

| Design Dimension | Implementation Details |
|---|---|
| **Branding & Palette** | Centered on **Addis Teal** (`#2C7480`), Soft Cyan (`#62929E`), Surface Gray (`#EAF1F3`), and Slate Text (`#1E293B`) |
| **Typography** | Clear typographic hierarchy optimized for outdoor legibility in bright sunlight |
| **Dual User Journeys** | Dedicated, end-to-end user flows for both **Passengers** and **Minibus Drivers** |
| **Ergonomics** | Thumb-zone reachable bottom action sheets with auto-collapsing search drawers |

> **Full Design System & Screen Breakdown**: [View `docs/FIGMA_SCREENS.md`](docs/FIGMA_SCREENS.md)

<p align="center">
  <img src="docs/figma_overview.png" alt="Taxi Ale Figma UI Screens" width="100%">
</p>

---

## Key Features

### 1. Passenger Experience
- **Live Device GPS Tracking**: Instant location lock with animated re-center controls and permissions handling.
- **OpenStreetMap & OSRM Engine**: 100% free, billing-free global street map tiles with turn-by-turn road polyline routing without Google Cloud billing dependencies.
- **Predictive Autocomplete Search**: Instant local terminal prediction for 30+ major Addis Ababa taxi hubs (with English and Amharic names) + online OpenStreetMap Nominatim fallback.
- **1-Tap Quick Route Chips**: Instant destination selection for top commuter hubs (*Mexico, Bole, Megenagna, Piazza, Torhailoch, Saris, 4 Kilo*).
- **Approaching Minibus Markers**: Custom 3D minibus vehicle icons on the map showing real-time available seats (e.g. `3 seats free`) and flat fare pricing.
- **Adaptive UI**: Non-intrusive bottom trip cards that auto-collapse to ensure the map and destination are never obscured.

### 2. Driver Dashboard
- **Driver Onboarding & License Verification**: Integrated camera and photo gallery modal sheet with credential verification badge.
- **Route & Plate Configuration**: Minibus plate number validation with live interactive route map preview and route presets (*Mexico ⇄ Bole, Megenagna ⇄ Piazza*).
- **Live Location Broadcasting**: Real-time GPS stream broadcasting to nearby commuters.
- **Live Seat Availability Manager**: Interactive seat counter (`-` / `+`) allowing drivers to update free seats in real time.

---

## System Architecture & Technology Stack

| Layer | Technology | Engineering Rationale |
|---|---|---|
| **Frontend Framework** | **Flutter / Dart** | Cross-platform performance with fluid 60fps animations |
| **Map Rendering** | **OpenStreetMap (`flutter_map`)** | Free, open-source, billing-free mapping infrastructure |
| **Routing & Directions** | **OSRM Driving API** | Real street-accurate turn-by-turn road geometries (GeoJSON) |
| **Geolocation** | **`geolocator`** | Multi-phase GPS retrieval (cached location first, satellite fix second) |
| **Networking** | **`http`** | Asynchronous REST consumption with debounced geocoding |
| **Design System** | **Material 3 + Custom Palette** | Custom Addis Teal theme (`#2C7480`), unified curve sheets, and custom back buttons |

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_assets.dart           # Asset paths (3D minibus, skyline, logo)
│   │   └── app_colors.dart           # Primary branding palette
│   └── widgets/
│       └── custom_back_button.dart   # Unified back navigation control
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart        # Branded launch screen
│   ├── role_selection/
│   │   └── role_selection_screen.dart# Passenger vs. Driver gateway
│   ├── passenger/
│   │   ├── passenger_login_screen.dart        # 9-digit Ethiopian MSISDN validation
│   │   ├── passenger_verify_phone_screen.dart # Phone verification confirmation
│   │   ├── passenger_otp_screen.dart          # 4-digit PIN verification interface
│   │   ├── passenger_location_screen.dart    # GPS permission onboarding
│   │   └── passenger_home_screen.dart        # Live map, OSRM routing & minibus discovery
│   └── driver/
│       ├── driver_login_screen.dart    # License capture & credentials
│       ├── driver_route_screen.dart    # Interactive route preview & plate input
│       ├── driver_location_screen.dart # Driver GPS broadcast authorization
│       └── driver_live_screen.dart     # Live broadcast map & seat counter (+/-)
└── main.dart                           # Application entry point
```

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13.0 or higher)
- Android Studio / VS Code with Flutter extension
- Connected Android device or emulator (Android 8.0+ recommended)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/adios-mars/taxi-ale.git
   cd taxi-ale
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code analysis:**
   ```bash
   flutter analyze
   ```
   *(Verified: 0 issues found)*

4. **Launch the app:**
   ```bash
   flutter run
   ```

---

## Engineering Highlights for Reviewers

- **Zero-Cost Transit Tracking Architecture**: Instead of paying Google Maps Directions API fees per API call, implemented an open-source architecture utilizing OpenStreetMap and OSRM (Open Source Routing Machine), eliminating recurring cloud mapping bills.
- **Two-Phase GPS Location Retrieval**: Implemented instant cached position reading (`getLastKnownPosition`) for immediate UI rendering, followed by accurate satellite fixes (`getCurrentPosition`), preventing blank map freezes.
- **Offline In-Memory Terminal Registry**: Pre-indexed 30+ major Addis Ababa minibus terminals with English and Amharic names to deliver zero-latency autocomplete without unnecessary network calls.
- **Debounced Geocoding**: Text inputs are debounced (600ms) before querying OpenStreetMap Nominatim to respect rate limits and reduce battery consumption.
- **Responsive & Overflow-Safe**: Built with responsive layouts, `SingleChildScrollView` wrappers, and `resizeToAvoidBottomInset` safeguards to guarantee zero `RenderFlex` overflow errors across small screens and virtual keyboards.

---

## License
This project is open-source under the [MIT License](LICENSE).
