# Find My Carz Business & Partner Portal 🚗💼

Official B2B Business & CRM Mobile Application for **Find My Carz**, designed for Super Admins and Channel Partners to manage used car dealership operations, buyer leads, car financing pipelines, and commission payouts seamlessly.

---

## 🌟 Key Features

- **🔐 Role-Based Access Control (RBAC)**: Dedicated portal experiences for **Super Admins** and **Channel Partners**.
- **📊 Real-Time Analytics Dashboard**: Overview of total leads, loan disbursements, conversion rates, and monthly revenue metrics.
- **📋 CRM & Lead Management**:
  - Track car buyer and seller leads across multiple pipeline stages.
  - Quick dialer and WhatsApp action integration.
  - Car loan application processing with instant status updates.
- **💰 Payout & Commission Engine**:
  - Outward payout tracking and transaction ledger.
  - Partner commission calculations with breakdown reports.
- **🎨 Modern & Premium UI/UX**:
  - Brand-consistent splash screen with smooth entry animations.
  - Custom brand icons across Android, iOS, Web, and Desktop.
  - Clean Poppins typography and responsive design.

---

## 🏗️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart 3.x)
- **State Management**: [Provider](https://pub.dev/packages/provider) (MVVM Pattern)
- **Networking**: [Dio](https://pub.dev/packages/dio) with custom interceptors and error handlers
- **Storage**: [SharedPreferences](https://pub.dev/packages/shared_preferences) for local token and session persistence
- **Typography & Styling**: Google Fonts (`Poppins`), Material 3 design

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0 <4.0.0`
- Android Studio / Xcode
- Dart SDK installed

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/findmycarz_business.git
   cd findmycarz_business
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
lib/
├── core/            # App constants, network clients, utilities, and theme
├── models/          # Data models (Leads, Payouts, Dashboard, Cars)
├── viewmodels/      # Business logic & state management (MVVM)
├── views/           # UI screens (Splash, Auth, Leads, Dashboard, Payouts)
└── main.dart        # App entry point & dependency injection
```

---

## 📄 License

Proprietary and confidential. Developed for **Find My Carz**.
