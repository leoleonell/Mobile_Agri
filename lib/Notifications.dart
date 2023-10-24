import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _notifications = [
    {'name': 'Tomate depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Riz depuis lome', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Gari depuis kpalime', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Igname depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Bananes depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Hricots depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Bananes depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Hricots depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
    {'name': 'Tapioca depuis kara', 'image': 'assets/images/pomme.jpg'},
    {'name': 'Oignons depuis kara', 'image': 'assets/images/pomme-verte.jpg'},
    {'name': 'Piments depuis kara', 'image': 'assets/images/delicious-carrot-raw.jpg'},
    {'name': 'Cotons depuis kara', 'image': 'assets/images/fresh-beetroot-isolated-white.jpg'},
  ];

  List<Map<String, dynamic>> _filteredNotifications = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredNotifications.addAll(_notifications);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    _filteredNotifications.clear();
    if (text.isEmpty) {
      _filteredNotifications.addAll(_notifications);
    } else {
      _notifications.forEach((notification) {
        if (notification['name'].toLowerCase().contains(text.toLowerCase())) {
          _filteredNotifications.add(notification);
        }
      });
    }
    setState(() {});
  }

  void _removeNotification(int index) {
    setState(() {
      _filteredNotifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Recherche...',
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: _onSearchTextChanged,
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredNotifications.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Image.asset(
                _filteredNotifications[index]['image'],
                width: 100,
                height: 100,
              ),
              title: Text(_filteredNotifications[index]['name']),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeNotification(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
