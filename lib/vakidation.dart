import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
final storage = FlutterSecureStorage();

class ValidationScreen extends StatefulWidget {
  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  String authToken = '';

  @override
  void initState() {
    super.initState();
    _getAuthToken();
  }

  Future<void> _getAuthToken() async {
    final token = await storage.read(key: 'authToken');
    setState(() {
      authToken = token ?? '';
    });
  }

  Future<void> _validateGoods(String scannedData) async {
    final url = 'https://panda.sociale-konnect.com/api/verif-marchandises';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final body = json.encode({'data': scannedData});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Traitement des données de réponse en cas de succès
      if (responseData['valid']) {
        // Les marchandises sont valides
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation réussie'),
              content: Text('Les marchandises sont valides.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Les marchandises ne sont pas valides
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation échouée'),
              content: Text('Les marchandises ne sont pas valides.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      final errorData = json.decode(response.body);
      // Traitement des données de réponse en cas d'erreur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de validation'),
            content: Text('Une erreur est survenue lors de la validation des marchandises.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _scanQRCode() async {
    try {
      final ScanResult result = await BarcodeScanner.scan();
      final scannedData = result.rawContent;
      _validateGoods(scannedData);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation des marchandises'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanQRCode,
          child: Text('Scanner un code QR'),
        ),
      ),
    );
  }
}
