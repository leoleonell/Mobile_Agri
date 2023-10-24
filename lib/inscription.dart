import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signup() async {
    final url = 'https://mon-api-laravel.com/signup';
    final body = jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(url as Uri, body: body, headers: headers);
    if (response.statusCode == 200) {
      // L'inscription a réussi, nous pouvons rediriger l'utilisateur
      Navigator.pushReplacementNamed(context, '/connexion');
    } else {
      // Il y a eu une erreur lors de l'inscription, nous pouvons afficher un message d'erreur à l'utilisateur
      final message = jsonDecode(response.body)['message'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur d\'inscription'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 250),
              child: Center(
                child: Text(
                  "Inscription",
                  style: GoogleFonts.arya(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Adresse e-mail',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Couleur d'arrière-plan du bouton
                onPrimary: Colors.white, // Couleur du texte sur le bouton
                textStyle: TextStyle(fontSize: 20), // Style du texte sur le bouton
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10 ,), // Espacement interne du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordure arrondie du bouton
                ),
              ),
              onPressed: _signup,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
