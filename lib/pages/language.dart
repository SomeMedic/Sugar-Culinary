

import 'package:sugarCulinary/data/language_database/language_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class AppColors {
  static const Color primary = Color(0xFF2196F3);      
  static const Color secondary = Color(0xFF03A9F4);    
  static const Color accent = Color(0xFFFF9800);       
  static const Color background = Color(0xFFFFFFFF);   
  static const Color text = Color(0xFF000000);         
  static const Color drawer = Color(0xFFEADDFF);
  
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color secondaryLight = Color(0xFFB3E5FC);
  static const Color accentLight = Color(0xFFFFE0B2);
}

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  
  LanguageDatabase db = LanguageDatabase();
  final _myBox = Hive.box('mybox');

  late List supportedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    supportedLanguage =
        "English,French,Your device language (english and french available)".split(',');
  }

  
  convertSupportedLanguageForLocalization(index) {
    if (index == 0) {
      return "en";
    } else if (index == 1) {
      return "fr";
    } else if (index == 3) {
      return null; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            "Language",
            style: TextStyle(
              color: AppColors.background,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        drawer: _buildDrawer(),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: supportedLanguage.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  supportedLanguage[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primary),
                onTap: () => _handleLanguageSelection(index),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.drawer,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: Image.asset(
              "android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: "Home",
            onTap: () => Navigator.popAndPushNamed(context, '/home'),
          ),
          _buildDrawerItem(
            icon: Icons.language_sharp,
            title: "Language",
            onTap: () => Navigator.popAndPushNamed(context, '/language'),
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: "About",
            onTap: () => Navigator.popAndPushNamed(context, '/about'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.text,
        ),
      ),
      onTap: onTap,
    );
  }

  void _handleLanguageSelection(int index) {
    setState(() {
      _myBox.put("LANGUAGE", convertSupportedLanguageForLocalization(index));
    });
    _showRestartDialog();
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: SizedBox(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please restart your application\n\nMerci de redémarrer votre application',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.lightGreen,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }
}
