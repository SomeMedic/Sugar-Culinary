

import 'package:sugarCulinary/data/recipe_database/database.dart';
import 'package:sugarCulinary/pages/home.dart';
import 'package:sugarCulinary/pages/edit_recipe.dart';
import 'package:sugarCulinary/pages/recipe_struct.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

class FilteredNameRecipe extends StatefulWidget {
  final String categoryName;
  const FilteredNameRecipe({super.key, required this.categoryName});

  @override
  State<FilteredNameRecipe> createState() => _FilteredNameRecipeState();
}

class _FilteredNameRecipeState extends State<FilteredNameRecipe> {
  final _myBox = Hive.box('mybox');
  RecipeDatabase db = RecipeDatabase();

  late final String finalEditRecipeName;

  bool isEditDeleteMode = false;
  bool isSearchPressed = false;

  late String _confirmationTextDeleteOneRecipe;

  late String _confirmationTextDeleteAllRecipe;

  late TextEditingController _searchController;

  late List<dynamic> recipeListFilteredSearch;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    loadAllData();
    recipeListFilteredSearch = db.recipeList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _confirmationTextDeleteOneRecipe =
        AppLocalizations.of(context)!.confirmLongPress2;
    _confirmationTextDeleteAllRecipe =
        AppLocalizations.of(context)!.confirmLongPress3;
  }

  
  loadAllData() {
    setState(() {
      db.loadData();
    });
  }

  void sendDataToEditAtEditRecipe(
      BuildContext context,
      editAllIngredient,
      editStepsRecipe,
      editRecipeCategory,
      editRecipeName,
      editTotalTime,
      editDifficulty,
      editCost,
      isFromScrap,
      editPathImage,
      tags,
      uniqueId,
      editUrlScrap) async {
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipe(
          editAllIngredient: editAllIngredient,
          editStepsRecipe: editStepsRecipe,
          editRecipeCategory: editRecipeCategory,
          editRecipeName: editRecipeName,
          editTotalTime: editTotalTime,
          editDifficulty: editDifficulty,
          editCost: editCost,
          uniqueId: uniqueId,
          isFromScrap: isFromScrap,
          editPathImage: editPathImage,
          tags: tags,
          editUrlImageScrap: editUrlScrap,
        ),
      ),
    );

    if (result != null) {
      String editRecipeName = result;
      setState(() {});
      finalEditRecipeName = editRecipeName;
    }
  }

  void deleteOneRecipe(index) {
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    for (int i = 0; i < recipeList.length; i++) {
      if (recipeListFilteredSearch[index][9] == db.recipeList[i][9]) {
        recipeList.removeAt(i);
      }
    }
    _myBox.put('ALL_LISTS', recipeList);
  }

  void deleteAllRecipe(myBox) {
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    for (int i = recipeList.length - 1; i >= 0; i--) {
      if (recipeList[i][7] == widget.categoryName) {
        recipeList.removeAt(i);
      }
    }
    _myBox.put('ALL_LISTS', recipeList);
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEditDeleteMode = true;
        });
    }
  }

  void _dialogDelete(BuildContext context, String confirmText, deleteFunction,
      {index}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
              child: AlertDialog(
                title: Column(children: [
                  Text(AppLocalizations.of(context)!.areYouSure),
                  Text(AppLocalizations.of(context)!.confirmLongPress4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontStyle: FontStyle.italic))
                ]),
                content: TextButton(
                  onLongPress: () {
                    setState(() {
                      isEditDeleteMode = false;
                      deleteFunction(index);
                    });

                    Navigator.of(context).pop();
                    setState(() {
                      loadAllData();
                      recipeListFilteredSearch = db.recipeList;
                      _searchController.clear();

                      isSearchPressed = false;
                    });
                  },
                  onPressed: () {},
                  child: Text(confirmText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditDeleteMode = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.back),
                  ),
                ],
              ));
        });
  }

  
  void filterList(String searchTerm) {
    setState(() {
      
      recipeListFilteredSearch = db.recipeList
          .where((recipe) =>
              recipe[7] == widget.categoryName &&
              recipe[0].toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: AppColors.background,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isSearchPressed)
            IconButton(
              icon: Icon(Icons.search, color: AppColors.background),
              onPressed: () {
                setState(() {
                  isSearchPressed = true;
                });
              },
            ),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: AppColors.background),
            onSelected: handleClick,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(AppLocalizations.of(context)!.editDelete),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearchPressed)
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: AppColors.primary),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        isSearchPressed = false;
                        loadAllData();
                        recipeListFilteredSearch = db.recipeList;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.primaryLight.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onChanged: (value) => _filterRecipes(value),
              ),
            ),
          Expanded(
            child: _buildRecipeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: recipeListFilteredSearch.length,
      itemBuilder: (context, index) {
        if (recipeListFilteredSearch[index][7] == widget.categoryName) {
          return _buildRecipeCard(index);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildRecipeCard(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          recipeListFilteredSearch[index][0],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        trailing: isEditDeleteMode
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => _handleEdit(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _dialogDelete(
                      context,
                      _confirmationTextDeleteOneRecipe,
                      deleteOneRecipe,
                      index: index,
                    ),
                  ),
                ],
              )
            : null,
        onTap: () => _handleRecipeTap(index),
      ),
    );
  }

  void _handleEdit(int index) {
    setState(() {
      isEditDeleteMode = false;
    });

    sendDataToEditAtEditRecipe(
        context,
        recipeListFilteredSearch[index][4],
        recipeListFilteredSearch[index][6],
        recipeListFilteredSearch[index][7],
        recipeListFilteredSearch[index][0],
        recipeListFilteredSearch[index][1],
        recipeListFilteredSearch[index][2],
        recipeListFilteredSearch[index][3],
        recipeListFilteredSearch[index][8],
        recipeListFilteredSearch[index][5],
        recipeListFilteredSearch[index][10],
        recipeListFilteredSearch[index][9],
        recipeListFilteredSearch[index][14]);

    
    loadAllData();
    recipeListFilteredSearch = db.recipeList;

    setState(() {
      _searchController.clear();

      isSearchPressed = false;
    });
  }

  void _filterRecipes(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        loadAllData();
        recipeListFilteredSearch = db.recipeList;
      } else {
        recipeListFilteredSearch = db.recipeList
            .where((recipe) =>
                recipe[7] == widget.categoryName &&
                recipe[0].toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _handleRecipeTap(int index) async {
    setState(() {});
    loadAllData();

    RecipeStruct recipeInstance = RecipeStruct(
      recipeName: recipeListFilteredSearch[index][0],
      totalTime: recipeListFilteredSearch[index][1],
      difficulty: recipeListFilteredSearch[index][2],
      cost: recipeListFilteredSearch[index][3],
      allIngredientSelected: recipeListFilteredSearch[index][4],
      pathImageSelectedFromImagePicker: recipeListFilteredSearch[index][5],
      stepsRecipeFromCreateSteps: recipeListFilteredSearch[index][6],
      isFromScrap: recipeListFilteredSearch[index][8],
      tags: recipeListFilteredSearch[index][10],
      uniqueId: recipeListFilteredSearch[index][9],
      recipeCategory: recipeListFilteredSearch[index][7],
      isFromFilteredNameRecipe: true,
      urlImageScrap: recipeListFilteredSearch[index][14],
      sourceUrlScrap: recipeListFilteredSearch[index][15],
    );

    loadAllData();
    recipeListFilteredSearch = db.recipeList;
    setState(() {
      _searchController.clear();
      isSearchPressed = false;
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => recipeInstance),
    );

    if (result != null) {
      setState(() {});
    }
  }
}
