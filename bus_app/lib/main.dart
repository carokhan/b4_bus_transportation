import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const QRCodeApp());
}

class QRCodeApp extends StatelessWidget {
  const QRCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus App QRScanner',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const QRCodeWidget(),
    );
  }
}

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  late QRViewController controller;
  String result = "";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

void _onQRViewCreated(QRViewController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) {
    if (scanData.code != result) {
      setState(() {
        result = scanData.code!;
      });
      int nameIndex = scanData.code!.indexOf("Name:");
      if (nameIndex != -1) {
        String studentName = scanData.code!.substring(nameIndex + "Name:".length).trim();
        _showSuccessDialog(studentName);
      } else {
        _showErrorDialog();
      }
    }
  });
}

void _showSuccessDialog(String studentName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        backgroundColor: Colors.green,
        title: Text(
           'QR Code Scanned Successfully!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        content: SizedBox(
          height: 75,
          child: Center(
            child: Text(
              'Student Name: $studentName',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _showErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        backgroundColor: Colors.red,
        title: Text(
          'Error',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        content: SizedBox(
          height: 75,
          child: Center(
            child: Text(
              'Invalid QR Code Format',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      );
    },
  );
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student QR Code Scanner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  cameraFacing: CameraFacing.front,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/overlay.png',
                    fit: BoxFit.cover,
                    width: 235,
                    height: 235,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Scan Result: $result",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}