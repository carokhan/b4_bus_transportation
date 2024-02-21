import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:b4_bus_transportation_student/controllers/user_controller.dart';
import 'package:b4_bus_transportation_student/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = '';
  final GlobalKey _qrkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage:
                  NetworkImage(UserController.user?.photoURL ?? ''),
            ),
            Text(UserController.user?.displayName ?? ''),
            Text("Encoding data: " +"Unix Timestamp: " + DateTime.now().millisecondsSinceEpoch.toString() + "Firebase UID: " + (UserController.user?.uid ?? '') + "Display Name: " + (UserController.user?.displayName ?? '')),
            ElevatedButton(
                onPressed: () async {
                  await UserController.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                  }
                },
                child: const Text("Log out")),
            RawMaterialButton(
            onPressed: () {
              setState(() {
                data = "Unix Timestamp: " + DateTime.now().millisecondsSinceEpoch.toString() + "Firebase UID: " + (UserController.user?.uid ?? '') + "Display Name: " + (UserController.user?.displayName ?? '');
              });
            },
            fillColor: Colors.black,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: const Text(
              'Generate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: RepaintBoundary(
              key: _qrkey,
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 250.0,
                gapless: true,
                errorStateBuilder: (ctx, err) {
                  return const Center(
                    child: Text(
                      'Something went wrong!!!',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}