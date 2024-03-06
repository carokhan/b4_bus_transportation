import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(QRCodeApp());
}

class QRCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus App QRScanner',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: QRCodeWidget(),
    );
  }
}

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({Key? key}) : super(key: key);

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
      _showSuccessDialog();
    }
  });
}

void _showSuccessDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        backgroundColor: Colors.green,
        title: Text(
          'Success',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'QR Code Scanned Successfully!',
          style: TextStyle(color: Colors.white),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code Scanner",
          style: TextStyle(color: Colors.white)
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
                style: TextStyle(
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
