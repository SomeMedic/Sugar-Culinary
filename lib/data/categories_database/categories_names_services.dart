



import 'package:sugarCulinary/data/categories_database/categories_names.dart';
import 'package:hive/hive.dart';

class CategoriesNamesService {
  
  final String _boxName = "catBox";

  
  
  Future<Box<CategoriesNames>> get _box async =>
      await Hive.openBox<CategoriesNames>(_boxName);

  

  
  Future<void> addCategory(CategoriesNames categoriesNames) async {
    var box = await _box;

    await box.add(categoriesNames);
  }

  
  Future<List<CategoriesNames>> getAllCategories() async {
    var box = await _box;
    return box.values.toList();
  }

  
  Future<void> updateCategory(CategoriesNames categoriesName) async {
    var box = await _box;
    categoriesName != categoriesName;
  }

  
  Future<void> deleteCategory(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }
}
