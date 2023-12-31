import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:food_delivery_app/screens/loginpages/login.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51NFixQCVb0Rqd9taSEFm26LwjEVwLHhX54xYStrjry4EgGfF4bySZuMfRHYDtmdHqgXChMccn2A1G68720CqZyUe00hDs9luw2';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    // Stripe.instance.initPaymentSheet(
    //     paymentSheetParameters: SetupPaymentSheetParameters());
    return MaterialApp(
      title: 'Food App',
//      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<User>(
        future: _authMethods.getCurrentUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          return LoginPage();
        },
      ),
    );
  }
}
