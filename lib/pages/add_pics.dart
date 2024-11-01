

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);      
  static const Color secondary = Color(0xFF03A9F4);    
  static const Color accent = Color(0xFFFF9800);       
  static const Color background = Color(0xFFFFFFFF);   
  static const Color text = Color(0xFF000000);         
  
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color secondaryLight = Color(0xFFB3E5FC);
  static const Color accentLight = Color(0xFFFFE0B2);
}

class MyImagePickerPage extends StatefulWidget {
  const MyImagePickerPage({super.key});

  @override
  _MyImagePickerPageState createState() => _MyImagePickerPageState();
}

class _MyImagePickerPageState extends State<MyImagePickerPage> {
  File? _image;
  String? pathImageSelected;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String picturesDirPath = '${appDir.path}/Pictures';

      final Directory picturesDir = Directory(picturesDirPath);
      if (!picturesDir.existsSync()) {
        picturesDir.createSync();
      }

      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String filePath = '$picturesDirPath/$fileName';
      await File(pickedFile.path).copy(filePath);

      setState(() {
        _image = File(filePath);
        pathImageSelected = filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          AppLocalizations.of(context)!.addPicture,
          style: TextStyle(
            color: AppColors.background,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.background),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: _image == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 64,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noPic,
                              style: TextStyle(
                                color: AppColors.text.withOpacity(0.6),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: 24),
              _buildButton(
                icon: Icons.photo_library,
                text: AppLocalizations.of(context)!.chooseGallery,
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              SizedBox(height: 12),
              _buildButton(
                icon: Icons.camera_alt,
                text: AppLocalizations.of(context)!.takePic,
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _image != null
                    ? () => Navigator.pop(context, pathImageSelected)
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.addPicture2,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
