



import 'dart:io';

import 'package:sugarCulinary/data/recipe_database/database.dart';
import 'package:sugarCulinary/pages/add_category.dart';
import 'package:sugarCulinary/pages/add_cost.dart';
import 'package:sugarCulinary/pages/add_difficulty.dart';
import 'package:sugarCulinary/pages/add_ingredients.dart';
import 'package:sugarCulinary/pages/add_pics.dart';
import 'package:sugarCulinary/pages/add_recipename.dart';
import 'package:sugarCulinary/pages/add_tags.dart';
import 'package:sugarCulinary/pages/add_totaltime.dart';
import 'package:sugarCulinary/pages/create_steps.dart';
import 'package:sugarCulinary/utils/dialbox_edit.dart';


import 'package:flutter/material.dart';
import 'package:sugarCulinary/pages/recipe_struct.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  

  
  final _myBox = Hive.box('mybox');
  
  RecipeDatabase db = RecipeDatabase();

  List allIngredientSelectedCreateRecipe = [];
  String? pathImageSelectedFromImagePicker;
  List<String> stepsRecipeFromCreateSteps = [];
  late String recipeCategoryFromAddExistingCategory;
  String recipeNameFromAddRecipeName = "No title";
  String totalTimeFromAddTotalTime = "";
  String varFromAddDifficulty = "";
  String varFromAddCost = "";
  String previewImageTextField = "";
  String defautImage = "recipe_pics/no_image.png";
  List? tags = [];

  bool isButtonAddCategoryVisible = true;
  bool isButtonAddRecipeNameVisible = true;
  bool isButtonAddTotalTimeVisible = true;
  bool isButtonAddDifficultyVisible = true;
  bool isButtonAddCostVisible = true;
  bool isButtonAddPictureVisible = true;
  bool isButtonAddIngredVisible = true;
  bool isButtonAddStepsVisible = true;
  bool isFromScrap = false;
  bool isShowIngredientsSelectedPressed = false;
  bool isshowStepsAddedPressed = false;
  bool isButtonAddTagsVisible = true;
  bool isshowTagsAddedPressed = false;
  bool isFromEditRecipeStruct = false;
  bool _isConfirmBack = false;

  
  void showDialogCategoryEmpty() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Category is required.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              ElevatedButton(
                child: Text("Back"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  

  
  _getDataFromAddExistingCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExistingCategory(),
      ),
    );

    if (result != null) {
      String categoryName = result;

      setState(() {
        
        isButtonAddCategoryVisible = false;
      });
      recipeCategoryFromAddExistingCategory = categoryName;
    }
  }

  
  Widget addCategory() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Category",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isButtonAddCategoryVisible
                ? "No category selected"
                : recipeCategoryFromAddExistingCategory,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {
              _getDataFromAddExistingCategory(context);
            },
            child: Icon(
              Icons.create,
              size: 30,
            ),
          ),
        ],
      ),
    ]);
  }

  

  

  
  void _getDataFromAddRecipeName(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipeName(),
      ),
    );

    if (result != null) {
      String recipeName = result;

      setState(() {
        
        isButtonAddRecipeNameVisible = false;
      });
      recipeNameFromAddRecipeName = recipeName;
    }
  }

  
  Widget addRecipeName() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Recipe name",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            
              width: 200,
              child: Text(
                  isButtonAddRecipeNameVisible
                      ? "No title"
                      : recipeNameFromAddRecipeName,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: recipeNameFromAddRecipeName ==
                      "Deleted"
                      ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                      : TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return DialogEditRecipeField(
                          controller:
                          TextEditingController(text: recipeNameFromAddRecipeName),
                          isFromScrap: false,
                          showSuggestion: () {
                            _getDataFromAddRecipeName(context);
                          },
                        );
                      });
                  if (result != null) {
                    String data = result;
                    setState(() {});
                    recipeNameFromAddRecipeName = data;
                  }
                },
                child: Icon(
                  Icons.create,
                  size: 30,
                ),
              ),
              SizedBox(width: 16), 
              InkWell(
                onLongPress: () {
                  setState(() {
                    recipeNameFromAddRecipeName =
                        "Deleted";
                  });
                },
                child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    ]);
  }

  
  
  
  

  
  void _getDataFromAddTotalTime(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTotalTime(),
      ),
    );

    if (result != null) {
      String totalTime = result;

      setState(() {
        
        isButtonAddTotalTimeVisible = false;
      });
      totalTimeFromAddTotalTime = totalTime;
    }
  }

  
  Widget addTotalTime() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Total time",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
            isButtonAddTotalTimeVisible
                ? "No time selected"
                : totalTimeFromAddTotalTime,
            style: totalTimeFromAddTotalTime ==
                "Deleted"
                ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditRecipeField(
                        controller:
                        TextEditingController(text: totalTimeFromAddTotalTime),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddTotalTime(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  totalTimeFromAddTotalTime = data;
                }
              },
              child: Icon(
                Icons.create,
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            InkWell(
              onLongPress: () {
                setState(() {
                  totalTimeFromAddTotalTime =
                      "Deleted";
                  Text(
                    totalTimeFromAddTotalTime,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  
  

  
  void _getDataFromAddDifficulty(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDifficulty(),
      ),
    );

    if (result != null) {
      String difficulty = result;

      setState(() {
        
        isButtonAddDifficultyVisible = false;
      });
      varFromAddDifficulty = difficulty;
    }
  }

  
  Widget addDifficulty() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Difficulty",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
            isButtonAddDifficultyVisible
                ? "No difficulty selected"
                : varFromAddDifficulty,
            style: varFromAddDifficulty ==
                "Deleted"
                ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditRecipeField(
                        controller:
                        TextEditingController(text: varFromAddDifficulty),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddDifficulty(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  varFromAddDifficulty = data;
                }
              },
              child: Icon(
                Icons.create,
                size: 30,
              ),
            ),
            SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  varFromAddDifficulty =
                      "Deleted";
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  

  
  void _getDataFromAddCost(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCost(),
      ),
    );

    if (result != null) {
      String cost = result;

      setState(() {
        
        isButtonAddCostVisible = false;
      });
      varFromAddCost = cost;
    }
  }

  
  Widget addCost() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Cost",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
            isButtonAddCostVisible
                ? "No cost selected"
                : varFromAddCost,
            style: varFromAddCost == "Deleted"
                ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                : TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditRecipeField(
                        controller: TextEditingController(text: varFromAddCost),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddCost(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  varFromAddCost = data;
                }
              },
              child: Icon(
                Icons.create,
                size: 30,
              ),
            ),
            SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  varFromAddCost = "Deleted";
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  
  
  
  

  
  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: pathImageSelectedFromImagePicker != null
                ? Image.file(
              File(pathImageSelectedFromImagePicker!),
              width: 200,
              height: 200,
            )
                : Image.asset(
              defautImage,
              width: 200,
              height: 200,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        });
  }

  
  void getDataFromMyImagePickerPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyImagePickerPage(),
      ),
    );

    if (result != null) {
      String imageSelected = result;
      setState(() {
        isButtonAddPictureVisible = false;
      });
      pathImageSelectedFromImagePicker = imageSelected;
    }
  }

  
  Widget addPicture() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Picture : ",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
            onTap: () {
              _showImagePreview(context);
            },
            child: Text(
              isButtonAddPictureVisible
                  ? "No picture selected"
                  : previewImageTextField =
                  "Preview picture",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                getDataFromMyImagePickerPage(context);
              },
              child: Icon(
                Icons.create,
                size: 30,
              ),
            ),
            SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  pathImageSelectedFromImagePicker = null;
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  

  
  
  
  

  
  editIngred(editName, editQuantity, editUnit, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(10.0),
              content: Container(
                  height: 300,
                  child: Column(children: [
                    TextField(
                        controller: editName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Ingredient name",
                        )),
                    TextField(
                        controller: editQuantity,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Quantity",
                        )),
                    TextField(
                        controller: editUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Unit",
                        ))
                  ])),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text("Add"),
                      onPressed: () async {
                        allIngredientSelectedCreateRecipe[index][0] =
                            editName.text;
                        allIngredientSelectedCreateRecipe[index][1] =
                            editQuantity.text;
                        allIngredientSelectedCreateRecipe[index][2] =
                            editUnit.text;
                        Navigator.pop(context);

                        editName.clear();
                        editQuantity.clear();
                        editUnit.clear();
                        setState(() {});
                      },
                    )
                  ],
                )
              ]);
        });
  }

  
  void getDataFromAddIngred(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIngred(),
      ),
    );

    if (result != null) {
      List allIngredientSelected = result;
      setState(() {
        isButtonAddIngredVisible = false;
      });
      allIngredientSelectedCreateRecipe.addAll(allIngredientSelected);
    }
  }

  
  Widget addIngred() {
    setState(() {});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                isShowIngredientsSelectedPressed =
                !isShowIngredientsSelectedPressed;
              });
            },
            child: Row(
              children: [
                Text(
                  isShowIngredientsSelectedPressed
                      ? "Collapse"
                      : "Show Ingredients",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Icon(
                  isShowIngredientsSelectedPressed
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 16, 
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    getDataFromAddIngred(context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16), 
                InkWell(
                  onLongPress: () {
                    setState(() {
                      allIngredientSelectedCreateRecipe = [];
                    });
                  },
                  child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
                ),
              ],
            )),
        if (isShowIngredientsSelectedPressed) showIngredientsSelected(),
      ],
    );
  }

  
  Widget showIngredientsSelected() {
    setState(() {});
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 242, 255, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 400,
        child: ListView.builder(
          itemCount: allIngredientSelectedCreateRecipe.length,
          itemBuilder: (context, index) {
            final ingredient = allIngredientSelectedCreateRecipe[index][0];
            final quantity = allIngredientSelectedCreateRecipe[index][1];
            final unit = allIngredientSelectedCreateRecipe[index][2];

            final formattedString = '$ingredient : ($quantity$unit)';
            return ListTile(
              title: Text(formattedString),
              trailing: Wrap(
                spacing: -16,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      editIngred(
                          TextEditingController(
                              text: allIngredientSelectedCreateRecipe[index]
                              [0]),
                          TextEditingController(
                              text: allIngredientSelectedCreateRecipe[index]
                              [1]),
                          TextEditingController(
                              text: allIngredientSelectedCreateRecipe[index]
                              [2]),
                          index);
                    },
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        allIngredientSelectedCreateRecipe.removeAt(index);
                      });
                    },
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
  
  

  
  
  
  

  
  void getDataFromCreateSteps(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSteps(),
      ),
    );

    if (result != null) {
      List<String> stepsRecipe = result;
      setState(() {
        isButtonAddStepsVisible = false;
      });
      stepsRecipeFromCreateSteps.addAll(stepsRecipe);
    }
  }

  
  Widget addSteps() {
    setState(() {});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                isshowStepsAddedPressed = !isshowStepsAddedPressed;
              });
            },
            child: Row(
              children: [
                Text(
                  isshowStepsAddedPressed
                      ? "Collapse"
                      : "Show steps",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Icon(
                  isshowStepsAddedPressed
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 16, 
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    getDataFromCreateSteps(context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16), 
                InkWell(
                  onLongPress: () {
                    setState(() {
                      stepsRecipeFromCreateSteps = [];
                    });
                  },
                  child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
                ),
              ],
            )),
        if (isshowStepsAddedPressed) showStepsAdded(),
      ],
    );
  }

  
  Widget showStepsAdded() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 400,
      child: ListView.builder(
        itemCount: stepsRecipeFromCreateSteps.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '  ${"Step"} ${index + 1}:\n${stepsRecipeFromCreateSteps[index]}'),
            trailing: Wrap(
              spacing: -16,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return DialogEditStep(
                            controller: TextEditingController(
                                text: stepsRecipeFromCreateSteps[index]
                                    .toString()),
                          );
                        });
                    if (result != null) {
                      String stepEdited = result;
                      setState(() {});
                      stepsRecipeFromCreateSteps[index] = stepEdited;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      stepsRecipeFromCreateSteps.removeAt(index);
                    });
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  
  
  
  

  
  void getDataFromAddTags(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTags(),
      ),
    );

    if (result != null) {
      List data = result;
      setState(() {
        isButtonAddTagsVisible = false;
      });
      tags!.addAll(data);
    }
  }

  
  Widget addTags() {
    setState(() {});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                isshowTagsAddedPressed = !isshowTagsAddedPressed;
              });
            },
            child: Row(
              children: [

                Icon(
                  isshowTagsAddedPressed
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 16, 
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    getDataFromAddTags(context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16), 
                InkWell(
                  onLongPress: () {
                    setState(() {
                      tags!.clear();
                    });
                  },
                  child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
                ),
              ],
            )),
        if (isshowTagsAddedPressed) showTagsAdded(),
      ],
    );
  }

  
  Widget showTagsAdded() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 400,
      child: ListView.builder(
        itemCount: tags!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${tags![index]}'),
            trailing: Wrap(
              spacing: -16,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return DialogEditStep(
                            controller: TextEditingController(
                                text: tags![index].toString()),
                          );
                        });
                    if (result != null) {
                      String data = result;
                      setState(() {});
                      tags![index] = data;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      tags!.removeAt(index);
                    });
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  
  

  
  Future<void> _showDialog() async {
    showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
                height: 200.0,
                child: Column(children: [
                  Text("Are you sure you want to exit?",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Center(
                      child: Text("You can save changes and edit later",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)))
                ])),
            actions: <Widget>[
              TextButton(
                child: Text("Yes, exit",
                    style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    
                    _isConfirmBack = true;
                    
                    Navigator.of(context).pop(_isConfirmBack);
                    
                    Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text("No",
                    style: TextStyle(color: Colors.lightGreen)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(         "Create a recipe",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
          centerTitle: true,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WillPopScope(
          onWillPop: () async {
            if (_isConfirmBack) {
              return true;
            } else {
              _showDialog();
              return false;
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: "Category",
                  child: addCategory(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Recipe name",
                  child: addRecipeName(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Total time",
                  child: addTotalTime(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Difficulty",
                  child: addDifficulty(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Cost",
                  child: addCost(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Picture : ",
                  child: addPicture(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Ingredients",
                  child: addIngred(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Steps",
                  child: addSteps(),
                ),
                _buildDivider(),
                _buildSection(
                  title: "Tags",
                  child: addTags(),
                ),
                _buildDivider(),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: AppColors.text.withOpacity(0.1),
        thickness: 1,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _submitForm,
        child: Text(
          "Add",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    
    final finalRecipeNameFromAddRecipeName = recipeNameFromAddRecipeName ==
        "Deleted"
        ? "No title"
        : recipeNameFromAddRecipeName;

    final finalTotalTimeFromAddTotalTime = totalTimeFromAddTotalTime ==
        "Deleted"
        ? ""
        : totalTimeFromAddTotalTime;

    final finalVarFromAddDifficulty = varFromAddDifficulty ==
        "Deleted"
        ? ""
        : varFromAddDifficulty;

    final finalVarFromAddCost = varFromAddCost ==
        "Deleted"
        ? ""
        : varFromAddCost;

    
    DateTime now = DateTime.now();
    String creationDate =
        'variable_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

    
    List listOfLists = _myBox.get('ALL_LISTS') ?? [];

    
    double? stars;
    List? detailTIme;
    List? utensils;

    
    try {
      listOfLists.add([
        finalRecipeNameFromAddRecipeName,
        finalTotalTimeFromAddTotalTime,
        finalVarFromAddDifficulty,
        finalVarFromAddCost,
        allIngredientSelectedCreateRecipe,
        pathImageSelectedFromImagePicker,
        stepsRecipeFromCreateSteps,
        recipeCategoryFromAddExistingCategory,
        isFromScrap,
        creationDate,
        tags,
        stars,
        detailTIme,
        utensils,
        null, 
        null, 
      ]);
    } catch (e) {
      return showDialogCategoryEmpty();
    }

    
    _myBox.put('ALL_LISTS', listOfLists);

    

    
    RecipeStruct recipeDetailsPage = RecipeStruct(
      recipeName: finalRecipeNameFromAddRecipeName,
      totalTime: finalTotalTimeFromAddTotalTime,
      difficulty: finalVarFromAddDifficulty,
      cost: finalVarFromAddCost,
      allIngredientSelected: allIngredientSelectedCreateRecipe,
      pathImageSelectedFromImagePicker: pathImageSelectedFromImagePicker,
      stepsRecipeFromCreateSteps: stepsRecipeFromCreateSteps,
      isFromScrap: isFromScrap,
      tags: tags,
      uniqueId: creationDate,
      recipeCategory: recipeCategoryFromAddExistingCategory,
      isFromFilteredNameRecipe: false,
      sourceUrlScrap: null,
    );

    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => recipeDetailsPage),
    );
  }
}