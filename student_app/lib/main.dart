import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:b4_bus_transportation_student/controllers/user_controller.dart';
import 'package:b4_bus_transportation_student/pages/home_page.dart';
import 'package:b4_bus_transportation_student/pages/login_page.dart';
import 'package:b4_bus_transportation_student/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: UserController.user != null ? const HomePage() : const LoginPage(),
    );
  }
}
