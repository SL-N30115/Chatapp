ChatApp
ChatApp is a real-time chat application built with Flutter and Firebase. The app allows users to engage in instant messaging with each other, providing a seamless and efficient communication platform.

Features
  Real-time messaging
  User authentication
  Chat rooms
  Message history
  Search User

Firebase Integration
Database
This app uses Firebase Firestore as the main database due to its real-time data transfer capabilities, which are essential for the chat application's functionality. Firestore, a NoSQL database, is an ideal choice for this type of application because it efficiently handles the dynamic and real-time nature of chat data.

Hosting
Firebase Hosting is used to host the web version of the ChatApp, providing a secure and scalable hosting solution.

Authentication
Firebase Authentication is implemented to manage user sign-in and sign-out processes, ensuring secure access to the chat functionalities.

Project Structure
lib/: Contains the Flutter application code.
models/: Data models such as User, Message, and Chatroom.
screens/: Different screens of the app like login, chat room (mainly two screens)
provider/: different type of service provider class.
widgets/: Reusable UI components like chat bubbles and message input fields.
