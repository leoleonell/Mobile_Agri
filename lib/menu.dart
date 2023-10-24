import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Notifications.dart';
import 'Produits.dart';
import 'code_qr.dart';
import 'connexion.dart';
import 'discussion.dart';
class MenuCards extends StatefulWidget {
  @override
  _MenuCardsState createState() => _MenuCardsState();
}

class _MenuCardsState extends State<MenuCards>
    with SingleTickerProviderStateMixin {
  String _backgroundImage = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<String> _backgroundImages = [
    'assets/images/pomme.jpg',
    'assets/images/photo-gros-plan-du-jeune-arbre-plante-se-developpe.jpg',
    'assets/images/jeune-femme-posant-portant-robe-feminine-elegante-mode-accessoires-paille.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_animationController);
  }

  void _changeBackgroundImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Changer l\'image de fond'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sélectionnez une nouvelle image de fond :'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _backgroundImages.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(_backgroundImages[index]),
                ),
                onTap: () {
                  setState(() {
                    _backgroundImage = _backgroundImages[index];
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      );
    });
  }

  Future<void> logout() async {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              logout().then((_) {
                Navigator.pushReplacementNamed(context, '/login');
              }).catchError((error) {
                print('Erreur lors de la déconnexion : $error');
              });
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: _backgroundImage.isNotEmpty
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_backgroundImage),
                  fit: BoxFit.cover,
                ),
              )
            : BoxDecoration(
                color: Colors.white,
              ),
        child: Column(
          children: [
            SizedBox(
              height: 95,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0),
              alignment: Alignment.center,
              child: Text(
                'Menu',
                style: GoogleFonts.aboreto(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  ScaleTransition(
                    scale: _animation,
                    child: Card(
                      color: Colors.black,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.qr_code_2_sharp,
                              size: 80,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Scanner",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: Card(
                      color:Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.notifications,
                              size: 80,
                              color: Colors.orange,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: Card(
                      color: Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.production_quantity_limits_sharp,
                              size: 80,
                              color: Colors.green,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Produits",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: Card(
                      color: Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatApp ()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chat,
                              size: 80,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Discussion",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          _changeBackgroundImage();
        },
        child: Icon(
          Icons.settings_outlined,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
