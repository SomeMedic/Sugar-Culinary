

import 'package:hive_flutter/hive_flutter.dart';


class LanguageDatabase {
  String? languageSelected;
  
  final _myBox =
      Hive.box('mybox'); 

  
  loadDataLanguage() {
    languageSelected = _myBox.get("LANGUAGE");
  }

  
  updateDataBase() {
    _myBox.put("LANGUAGE", languageSelected);
  }
}
