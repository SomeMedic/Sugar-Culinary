import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sugarCulinary/data/categories_database/categories_names.dart';
import 'package:sugarCulinary/pages/filtered_name_recipe.dart';

import 'package:sugarCulinary/pages/add_category.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color background = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF000000);
  static const Color drawer = Color(0xFFEADDFF);
  static const Color accent = Color(0xFF2196F3);
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<CategoriesNames>('catBox').listenable(),
        builder: (context, Box<CategoriesNames> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                "There are no categories",
                style: TextStyle(color: Colors.blueGrey),
              ),
            );
          }
          
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: box.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilteredNameRecipe(
                        categoryName: box.getAt(index)!.categoryName.toString(),
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withOpacity(0.7), AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        box.getAt(index)!.categoryName,
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExistingCategory(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: AppColors.background,
          size: 28,
        ),
      ),
    );
  }
}
