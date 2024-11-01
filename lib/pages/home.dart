



import 'dart:io';

import 'package:sugarCulinary/pages/edit_recipe.dart';
import 'package:sugarCulinary/pages/filtered_name_recipe.dart';
import 'package:sugarCulinary/data/categories_database/categories_names.dart';
import 'package:sugarCulinary/data/categories_database/categories_names_services.dart';
import 'package:sugarCulinary/pages/recipe_struct.dart';
import 'package:sugarCulinary/pages/scraping.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sugarCulinary/data/recipe_database/database.dart';
import 'package:marmiteur/marmiteur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sugarCulinary/pages/categories_page.dart';

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CategoriesNamesService _categoriesNamesService =
  CategoriesNamesService();
  final TextEditingController _controller = TextEditingController();

  
  final _myBox = Hive.box('mybox');
  RecipeDatabase db = RecipeDatabase();

  bool isEditDeleteMode = false;
  bool isFloatingActionButtonPressed = false;
  bool isSearchPressed = false;

  
  late List<String> scrapStepsRecipe;
  late List scrapIngredient;
  late String scrapRecipeName;
  late String scrapTotalTime;
  late List scrapTags;
  late List scrapImage;

  
  late TextEditingController _searchController;

  late List<dynamic> recipeListFilteredSearch;

  bool _isConfirmBack = false;
  bool scrapInstanceCreated = false;
  Map marmiteurResult = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchController = TextEditingController();

    loadAllData();
    recipeListFilteredSearch = db.recipeList;
  }

  
  Future<void> loadAllData() async {
     db.loadData(); 
    setState(() {}); 
  }

  
  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEditDeleteMode = true;
          _searchController.clear();
          isSearchPressed = false;
        });
        break; 

      case 1:
        setState(() {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.addCategory),
                  content: TextField(
                    controller: _controller,
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.cancel),
                      onPressed: () async {
                        _controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.add),
                      onPressed: () async {
                        setState(() {
                          isEditDeleteMode = false;
                          _searchController.clear();
                          isSearchPressed = false;
                        });

                        if (_controller.text.trim().isNotEmpty) {
                          var catName = CategoriesNames(_controller.text);

                          await _categoriesNamesService.addCategory(catName);
                        } else {
                          
                        }
                        Navigator.pop(context);
                        _controller.clear();
                      },
                    ),
                  ],
                );
              });
        });
        break; 
    }
  }

  
  Future<void> renameCategoryRecipeAfterEditCategory(
      categoryNameToReplace, newCategoryName) async {
    
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    
    
    for (int i = recipeList.length - 1; i >= 0; i--) {
      if (recipeList[i][7] == categoryNameToReplace) {
        recipeList[i][7] = newCategoryName;
      }
    }

    
    _myBox.put('ALL_LISTS', recipeList);
  }

  

  void _dialogDeleteAll(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsetsDirectional.fromSTEB(0, 125, 0, 90),
            child: AlertDialog(
              title: Column(
                children: [
                  Text(AppLocalizations.of(context)!.areYouSure),
                  Text(
                    AppLocalizations.of(context)!.confirmLongPress1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              content: Column(
                children: [
                  TextButton(
                    onLongPress: () async {
                      setState(() {
                        isEditDeleteMode = false;
                      });

                      await deleteAllRecipes();
                      Navigator.of(context).pop();
                    },
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.deleteAllRecipes,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onLongPress: () async {
                      setState(() {
                        isEditDeleteMode = false;
                      });

                      await deleteAllRecipesAndCategories();
                      Navigator.of(context).pop();
                    },
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.deleteAllRecipesAndCategories,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
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
              
            ),
          );
        });
  }

  Future<void> deleteAllRecipes() async {
    
    
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    
    
    recipeList = [];
    
    _myBox.put('ALL_LISTS', recipeList);
  }

  Future<void> deleteAllRecipesAndCategories() async {
    
    deleteAllRecipes();
    
    Hive.box<CategoriesNames>('catBox').clear();
  }

  
  Future<void> deleteCategoryAndTheirRecipes(categoryName, index) async {
    
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    
    

    for (int i = recipeList.length - 1; i >= 0; i--) {
      if (recipeList[i][7] == categoryName) {
        recipeList.removeAt(i);
      }
      _myBox.put('ALL_LISTS', recipeList);
    }
    
    Hive.box<CategoriesNames>('catBox').deleteAt(index);
  }

  void _dialogDeleteOneCategory(BuildContext context, categoryName, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
            child: AlertDialog(
              title: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.areYouSure,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocalizations.of(context)!.confirmLongPress1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              content: TextButton(
                onLongPress: () async {
                  setState(() {
                    isEditDeleteMode = false;
                  });
                  deleteCategoryAndTheirRecipes(categoryName, index);
                  Navigator.of(context).pop();
                },
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.actionAfterLongPress1,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
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
              
            ),
          );
        });
  }

  
  showDialogErrorMarmiteur() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              AppLocalizations.of(context)!.errorScrap,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  
  Future<void> scrapMarmiteur(String websiteURL, {bool autoFormat = true}) async {
    String recipeURL = websiteURL;

    try {
      marmiteurResult = await marmiteur(recipeURL);
      if (marmiteurResult['name'] == null) {
        showDialogErrorMarmiteur();
        return;
      }

      
      scrapRecipeName = marmiteurResult['name'];
      scrapStepsRecipe = marmiteurResult["recipeInstructions"].cast<String>();
      scrapIngredient = marmiteurResult["recipeIngredient"].cast<String>();
      scrapTotalTime = marmiteurResult["totalTime"];
      scrapTags = marmiteurResult["recipeCuisine"];

      scrapTotalTime = _removePrefixPT(scrapTotalTime);

      final scrapInstance = Scraping(
        scrapRecipeName: scrapRecipeName,
        scrapStepsRecipe: scrapStepsRecipe,
        scrapAllIngredient: scrapIngredient,
        scrapTotalTime: scrapTotalTime,
        scrapTags: scrapTags,
        urlImageScrap: marmiteurResult["image"][0],
        sourceUrlScrap: recipeURL,
      );

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => scrapInstance),
      );
    } catch (e) {
      rethrow;
    }
  }

  String _removePrefixPT(String time) {
    return time.startsWith("PT") ? time.substring(2) : time;
  }

  
  void filterList(String searchTerm) {
    setState(() {
      
      recipeListFilteredSearch = db.recipeList
          .where((recipe) =>
          recipe[0].toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  
  Future<void> _showDialog() async {
    showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 35.0,
              child: Text(
                AppLocalizations.of(context)!.quitAppConfirm,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.confirmExit,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          
                          _isConfirmBack = true;
                          
                          exit(0);
                        });
                      },
                    ),
                    SizedBox(
                        width: 8), 
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> _showAddFromWebDialog() async {
    final TextEditingController urlController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.addFromWeb,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'URL',
                filled: true,
                fillColor: AppColors.primaryLight.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.text,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isFloatingActionButtonPressed = false;
              });
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
            ),
            onPressed: () async {
              if (urlController.text.isNotEmpty) {
                String recipeURL = urlController.text;
                Navigator.pop(context);
                setState(() {
                  isFloatingActionButtonPressed = false;
                });
                await _handleWebRecipe(recipeURL);
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  Future<void> _handleWebRecipe(String recipeURL) async {
    try {
      setState(() {
        scrapInstanceCreated = true;
      });

      await scrapMarmiteur(recipeURL);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.errorScrapingRecipe,
            style: TextStyle(color: AppColors.background),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        scrapInstanceCreated = false;
      });
    }
  }

  
  void deleteRecipe(int index) {
    
    db.recipeList.removeAt(index);
    
    db.updateData();
    
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isConfirmBack) {
          return true;
        }
        setState(() {
          _isConfirmBack = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pressAgainToExit),
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isConfirmBack = false;
          });
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.appName,
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
          ],
        ),
        drawer: _buildDrawer(),
        body: RefreshIndicator(
          onRefresh: loadAllData, 
          child: Column(
            children: [
              if (isSearchPressed) _buildSearchBar(),
              Expanded(
                child: _buildRecipesList(),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.drawer,
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
              "android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: AppLocalizations.of(context)!.home,
            onTap: () {
              _searchController.clear();
              isSearchPressed = false;
              Navigator.popAndPushNamed(context, '/home');
            },
          ),
          _buildDrawerItem(
            icon: Icons.language_sharp,
            title: AppLocalizations.of(context)!.language,
            onTap: () {
              _searchController.clear();
              isSearchPressed = false;
              Navigator.popAndPushNamed(context, '/language');
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context)!.about,
            onTap: () {
              _searchController.clear();
              isSearchPressed = false;
              Navigator.popAndPushNamed(context, '/about');
            },
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
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
        onChanged: (value) => filterList(value),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (isFloatingActionButtonPressed) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildExtendedFloatingActionButton(
            label: AppLocalizations.of(context)!.addFromWeb,
            onPressed: () => _showAddFromWebDialog(),
          ),
          SizedBox(height: 16),
          _buildExtendedFloatingActionButton(
            label: AppLocalizations.of(context)!.create,
            onPressed: () {
              setState(() {
                isFloatingActionButtonPressed = false;
                _searchController.clear();
                isSearchPressed = false;
              });
              Navigator.pushNamed(context, '/create_recipe');
            },
          ),
          SizedBox(height: 16),
          _buildExtendedFloatingActionButton(
            label: AppLocalizations.of(context)!.categories,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesPage()),
              );
            },
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                isFloatingActionButtonPressed = false;
                _searchController.clear();
                isSearchPressed = false;
              });
            },
            child: Text(
              AppLocalizations.of(context)!.back,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "categories",
          backgroundColor: AppColors.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesPage()),
            );
          },
          label: Text(
            AppLocalizations.of(context)!.categories,
            style: TextStyle(color: AppColors.background),
          ),
        ),
        SizedBox(width: 16),
        FloatingActionButton.extended(
          heroTag: "add_recipe",
          backgroundColor: AppColors.accent,
          onPressed: () {
            setState(() {
              isFloatingActionButtonPressed = true;
              _searchController.clear();
              isSearchPressed = false;
            });
          },
          label: Text(
            AppLocalizations.of(context)!.addDelightfulRecipe,
            style: TextStyle(
              color: AppColors.background,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExtendedFloatingActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        label,
        style: TextStyle(
          color: AppColors.background,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRecipesList() {
    if (db.recipeList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context)!.noRecipes,
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
        childAspectRatio: 0.75,
      ),
      itemCount: recipeListFilteredSearch.length,
      itemBuilder: (context, index) {
        String imagePath = recipeListFilteredSearch[index][5] ?? "recipe_pics/no_image.png";

        return GestureDetector(
          onLongPress: () {
            
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(AppLocalizations.of(context)!.editRecipe),
                        onTap: () {
                          
                          Navigator.pop(context); 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRecipe(
                                editAllIngredient:
                                recipeListFilteredSearch[index][4],
                                editPathImage: recipeListFilteredSearch[index][5],
                                editStepsRecipe: recipeListFilteredSearch[index]
                                [6]
                                    .cast<String>(),
                                editRecipeCategory:
                                recipeListFilteredSearch[index][7],
                                editRecipeName: recipeListFilteredSearch[index][0],
                                editTotalTime: recipeListFilteredSearch[index][1],
                                editDifficulty: recipeListFilteredSearch[index][2],
                                editCost: recipeListFilteredSearch[index][3],
                                isFromScrap: recipeListFilteredSearch[index][8],
                                tags: recipeListFilteredSearch[index][10],
                                uniqueId: recipeListFilteredSearch[index][9],
                                editUrlImageScrap:
                                recipeListFilteredSearch[index][14],
                              ),
                            ),
                          ).then((_) {
                            
                            loadAllData();
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text(
                          AppLocalizations.of(context)!.deleteRecipe,
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          
                          Navigator.pop(context); 
                          deleteRecipe(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                RecipeStruct recipeInstance = RecipeStruct(
                  recipeName: recipeListFilteredSearch[index][0],
                  totalTime: recipeListFilteredSearch[index][1],
                  difficulty: recipeListFilteredSearch[index][2],
                  cost: recipeListFilteredSearch[index][3],
                  allIngredientSelected: recipeListFilteredSearch[index][4],
                  pathImageSelectedFromImagePicker:
                  recipeListFilteredSearch[index][5],
                  stepsRecipeFromCreateSteps: recipeListFilteredSearch[index][6]
                      .cast<String>(),
                  isFromScrap: recipeListFilteredSearch[index][8],
                  tags: recipeListFilteredSearch[index][10],
                  uniqueId: recipeListFilteredSearch[index][9],
                  recipeCategory: recipeListFilteredSearch[index][7],
                  isFromFilteredNameRecipe: false,
                  urlImageScrap: recipeListFilteredSearch[index][14],
                  sourceUrlScrap: recipeListFilteredSearch[index][15],
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => recipeInstance,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                      child: imagePath.startsWith("http")
                          ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipeListFilteredSearch[index][0],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer, size: 16),
                                  SizedBox(width: 4),
                                  Text(recipeListFilteredSearch[index][1]),
                                ],
                              ),
                              Text(recipeListFilteredSearch[index][3]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}