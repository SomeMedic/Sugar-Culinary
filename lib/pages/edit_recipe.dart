



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


class EditRecipe extends StatefulWidget {
  List editAllIngredient;
  String? editPathImage;
  List<String> editStepsRecipe;
  String editRecipeCategory;
  String editRecipeName;
  String editTotalTime;
  String editDifficulty;
  String editCost;
  bool isFromScrap;
  List? tags;
  String uniqueId;
  String? editUrlImageScrap;

  EditRecipe(
      {super.key,
        required this.editAllIngredient,
        this.editPathImage,
        required this.editStepsRecipe,
        required this.editRecipeCategory,
        required this.editRecipeName,
        required this.editTotalTime,
        required this.editDifficulty,
        required this.editCost,
        required this.isFromScrap,
        this.tags,
        required this.uniqueId,
        this.editUrlImageScrap});

  @override
  
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  

  
  final _myBox = Hive.box('mybox');
  
  RecipeDatabase db = RecipeDatabase();

  String previewImageTextField = "";

  bool isShowIngredientsSelectedPressed = false;
  bool isshowStepsAddedPressed = false;
  bool isshowTagsAddedPressed = false;
  bool _isConfirmBack = false;

  String defautImage = "recipe_pics/no_image.png";

  
  getIndex() {
    loadAllData();
    for (int i = 0; i < db.recipeList.length; i++) {
      if (db.recipeList[i][9] == widget.uniqueId) {
        return i;
      }
    }
  }


  loadAllData() {
    setState(() {
      db.loadData();
    });
  }

  

  
  void _getDataFromAddExistingCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExistingCategory(),
      ),
    );

    if (result != null) {
      String categoryName = result;

      setState(() {
        
      });
      widget.editRecipeCategory = categoryName;
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          widget.editRecipeCategory,
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
      ]),
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
        
      });
      widget.editRecipeName = recipeName;
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
          
            width: 200,
            child: Text(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              widget.editRecipeName,
              style:
              widget.editRecipeName == "Deleted"
                  ? TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                  : TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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
                        TextEditingController(text: widget.editRecipeName),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddRecipeName(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editRecipeName = data;
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
                  widget.editRecipeName = "Deleted";
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
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
        
      });
      widget.editTotalTime = totalTime;
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
        Text(widget.editTotalTime,
            style: widget.editTotalTime == "Deleted"
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
                        TextEditingController(text: widget.editTotalTime),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddTotalTime(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editTotalTime = data;
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
                  widget.editTotalTime = "Deleted";
                  Text(
                    widget.editTotalTime,
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
        
      });
      widget.editDifficulty = difficulty;
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
        Text(widget.editDifficulty,
            style:
            widget.editDifficulty == "Deleted"
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
                        TextEditingController(text: widget.editDifficulty),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddDifficulty(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editDifficulty = data;
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
                  widget.editDifficulty = "Deleted";
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
        
      });
      widget.editCost = cost;
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
        Text(widget.editCost,
            style: widget.editCost == "Deleted"
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
                        TextEditingController(text: widget.editCost),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddCost(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.editCost = data;
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
                  widget.editCost = "Deleted";
                });
              },
              child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  
  
  
  
  

  
  _imageToDisplay() {
    if (widget.editUrlImageScrap != null) {
      return Image.network(
        widget.editUrlImageScrap!,
        width: 200,
        height: 200,
      );
    } else if (widget.editPathImage != null) {
      return Image.file(
        File(widget.editPathImage!),
        width: 200,
        height: 200,
      );
    } else if (widget.editUrlImageScrap == null &&
        widget.editPathImage == null) {
      return Image.asset(
        defautImage,
        width: 200,
        height: 200,
      );
    }
  }

  
  void _showImagePreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: _imageToDisplay(),
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
      setState(() {});

      widget.editPathImage = imageSelected;
      widget.editUrlImageScrap = null;
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
              previewImageTextField =
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
                  widget.editPathImage = null;
                  widget.editUrlImageScrap = null;
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
                        widget.editAllIngredient[index][0] = editName.text;
                        widget.editAllIngredient[index][1] = editQuantity.text;
                        widget.editAllIngredient[index][2] = editUnit.text;
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
      setState(() {});
      widget.editAllIngredient.addAll(allIngredientSelected);
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
              isShowIngredientsSelectedPressed = !isShowIngredientsSelectedPressed;
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
                onTap: widget.isFromScrap
                    ? () async {
                  final result = await showDialog(
                      context: context,
                      builder: (context) {
                        return DialogEditStep(
                          controller: TextEditingController(text: ""),
                        );
                      });
                  if (result != null) {
                    String addedIngredScrap = result;
                    setState(() {});
                    widget.editAllIngredient.add(addedIngredScrap);
                  }
                }
                    : () {
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
                    widget.editAllIngredient = [];
                  });
                },
                child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
              ),
            ],
          ),
        ),
        if (isShowIngredientsSelectedPressed) showIngredientsSelected(),
      ],
    );
  }

  
  Widget showIngredientsSelected() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 242, 255, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 400,
        child: ListView.builder(
          itemCount: widget.editAllIngredient.length,
          itemBuilder: (context, index) {
            final ingredient = widget.editAllIngredient[index][0];
            final quantity = widget.editAllIngredient[index][1];
            final unit = widget.editAllIngredient[index][2];

            final formattedString = '$ingredient : ($quantity$unit)';
            return ListTile(
              title: widget.isFromScrap
                  ? Text(widget.editAllIngredient[index])
                  : Text(formattedString),
              trailing: Wrap(
                spacing: -16,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.isFromScrap
                        ? () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) {
                            return DialogEditStep(
                                controller: TextEditingController(
                                  text: widget.editAllIngredient[index]
                                      .toString(),
                                ));
                          });
                      if (result != null) {
                        String addedIngredScrap = result;
                        setState(() {});
                        widget.editAllIngredient[index] =
                            addedIngredScrap;
                      }
                    }
                        : () {
                      editIngred(
                          TextEditingController(
                              text: widget.editAllIngredient[index][0]),
                          TextEditingController(
                              text: widget.editAllIngredient[index][1]),
                          TextEditingController(
                              text: widget.editAllIngredient[index][2]),
                          index);
                    },
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        widget.editAllIngredient.removeAt(index);
                      });
                    },
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {},
                    ),
                  )
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
      setState(() {});
      widget.editStepsRecipe.addAll(stepsRecipe);
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
                    widget.editStepsRecipe = [];
                  });
                },
                child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
              ),
            ],
          ),
        ),
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
        itemCount: widget.editStepsRecipe.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                ' ${"Step"} ${index + 1}:\n${widget.editStepsRecipe[index]}'),
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
                                text: widget.editStepsRecipe[index].toString()),
                          );
                        });
                    if (result != null) {
                      String stepEdited = result;
                      setState(() {});
                      widget.editStepsRecipe[index] = stepEdited;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.editStepsRecipe.removeAt(index);
                    });
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                )
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
      setState(() {});
      widget.tags!.addAll(data);
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
                    widget.tags!.clear();
                  });
                },
                child: Icon(Icons.delete, size: 20, color: Colors.redAccent),
              ),
            ],
          ),
        ),
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
        itemCount: widget.tags!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${widget.tags![index]}'),
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
                                text: widget.tags![index].toString()),
                          );
                        });
                    if (result != null) {
                      String data = result;
                      setState(() {});
                      widget.tags![index] = data;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.tags!.removeAt(index);
                    });
                  },
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                )
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
        title: Text(
        "Edit recipe",
    style: TextStyle(
    color: AppColors.background,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    ),
    ),
    centerTitle: true,
    ),
    body: Padding     (
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16),
          child,
        ],
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
          "Save changes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    
    final finalEditRecipeName = widget.editRecipeName ==
        "Deleted"
        ? "No title"
        : widget.editRecipeName;

    final finalEditTotalTime = widget.editTotalTime ==
        "Deleted"
        ? ""
        : widget.editTotalTime;

    final finalEditDifficulty = widget.editDifficulty ==
        "Deleted"
        ? ""
        : widget.editDifficulty;

    final finalEditCost =
    widget.editCost == "Deleted"
        ? ""
        : widget.editCost;

    
    List recipeList = _myBox.get('ALL_LISTS') ?? [];

    

    
    recipeList[getIndex()][0] = finalEditRecipeName;
    recipeList[getIndex()][1] = finalEditTotalTime;
    recipeList[getIndex()][2] = finalEditDifficulty;
    recipeList[getIndex()][3] = finalEditCost;
    recipeList[getIndex()][4] = widget.editAllIngredient;
    recipeList[getIndex()][5] = widget.editPathImage;
    recipeList[getIndex()][6] = widget.editStepsRecipe;
    recipeList[getIndex()][7] = widget.editRecipeCategory;
    recipeList[getIndex()][14] = widget.editUrlImageScrap;

    
    _myBox.put("ALL_LISTS", recipeList);

    
    RecipeStruct recipeDetailsPage = RecipeStruct(
        recipeName: finalEditRecipeName,
        totalTime: finalEditTotalTime,
        difficulty: finalEditDifficulty,
        cost: finalEditCost,
        allIngredientSelected: widget.editAllIngredient,
        pathImageSelectedFromImagePicker: widget.editPathImage,
        stepsRecipeFromCreateSteps: widget.editStepsRecipe,
        isFromScrap: recipeList[getIndex()][8],
        tags: recipeList[getIndex()][10],
        uniqueId: recipeList[getIndex()][9],
        recipeCategory: recipeList[getIndex()][7],
        isFromFilteredNameRecipe: false,
        urlImageScrap: recipeList[getIndex()][14],
        sourceUrlScrap: recipeList[getIndex()][15]);

    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => recipeDetailsPage),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.primary.withOpacity(0.2),
    );
  }
}

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