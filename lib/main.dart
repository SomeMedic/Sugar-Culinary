



import 'package:sugarCulinary/pages/about.dart';
import 'package:sugarCulinary/pages/language.dart';
import 'package:sugarCulinary/pages/add_ingredients.dart';
import 'package:sugarCulinary/data/categories_database/categories_names.dart';
import 'package:sugarCulinary/data/categories_database/categories_names_services.dart';
import 'package:sugarCulinary/pages/create_recipe.dart';
import 'package:sugarCulinary/utils/dialbox_add_ingredient_quantity.dart';
import 'package:flutter/material.dart';
import 'package:sugarCulinary/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Hive.initFlutter();

  
  Hive.registerAdapter(CategoriesNamesAdapter());

  
  
  var box = await Hive.openBox('mybox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CategoriesNamesService _categoriesNamesService =
      CategoriesNamesService();

  MyApp({super.key});

  @override

  
  final _myBox = Hive.box('mybox');

  
  checkLanguagePref() {
    if (_myBox.get("LANGUAGE") != null) {
      return Locale(_myBox.get("LANGUAGE"));
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooky',
      
      locale:
          checkLanguagePref(), 

      localizationsDelegates: const [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
        Locale('fr'), 
      ],

      debugShowCheckedModeBanner: false,
      
      home: FutureBuilder(
        future: _categoriesNamesService.getAllCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriesNames>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      routes: {
        

        '/create_recipe': (context) => CreateRecipe(),
        '/add_ingredients': (context) => AddIngred(),
        '/dialbox_add_ingredient_and_quantity': (context) =>
            const AddIngredientQuantity(),
        '/language': (context) => const Language(),
        '/about': (context) => const About(),
        '/home': (context) => const Home(),
      },
    );
  }
}
