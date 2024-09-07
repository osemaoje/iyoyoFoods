# Iyoyo Foods

Iyoyo Foods Apps.

## Getting Started

# 🍔 Iyoyo Food App

A mobile application built using **Flutter** and **Firebase** that allows users to order food from local restaurants. This app features a clean and intuitive user interface, secure authentication.

## 📱 Screenshots

*(Include screenshots here to showcase the app's user interface and design)*

## ✨ Features

- **User Authentication**: Sign up, log in, and manage accounts with Firebase Authentication.
- **Categories Listings**: Browse local foods with detailed menus and pricing.
- **Food Search**: Search and filter restaurants by type, rating, and distance.
- **Add to Cart**: Add food items to a cart.
- **Order History**: View previous orders.
- **Payment Integration**: Secure payment via third-party APIs using Paystack.
- **Favorites**: Save favorite restaurants and food items for quick access.
  
## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Firestore (NoSQL Database), Firebase Authentication
- **Payment Gateway**: (e.g., Paystack)

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed
- [Firebase](https://firebase.google.com/) account and project setup
- [Google Maps API Key](https://developers.google.com/maps/gmp-get-started)
  
### Clone the Repository

```bash
git clone https://github.com/yourusername/food-delivery-app.git
cd food-delivery-app
```

### Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
2. Add Android/iOS app to your Firebase project.
3. Download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) and place them in the respective directories:
   - `android/app/`
   - `ios/Runner/`
4. Enable **Firebase Authentication** and set up **Firestore** for the app's database.

### Google Maps Setup

1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/).
2. Add your API key to the `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`.

### Running the App

```bash
flutter pub get
flutter run
```

### Testing

```bash
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Google Maps API](https://developers.google.com/maps)

---

You can modify and extend this README as per your project's specific features and requirements.
