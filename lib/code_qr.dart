import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:animated_card/animated_card.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> actions = [
    {
      'action': 'Vérifier marchandise',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'action': 'Afficher marchandise',
      'icon': Icons.visibility,
      'color': Colors.blue,
    },
    {
      'action': 'Retirer marchandise',
      'icon': Icons.remove_circle,
      'color': Colors.red,
    },
  ];

  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Scanner',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: actions.map((map) {
            String action = map['action'];
            IconData icon = map['icon'];
            Color color = map['color'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 70), // Ajustez les espacements verticaux
              child: AnimatedCard(
                direction: AnimatedCardDirection.bottom,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _scanQRCode(context, action),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Ajustez les espacements internes
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 36, // Ajustez la taille de l'icône
                            color: Colors.white,
                          ),
                          SizedBox(height: 5),
                          Text(
                            action,
                            style: GoogleFonts.roboto(
                              fontSize: 14, // Ajustez la taille de la police
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  Future<void> _scanQRCode(BuildContext context, String action) async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      String qrCodeResult = result.rawContent;

      if (action == 'Vérifier marchandise') {
        await _verifyMarchandise(context, qrCodeResult);
      } else if (action == 'Afficher marchandise') {
        await _afficherMarchandise(context, qrCodeResult);
      } else if (action == 'Retirer marchandise') {
        await _retirerMarchandise(context, qrCodeResult);
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Résultat du scan',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('QR Code: $qrCodeResult\nAction: $action'),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on PlatformException catch (ex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Erreur de scanner',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Autorisation à la caméra refusée',
              style: GoogleFonts.roboto(),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on FormatException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Erreur de scanner',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Lecture annulée',
              style: GoogleFonts.roboto(),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (ex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Erreur de scanner',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Erreur inconnue: $ex',
              style: GoogleFonts.roboto(),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  Future<void> _verifyMarchandise(
      BuildContext context, String qrCodeResult) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      print('oui existe');
      var scanRes = jsonDecode(qrCodeResult);
      /*  var body = {
        'numero': '${scanRes['numero']}',
        'destination': '${scanRes['destination']}',
        'description': '${scanRes['description']}',
        'n°de lot': '${scanRes['n°de lot']}',
        'depart': '${scanRes['depart']}',
        'type': '${scanRes['type']}',
        'quantite': '${scanRes['quantite']}'
      };*/
      try {
        var response = await http.put(
            Uri.parse(
                'https://fresnel.sociale-konnect.com/api/verif-marchandises'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: qrCodeResult);

        print(qrCodeResult);
        var dd = utf8.encode(response.body);
        print(utf8.decode(dd));
        print('ma rep  ${response.body}');
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Reponse'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      } catch (ex) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('title'),
              content: Text('Verification non effectué '),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Le jeton n'est pas disponible dans le stockage local
      // Gérer cela en conséquence, par exemple, rediriger l'utilisateur vers une page de connexion
      // ou afficher un message d'erreur approprié.
    }
  }

  Future<void> _afficherMarchandise(
      BuildContext context, String qrCodeResult) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      print('oui existe');
      var scanRes = jsonDecode(qrCodeResult);
      try {
        var requestBody = jsonEncode(scanRes);

        var response = await http.post(
          Uri.parse(
              'https://fresnel.sociale-konnect.com/api/afficher-marchandise'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        print(qrCodeResult);
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('title'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      } catch (ex) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AffichageQr(qrCodeResult),
          ),
        );
      }
    } else {
      // Le jeton n'est pas disponible dans le stockage local
      // Gérer cela en conséquence, par exemple, rediriger l'utilisateur vers une page de connexion
      // ou afficher un message d'erreur approprié.
    }
  }

  Future<void> _retirerMarchandise(
      BuildContext context, String qrCodeResult) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            String motif = '';
            String quantite = '';

            return AlertDialog(
              title: Text('Résultat du scan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Motif',
                    ),
                    onChanged: (value) {
                      motif = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                    ),
                    onChanged: (value) {
                      quantite = value;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    'Envoyer',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _envoyerMotifQuantite(
                        context, qrCodeResult, motif, quantite);
                    Navigator.of(dialogContext)
                        .pop(); // Fermer le dialogue du formulaire
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'Annuler',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (ex) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Erreur de scanner'),
              content: Text('Erreur inconnue: $ex'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    'OK',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Le jeton n'est pas disponible dans le stockage local
      // Gérer cela en conséquence, par exemple, rediriger l'utilisateur vers une page de connexion
      // ou afficher un message d'erreur approprié.
    }
  }

  Future<void> _envoyerMotifQuantite(BuildContext context, String qrCodeResult,
      String motif, String quantite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      // Vérifier si le jeton est disponible
      if (token != null) {
        var scanRes = jsonDecode(qrCodeResult);

        // Envoi des données à l'API "retirer-marchandises"
        // Remplacez {api_url} par l'URL réelle de l'API
        var response = await http.post(
            Uri.parse(
                'https://fresnel.sociale-konnect.com/api/retirer-marchandise/${int.parse(quantite)}/$motif'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: (qrCodeResult));
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('Succès'),
                content: Text(response.body),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(
                      'OK',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Erreur lors de l'envoi
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('Erreur'),
                content: Text(response.body),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(
                      'OK',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Le jeton n'est pas disponible dans le stockage local
        // Gérer cela en conséquence, par exemple, rediriger l'utilisateur vers une page de connexion
        // ou afficher un message d'erreur approprié.
      }
    } catch (ex) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Une erreur s\'est produite: $ex'),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class AffichageQr extends StatelessWidget {
  String dataBruteQr;

  AffichageQr(this.dataBruteQr);

  @override
  Widget build(BuildContext context) {
    var dataQr = jsonDecode(dataBruteQr);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Error'),
      ),
      body: Center(
        child: Text(dataQr['numero'].toString()),
      ),
    );
  }
}
