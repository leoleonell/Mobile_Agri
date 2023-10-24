import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu.dart';

// Classe modèle pour stocker les informations d'authentification
class AuthModel {
  String email;
  String password;

  AuthModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String email = '';
  String password = '';
  String errorMessage = '';
  bool _showPassword =
      false; // Variable pour gérer la visibilité du mot de passe

  void _login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await login(email, password);
      final token = response[
          'token']; // Supposons que la réponse de l'API renvoie un jeton sous la clé 'token'

      // Sauvegarde du jeton d'API dans le stockage local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Naviguez vers une nouvelle page après une connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuCards()),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Login",
          style: GoogleFonts.abhayaLibre(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Lottie.asset("assets/images/animation_lksq5fsa.json"),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Adresse e-mail',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.email, color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: Colors.green,
                    // Utilisez la propriété style pour changer la couleur du texte saisi
                    // dans le champ de texte.
                  ),



                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  style: TextStyle(color: Colors.black),

                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: !_showPassword,
                  // Utilisez _showPassword pour afficher ou masquer le mot de passe
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: Colors.black),  // Ajout de cette ligne
                    prefixIcon: Icon(Icons.lock, color: Colors.green),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Ajoutez une icône pour activer/désactiver la visibilité du mot de passe
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child: Text(
                    'CONNEXION',
                    style: GoogleFonts.abhayaLibre(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (isLoading)
                CircularProgressIndicator()
              else if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fonction pour effectuer une demande de connexion à l'API
Future<Map<String, dynamic>> login(String email, String password) async {
  final authModel = AuthModel(email: email, password: password);
  final response = await http.post(
    Uri.parse('https://fresnel.sociale-konnect.com/api/login'),
    // Remplacez l'URL par l'URL de votre API de connexion
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(authModel.toJson()),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    // Traitez la réponse de l'API et renvoyez les données nécessaires
    return responseData;
  } else {
    throw Exception('Échec de la connexion');
  }
}
