import 'package:hive_flutter/hive_flutter.dart';

class RecipeDatabase {
  List recipeList = [];

  
  final _myBox = Hive.box('mybox');

  
  void createInitialData() {
    recipeList = [];
  }

  
  void loadData() {
    if (_myBox.get("ALL_LISTS") == null) {
      createInitialData();
    } else {
      recipeList = _myBox.get("ALL_LISTS");
    }
  }

  
  void updateData() {
    _myBox.put("ALL_LISTS", recipeList);
  }
}