# AegisHer

AegisHer is a Flutter-based women's safety application designed to provide immediate assistance during emergencies while promoting proactive personal safety. The application combines real-time emergency response, periodic safety monitoring, live location sharing, and AI-powered support into a single platform to help users stay protected.

## Overview

Personal safety often depends on how quickly help can be reached. In many situations, victims may be unable to call or explain their circumstances. AegisHer addresses this challenge by providing both reactive and proactive safety mechanisms.

The application enables users to instantly notify nearby authorities and trusted contacts during emergencies while continuously monitoring user well-being through automated safety check-ins. If the user becomes unresponsive, the application can automatically escalate the situation and notify emergency responders.

## Features

### Emergency SOS

The SOS feature is designed for immediate crisis situations.

* Instantly alerts nearby police stations.
* Notifies certified volunteers in the vicinity.
* Shares the user's live location for rapid response.
* Enables quicker assistance without requiring lengthy communication.

### Live Location Sharing

Users can securely share their real-time location with trusted contacts.

* Share live location with up to three trusted contacts.
* Continuous location updates during emergencies.
* Allows family and friends to monitor the user's safety.

### Safety Pulse

Safety Pulse is AegisHer's proactive safety monitoring system.

The application periodically asks the user:

> "Are you okay?"

If the user confirms, monitoring continues normally.

If multiple consecutive safety checks are missed, AegisHer assumes that the user may be in danger and automatically escalates the situation by:

* Alerting local authorities.
* Notifying certified volunteers.
* Initiating emergency response without requiring manual intervention.

This feature helps protect users even when they are unable to access their phone during an emergency.

### AI Safety Assistant

Many individuals hesitate to discuss uncomfortable or dangerous situations directly with others.

The integrated AI assistant provides:

* Personalized safety guidance
* Emergency recommendations
* Situational awareness tips
* General safety information
* Supportive assistance during stressful situations

The chatbot is intended as an accessible first point of support and guidance.

---

## Technology Stack

* **Framework:** Flutter
* **Language:** Dart
* **Platforms:** Android (Flutter architecture allows future cross-platform support)

---

## Project Structure

```text
lib/
├── main.dart
├── screens/
├── widgets/
├── services/
├── models/
└── utils/
```

The project follows a modular Flutter architecture to keep the UI, business logic, and reusable components organized and maintainable.

---

## Getting Started

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* Android Emulator or Physical Device

### Installation

Clone the repository:

```bash
git clone https://github.com/IntegrationGOAT/AegisHer.git
```

Move into the project directory:

```bash
cd AegisHer
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## Future Scope

Future improvements planned for AegisHer include:

* Direct integration with emergency services
* Verified volunteer network expansion
* Wearable device support
* Offline emergency functionality
* Incident history and analytics
* Community safety reporting
* Multi-language support

---

## Vision

AegisHer aims to leverage technology to create a safer environment for women by reducing emergency response time, enabling proactive protection, and providing accessible support whenever it is needed.

The goal is not only to respond to emergencies, but to help prevent them from escalating.

---
