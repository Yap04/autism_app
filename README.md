# Autism App 🧩

A comprehensive mobile application built with **Flutter** and **Firebase**, designed to support the autism community. This project serves as my Final Year Project (FYP) and connects parents with specialized trainers, facilitating appointments, payments, and AI-assisted support.

## ✨ Key Features

*   **Role-Based Authentication**: Secure login and registration for Parents and Trainers using Firebase Auth.
*   **Trainer Discovery & Booking**: View trainer profiles, check availability, and book sessions seamlessly.
*   **Integrated Payments**: Secure payment processing for bookings using the **Stripe API**.
*   **Location & Maps**: View appointment locations and trainer proximities via the **Google Maps SDK**.
*   **AI Chat Assistant**: Intelligent chatbot powered by the **Google Gemini API** to provide instant guidance and support.
*   **Real-time Chat & Notifications**: In-app messaging and push notifications for appointment updates.
*   **Secure Image Uploads**: Profile and content image management using the **ImgBB API**.

## 🛠️ Tech Stack

*   **Frontend**: Flutter (Dart)
*   **Backend / Database**: Firebase (Authentication, Cloud Firestore, Firebase Cloud Messaging)
*   **Third-Party APIs**: 
    *   Google Maps SDK (Android/iOS)
    *   Google Gemini API
    *   Stripe API
    *   ImgBB API
*   **Architecture & Security**: 
    *   Environment variables managed via `flutter_dotenv`.
    *   Dynamic Android Manifest injection for secure Map rendering.
    *   Strict Firestore Security Rules (`request.auth != null`).

---

## 🚀 Getting Started

Follow these instructions to set up and run the project on your local machine.

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version 3.x+).
*   A [Firebase](https://firebase.google.com/) project configured for Android/iOS.
*   Your own API Keys for Stripe, Google Maps, Gemini, and ImgBB.

### 1. Clone the repository

```bash
git clone https://github.com/your-username/autism_app.git
cd autism_app
```

### 2. Configure Environment Variables (Crucial)

For security reasons, API keys are **not** included in this repository. You must configure your own keys.

1. In the root directory, locate the `.env.example` file (or create one).
2. Create a new file named `.env` in the root directory.
3. Copy the variables from the example and paste in your actual keys:

```env
STRIPE_PUBLIC_KEY=your_stripe_public_key_here
STRIPE_SECRET_KEY=your_stripe_secret_key_here
GEMINI_API_KEY=your_gemini_api_key_here
IMGBB_API_KEY=your_imgbb_api_key_here
```

### 3. Configure Google Maps for Android

To safely inject the Google Maps API key into the Android application:

1. Navigate to the `android/` folder.
2. Create a file named `local.properties` (if it doesn't already exist).
3. Add your Google Maps API key at the bottom of the file:

```properties
MAPS_API_KEY=your_google_maps_api_key_here
```
*(Note: Do not use quotes around the key)*

### 4. Install Dependencies

```bash
flutter clean
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

---

## 🛡️ Security Note

This repository enforces strict API key security. The `.env` and `android/local.properties` files are intentionally ignored by Git (`.gitignore`). If you fork or clone this project, you **must** supply your own credentials to test the features fully. 

## 📝 License

This project is created for educational purposes and portfolio demonstration as a Final Year Project. 
