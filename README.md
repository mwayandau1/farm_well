# 🌾 AI-Powered Mobile Farming Application
Welcome to the AI-Powered Mobile Farming Application! This application is designed to help farmers predict crop and plant diseases, provide precautions and recommended treatments, and offer educational content. Additionally, it enables farmers to interact with each other on the platform.

## ✨ Features
- Disease Prediction: Utilize AI to predict potential crop and plant diseases based on images and other inputs.
- Precautions and Treatments: Receive expert recommendations for disease prevention and treatment.
- Educational Content: Access a library of educational resources to learn about best farming practices, crop management, and more.
- Community Interaction: Connect and interact with other farmers, share experiences, and ask for advice within the community.
## 🛠️ Technologies Used
- Tensorflow: Python framework for training the model
- Vision Transformer: Model architecture in which the dataset was trained on
- Flutter: A UI toolkit for crafting natively compiled applications for mobile, web, and desktop from a single codebase.
- Firebase: A platform developed by Google for creating mobile and web applications.
- Firebase Auth: Secure authentication system that provides a way to authenticate users of the application.
- Firebase Firestore: NoSQL cloud database to store and sync data for client- and server-side development.
- Firebase Storage: Store and serve user-generated content, such as images and videos.
## 🚀 Getting Started
Prerequisites
Ensure you have the following installed on your development machine:

- Flutter
- Firebase CLI
- Tensorflow
- Keras
- Numpy
Installation
Clone the Repository

bash
Copy code
git clone https://github.com/mwayandau1/farm_well.git
cd ai-farming-app
Install Dependencies

bash
Copy code
flutter pub get
Set Up Firebase

Create a new project in the Firebase Console.
- Add an Android and/or iOS app to your Firebase project.
- Follow the instructions to download the google-services.json (for Android) and/or GoogleService-Info.plist (for iOS) and place them in the appropriate directories:
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
Configure Firebase in Your Flutter App

Ensure your pubspec.yaml includes the necessary Firebase dependencies:

yaml
Copy code
dependencies:
  flutter:
    sdk: flutter
  firebase_core: latest_version
  firebase_auth: latest_version
  cloud_firestore: latest_version
  firebase_storage: latest_version
  Add other dependencies as needed
## Run the App

bash
Copy code
flutter run
## 📱 Usage
### Disease Prediction: Upload images of crops/plants and let the AI model predict potential diseases.
- Precautions and Treatments: Get actionable advice on how to prevent and treat detected diseases.
- Educational Content: Browse through articles, videos, and tutorials on various farming topics.
- Community Interaction: Join discussions, ask questions, and share knowledge with fellow farmers.
## 🤝 Contributing
We welcome contributions! Please see our CONTRIBUTING.md for guidelines on how to contribute to this project.

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for details.

## 📧 Contact
For questions or suggestions, please contact us at mosesayandau1@gmail.com.

