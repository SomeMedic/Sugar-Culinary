



import 'dart:io';
import 'dart:math';

import 'package:sugarCulinary/pages/home.dart';
import 'package:sugarCulinary/pages/edit_recipe.dart';
import 'package:sugarCulinary/utils/steps_struct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sugarCulinary/data/recipe_database/database.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class AppColors {
  static const Color primary = Color(0xFF2196F3);      
  static const Color secondary = Color(0xFF03A9F4);    
  static const Color accent = Color(0xFFFF9800);       
  static const Color background = Color(0xFFFFFFFF);   
  static const Color text = Color(0xFF000000);         
  
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color secondaryLight = Color(0xFFB3E5FC);
  static const Color accentLight = Color(0xFFFFE0B2);
  static const Color cardBackground = Color(0xFFF7F2FF);
}

class RecipeStruct extends StatefulWidget {
  final String recipeName;
  final String totalTime;
  final String difficulty;
  final String cost;
  final List allIngredientSelected;
  final String? pathImageSelectedFromImagePicker;
  final List<String> stepsRecipeFromCreateSteps;
  final bool isFromScrap;
  List?
      tags; 
  String uniqueId;
  String recipeCategory;
  bool isFromFilteredNameRecipe;
  final String? urlImageScrap;
  final String? sourceUrlScrap;

  RecipeStruct({
    super.key,
    required this.recipeName,
    required this.totalTime,
    required this.difficulty,
    required this.cost,
    required this.allIngredientSelected,
    required this.pathImageSelectedFromImagePicker,
    required this.stepsRecipeFromCreateSteps,
    required this.isFromScrap,
    this.tags,
    required this.uniqueId,
    required this.recipeCategory,
    required this.isFromFilteredNameRecipe,
    this.urlImageScrap,
    this.sourceUrlScrap,
  });

  @override
  State<RecipeStruct> createState() => _RecipeStructState();
}

class _RecipeStructState extends State<RecipeStruct> {
  bool isShowIngredientPressed = false;
  late List<bool> _isChecked;
  String defautImage = "recipe_pics/no_image.png";
  List allTags = [];
  final ScrollController _scrollController = ScrollController();

  
  final _myBox = Hive.box('mybox');
  
  RecipeDatabase db = RecipeDatabase();

  late final String finalEditRecipeName;

  @override
  void initState() {
    super.initState();
    
    _isChecked = List<bool>.filled(widget.allIngredientSelected.length, false);

    
    if (widget.tags != null) {
      allTags.addAll(widget.tags!);
    }
  }

  
  _imageToDisplay() {
    if (widget.urlImageScrap != null) {
      return Image.network(
        widget.urlImageScrap!,
      );
    } else if (widget.pathImageSelectedFromImagePicker != null) {
      return Image.file(
        File(widget.pathImageSelectedFromImagePicker!),
      );
    } else if (widget.urlImageScrap == null &&
        widget.pathImageSelectedFromImagePicker == null) {
      return Image.asset(
        defautImage,
      );
    }
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
    await Navigator.push(
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
  }

  
  void deleteOneRecipe() {
    List recipeList = _myBox.get('ALL_LISTS') ?? [];
    for (int i = 0; i < recipeList.length; i++) {
      if (recipeList[i][9] == widget.uniqueId) {
        recipeList.removeAt(i);
      }
    }
    _myBox.put('ALL_LISTS', recipeList);
  }

  void _dialogDelete(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
              child: AlertDialog(
                title: Column(children: [
                  Text("Are you sure?"),
                  Text("Confirm the desired option with a long press",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic))
                ]),
                content: TextButton(
                  onLongPress: () {
                    setState(() {
                      deleteOneRecipe();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    });
                  },
                  onPressed: () {},
                  child: Text("Yes, I want to delete this recipe",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red)),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Back"),
                  ),
                ],
              ));
        });
  }

  
  _launchURL(url) async {
    Uri _url = Uri.parse(url);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  
  void _dialogUrlScrap(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 200, 0, 100),
              child: AlertDialog(
                content: TextButton(
                  onPressed: () {
                    _launchURL(widget.sourceUrlScrap);
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.sourceUrlScrap!,
                    textAlign: TextAlign.center,
                  ),
                ),

                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Back"),
                  ),
                ],
                
              ));
        });
  }

  
  void handleClick(int item) {
    switch (item) {
      case 0: 
        setState(() {
          sendDataToEditAtEditRecipe(
              context,
              widget.allIngredientSelected,
              widget.stepsRecipeFromCreateSteps,
              widget.recipeCategory,
              widget.recipeName,
              widget.totalTime,
              widget.difficulty,
              widget.cost,
              widget.isFromScrap,
              widget.pathImageSelectedFromImagePicker,
              widget.tags,
              widget.uniqueId,
              widget.urlImageScrap);
        });

      case 1: 
        setState(() {
          _dialogDelete(context);
        });

      case 2: 
        setState(() {
          _dialogUrlScrap(context);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          widget.recipeName,
          style: TextStyle(
            color: AppColors.background,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.sourceUrlScrap != null)
            IconButton(
              icon: Icon(Icons.link, color: AppColors.background),
              onPressed: () => launchUrl(Uri.parse(widget.sourceUrlScrap!)),
            ),
        ],
      ),
      body: Column(
        children: [
          if (isShowIngredientPressed) ...[
            _buildIngredientsList(),
          ] else ...[
            _buildRecipeDetails(),
          ],
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Expanded(
      child: Column(
        children: [
          _buildCollapseButton(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _buildIngredientsListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapseButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isShowIngredientPressed = !isShowIngredientPressed;
        });
      },
      child: Row(
        children: [
          Text(
            isShowIngredientPressed
                ? "Collapse"
                : "Show Ingredients",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Icon(
            isShowIngredientPressed
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.allIngredientSelected.length,
      itemBuilder: (context, index) {
        final ingredient =
            widget.allIngredientSelected[index][0];
        final quantity =
            widget.allIngredientSelected[index][1];
        final unit = widget.allIngredientSelected[index][2];

        final formattedString =
            '$ingredient : ($quantity$unit)';
        return widget.isFromScrap
            ? ListTile(
                title:
                    Text(widget.allIngredientSelected[index]),
                trailing: Checkbox(
                  value: _isChecked[index],
                  onChanged: (bool? value) {
                    if (_isChecked[index] == false) {
                      return setState(() {
                        _isChecked[index] = true;
                      });
                    } else {
                      return setState(() {
                        _isChecked[index] = false;
                      });
                    }
                  },
                ),
              )
            : ListTile(
                title: Text(formattedString),
                trailing: Checkbox(
                  value: _isChecked[index],
                  onChanged: (bool? value) {
                    if (_isChecked[index] == false) {
                      return setState(() {
                        _isChecked[index] = true;
                      });
                    } else {
                      return setState(() {
                        _isChecked[index] = false;
                      });
                    }
                  },
                ),
              );
      },
    );
  }

  Widget _buildRecipeDetails() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              

              
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.35,
                  maxWidth:
                      MediaQuery.of(context).size.width * 0.95,
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: _imageToDisplay(),
                  ),
                ),
              ),

              
              SizedBox(height: 16),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Row(children: [
                    if (widget.totalTime != "")
                      Icon(Icons.access_time),
                    Text(
                      (' ${widget.totalTime}  '),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                  
                  if (widget.difficulty != "")
                    Row(children: [
                      Icon(Icons.cookie_outlined),
                      Text(
                        (' ${widget.difficulty}  '),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
                  
                  if (widget.cost != "")
                    Row(children: [
                      Icon(Icons.monetization_on_outlined),
                      Text(
                        (' ${widget.cost}  '),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                ],
              ),
              SizedBox(height: 16),
              
              if (widget.tags != null) ...[
                Container(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  height: 70,
                  child: Wrap(
                    spacing: 1.0,
                    alignment: WrapAlignment.center,
                    runSpacing:
                        1.0, 
                    children: List.generate(
                      widget.tags!.length,
                      (index) => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(widget.tags![index],
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                )
              ],

              if (widget.tags == null) ...[
                Text("")
              ], 

              SizedBox(height: 30),
              
              TextButton(
                onPressed: () {
                  setState(() {
                    isShowIngredientPressed = true;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Show Ingredients",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.arrow_upward,
                      size:
                          16, 
                    ),
                  ],
                )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowRecipeSteps(
                      steps: widget.stepsRecipeFromCreateSteps,
                    ),
                  ),
                );
              },
              label: Text("Start to cook!"),
            ),
          ),
        ),
      ],
    );
  }
}
