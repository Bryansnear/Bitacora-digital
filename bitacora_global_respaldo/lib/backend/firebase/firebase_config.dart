import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDYB5vhmTcZsC-3c-c9Cn7_FouLBiQd_YU",
            authDomain: "bitacoraglobaldigital.firebaseapp.com",
            projectId: "bitacoraglobaldigital",
            storageBucket: "bitacoraglobaldigital.appspot.com",
            messagingSenderId: "388403917793",
            appId: "1:388403917793:web:36104254b582f8f5e258a0",
            measurementId: "G-LC6855EKMX"));
  } else {
    await Firebase.initializeApp();
  }
}
