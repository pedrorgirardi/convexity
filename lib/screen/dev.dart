import 'dart:developer';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:convex_wallet/convex.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

import '../nav.dart' as nav;
import '../model.dart';

class DevScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: DevScreenBody(),
    );
  }
}

class DevScreenBody extends StatefulWidget {
  @override
  _DevScreenBodyState createState() => _DevScreenBodyState();
}

class _DevScreenBodyState extends State<DevScreenBody> {
  void scan() async {
    var result = await BarcodeScanner.scan();

    if (result.rawContent.isNotEmpty) {
      log('Scanned QR Code: ${result.rawContent}');

      context.read<AppState>().setState(
            (model) => model.copyWith(
              convexityAddress: Address(hex: result.rawContent),
            ),
          );
    } else {
      log('Scanned QR Code is empty. Will not set Convexity Address.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Container(
      padding: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RadioListTile<Uri>(
              title: Text('convex.world'),
              subtitle: Text('https://convex.world'),
              value: convexWorldUri,
              groupValue: appState.model.convexServerUri,
              onChanged: (value) {
                appState.setState((m) => m.copyWith(convexServerUri: value));
              },
            ),
            RadioListTile<Uri>(
              title: Text('dev'),
              subtitle: Text('http://localhost:8080'),
              value: Uri.parse('http://localhost:8080'),
              groupValue: appState.model.convexServerUri,
              onChanged: (value) {
                appState.setState((m) => m.copyWith(convexServerUri: value));
              },
            ),
            // Convexity Address Input
            TextField(
              decoration: InputDecoration(
                labelText: 'Convexity Address',
              ),
              onChanged: (value) {
                appState.setState(
                  (model) => model.copyWith(
                    convexityAddress: Address(hex: value),
                  ),
                );
              },
            ),
            QrImage(
              data: 'Convexity',
              version: QrVersions.auto,
              size: 160,
            ),
            TextButton(
              child: Text('Scan Convexity QR Code'),
              onPressed: () {
                scan();
              },
            ),
            ElevatedButton(
              child: Text('Start'),
              onPressed: () {
                nav.pushLauncher(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}