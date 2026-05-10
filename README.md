# DataMind 🧠
### Design and Development of DataMind: An Intelligent Predictive Analytics Platform for Bridging Data Gaps and Enabling Real-Time Decision-Making

---

## 📱 App Overview

**DataMind** is a full-featured Flutter Android application for predictive analytics, real-time data streaming, data gap analysis, and intelligent decision-making.

---

## 🚀 Quick Setup Guide

### Step 1: Install Flutter SDK

1. Go to https://docs.flutter.dev/get-started/install/windows/mobile
2. Download Flutter SDK (Windows)
3. Extract to `C:\flutter`
4. Add `C:\flutter\bin` to your **System PATH**
5. Restart your terminal

### Step 2: Install Android Studio

1. Download from https://developer.android.com/studio
2. Install Android Studio
3. Open → More Actions → SDK Manager
4. Install **Android SDK** (API 33 or higher)
5. Install **Android Emulator**

### Step 3: Accept Android Licenses

```powershell
flutter doctor --android-licenses
```

### Step 4: Open this project

```powershell
cd c:\path\to\pdd
```

### Step 5: Install dependencies

```powershell
flutter pub get
```

### Step 6: Run the app

```powershell
# On emulator or connected Android device:
flutter run

# Or to build APK:
flutter build apk --release
```

---

## 📂 Project Structure

```
pdd/
├── lib/
│   ├── main.dart                  # App entry point
│   ├── app.dart                   # Root app widget
│   ├── theme/
│   │   └── app_theme.dart         # Design system
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── dataset_model.dart
│   │   └── prediction_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart     # Authentication state
│   │   ├── data_provider.dart     # Dataset state
│   │   ├── analytics_provider.dart # ML/analytics state
│   │   └── theme_provider.dart    # Theme state
│   └── screens/
│       ├── splash_screen.dart     # Animated splash
│       ├── auth/                  # Login & Register
│       ├── dashboard/             # Main KPI dashboard
│       ├── analytics/             # Predictive + Real-time
│       ├── data/                  # Data management + Gap analysis
│       ├── reports/               # Reports & Insights
│       └── settings/              # App settings
├── android/                       # Android native config
└── pubspec.yaml                   # Dependencies
```

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 Authentication | Login, Register, persistent sessions |
| 📊 Dashboard | KPI cards, charts (line, bar, pie), alerts |
| 🔮 Predictive Analytics | 8 ML models, feature inputs, confidence scores |
| 📡 Real-Time Streaming | Live data, threshold alerts, decision engine |
| 📁 Data Management | Dataset browser, table viewer, data quality |
| 🕳️ Gap Analysis | MCAR/MAR/MNAR detection, imputation recommendations |
| 📋 Reports | Auto-generated insights, trend comparison, model comparison |
| ⚙️ Settings | Dark mode, notifications, API config, cache |

---

## 🎨 Design System

- **Primary**: `#6C63FF` (Violet)
- **Accent**: `#00D4FF` (Cyan)
- **Success**: `#00E676` (Green)
- **Warning**: `#FFAB00` (Amber)
- **Error**: `#FF5252` (Red)
- **Font**: Inter (Google Fonts)
- **Theme**: Dark by default, Light toggle available

---

## 📦 Dependencies

- `fl_chart` — Beautiful charts
- `provider` — State management
- `google_fonts` — Inter typeface
- `shared_preferences` — Persistent storage
- `animated_text_kit` — Text animations

---

## 🎓 Academic Project

> **Title**: Design and Development of DataMind: An Intelligent Predictive Analytics Platform for Bridging Data Gaps and Enabling Real-Time Decision-Making

This app demonstrates:
- Predictive analytics with multiple ML model interfaces
- Real-time data processing and visualization
- Intelligent data gap identification and remediation
- Decision support systems
- Modern Android mobile development with Flutter
