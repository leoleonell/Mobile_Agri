import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WallpaperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WallpaperScreen(),
    );
  }
}

class WallpaperScreen extends StatefulWidget {
  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String _wallpaperPath = '';

  Future<void> _setWallpaper(String path) async {
    // Add your logic here to set the wallpaper
    // This will vary depending on the platform (Android, iOS)
    // You can use platform-specific plugins or APIs to set the wallpaper
    // For example, on Android, you can use the wallpaper_manager package

    // Placeholder code to print the wallpaper path
    print('Setting wallpaper: $path');
  }

  Future<void> _openImagePicker() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _wallpaperPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose a wallpaper',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            _wallpaperPath.isNotEmpty
                ? Image.file(
                    File(_wallpaperPath),
                    width: 200,
                    height: 200,
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openImagePicker,
              child: Text('Choose Wallpaper'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _wallpaperPath.isNotEmpty
                  ? () => _setWallpaper(_wallpaperPath)
                  : null,
              child: Text('Set as Wallpaper'),
            ),
          ],
        ),
      ),
    );
  }
}
