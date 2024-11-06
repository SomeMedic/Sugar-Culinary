



import 'dart:io';

import 'package:sugarCulinary/data/recipe_database/database.dart';
import 'package:sugarCulinary/pages/add_category.dart';
import 'package:sugarCulinary/pages/add_cost.dart';
import 'package:sugarCulinary/pages/add_difficulty.dart';
import 'package:sugarCulinary/pages/add_pics.dart';
import 'package:sugarCulinary/pages/add_recipename.dart';
import 'package:sugarCulinary/pages/add_tags.dart';
import 'package:sugarCulinary/pages/add_totaltime.dart';
import 'package:sugarCulinary/pages/create_steps.dart';
import 'package:sugarCulinary/utils/dialbox_edit.dart';


import 'package:flutter/material.dart';
import 'package:sugarCulinary/pages/recipe_struct.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Scraping extends StatefulWidget {
  String scrapRecipeName;
  List scrapAllIngredient;
  List<String> scrapStepsRecipe;
  String scrapTotalTime;
  List scrapTags;
  String? pathImageSelectedFromImagePicker;
  String? urlImageScrap;
  String? sourceUrlScrap;
  String? scrapRecipeCategory;
  Scraping({
    super.key,
    required this.scrapRecipeName,
    required this.scrapStepsRecipe,
    required this.scrapAllIngredient,
    required this.scrapTotalTime,
    required this.scrapTags,
    this.pathImageSelectedFromImagePicker,
    this.urlImageScrap,
    this.sourceUrlScrap,
  });

  @override
  
  _ScrapingState createState() => _ScrapingState();
}

class _ScrapingState extends State<Scraping> {
  

  String scrapDifficulty = "";
  String scrapCost = "";
  bool isFromScrap = true;

  bool isShowIngredientsSelectedPressed = false;
  bool isshowStepsAddedPressed = false;
  bool isButtonAddCategoryVisible = true;
  bool isshowTagsAddedPressed = false;
  bool _isConfirmBack = false;

  
  final _myBox = Hive.box('mybox');
  
  RecipeDatabase db = RecipeDatabase();

  String previewImageTextField = "";
  String defautImage = "recipe_pics/no_image.png";

  
  void showDialogCategoryEmpty() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Category is required.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            actions: [
              ElevatedButton(
                child: Text("Back"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  

  
  void _getDataFromAddExistingCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExistingCategory(),
      ),
    );

    if (result != null) {
      String categoryName = result;

      setState(() {
        isButtonAddCategoryVisible = false;
      });
      widget.scrapRecipeCategory = categoryName;
    }
  }

  
  Widget addCategory() {
    setState(() {});
    return isButtonAddCategoryVisible
        ? ElevatedButton(
            onPressed: () async {
              setState(() {
                _getDataFromAddExistingCategory(context);
              });
            },
            child: Text("Add a category (required)"),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Category",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                widget.scrapRecipeCategory!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  _getDataFromAddExistingCategory(context);
                },
                child: const Icon(
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
        builder: (context) => const AddRecipeName(),
      ),
    );

    if (result != null) {
      String recipeName = result;

      setState(() {
        
      });
      widget.scrapRecipeName = recipeName;
    }
  }

  
  Widget addRecipeName() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Recipe name",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
            width: 200,
            child: Text(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              widget.scrapRecipeName,
              style: widget.scrapRecipeName ==
                      "Deleted"
                  ? const TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                  : const TextStyle(
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
                            TextEditingController(text: widget.scrapRecipeName),
                        isFromScrap: true,
                        showSuggestion: () {
                          _getDataFromAddRecipeName(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.scrapRecipeName = data;
                }
              },
              child: const Icon(
                Icons.create,
                size: 30,
              ),
            ),
            const SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  widget.scrapRecipeName =
                      "Deleted";
                });
              },
              child:
                  const Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
        builder: (context) => const AddTotalTime(),
      ),
    );

    if (result != null) {
      String totalTime = result;

      setState(() {
        
      });
      widget.scrapTotalTime = totalTime;
    }
  }

  
  Widget addTotalTime() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Total time",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.scrapTotalTime,
            style: widget.scrapTotalTime ==
                    "Deleted"
                ? const TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                            TextEditingController(text: widget.scrapTotalTime),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddTotalTime(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  widget.scrapTotalTime = data;
                }
              },
              child: const Icon(
                Icons.create,
                size: 30,
              ),
            ),
            const SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  widget.scrapTotalTime = "Deleted";
                  Text(
                    widget.scrapTotalTime,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                });
              },
              child:
                  const Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
        builder: (context) => const AddDifficulty(),
      ),
    );

    if (result != null) {
      String difficulty = result;

      setState(() {
        
      });
      scrapDifficulty = difficulty;
    }
  }

  
  Widget addDifficulty() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Difficulty",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(scrapDifficulty,
            style: scrapDifficulty == "Deleted"
                ? const TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                            TextEditingController(text: scrapDifficulty),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddDifficulty(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  scrapDifficulty = data;
                }
              },
              child: const Icon(
                Icons.create,
                size: 30,
              ),
            ),
            const SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  scrapDifficulty = "Deleted";
                });
              },
              child:
                  const Icon(Icons.delete, size: 20, color: Colors.redAccent),
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
        builder: (context) => const AddCost(),
      ),
    );

    if (result != null) {
      String cost = result;

      setState(() {
        
      });
      scrapCost = cost;
    }
  }

  
  Widget addCost() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Cost",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(scrapCost,
            style: scrapCost == "Deleted"
                ? const TextStyle(fontSize: 10, fontStyle: FontStyle.italic)
                : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return DialogEditRecipeField(
                        controller: TextEditingController(text: scrapCost),
                        isFromScrap: false,
                        showSuggestion: () {
                          _getDataFromAddCost(context);
                        },
                      );
                    });
                if (result != null) {
                  String data = result;
                  setState(() {});
                  scrapCost = data;
                }
              },
              child: const Icon(
                Icons.create,
                size: 30,
              ),
            ),
            const SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  scrapCost = "Deleted";
                });
              },
              child:
                  const Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  
  
  
  
  

  
  _imageToDisplay() {
    if (widget.urlImageScrap != null) {
      return Image.network(
        widget.urlImageScrap!,
        width: 200,
        height: 200,
      );
    } else if (widget.pathImageSelectedFromImagePicker != null) {
      return Image.file(
        File(widget.pathImageSelectedFromImagePicker!),
        width: 200,
        height: 200,
      );
    } else if (widget.urlImageScrap == null &&
        widget.pathImageSelectedFromImagePicker == null) {
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
        builder: (context) => const MyImagePickerPage(),
      ),
    );

    if (result != null) {
      String imageSelected = result;
      setState(() {});
      widget.pathImageSelectedFromImagePicker = imageSelected;
      widget.urlImageScrap = null;
    }
  }

  
  Widget addPicture() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Picture : ",
        style: const TextStyle(
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
              style: const TextStyle(
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
              child: const Icon(
                Icons.create,
                size: 30,
              ),
            ),
            const SizedBox(width: 16), 
            InkWell(
              onLongPress: () {
                setState(() {
                  widget.pathImageSelectedFromImagePicker = null;
                  widget.urlImageScrap = null;
                });
              },
              child:
                  const Icon(Icons.delete, size: 20, color: Colors.redAccent),
            ),
          ],
        )
      ]),
    ]);
  }

  
  
  

  
  
  

  
  Widget addIngred() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      isShowIngredientsSelectedPressed
          ? TextButton(
              onPressed: () {
                setState(() {
                  isShowIngredientsSelectedPressed = false;
                });
              },
              child: Row(
                children: [
                  Text(
                    "Collapse",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_downward,
                    size: 16, 
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
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
                        widget.scrapAllIngredient.add(addedIngredScrap);
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                      width: 16), 
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.scrapAllIngredient = [];
                      });
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.redAccent),
                  ),
                ],
              ))
          : TextButton(
              onPressed: () {
                setState(() {
                  isShowIngredientsSelectedPressed = true;
                });
              },
              child: Row(
                children: [
                  Text(
                    "Show Ingredients",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_upward,
                    size: 16, 
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
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
                        widget.scrapAllIngredient.add(addedIngredScrap);
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                      width: 16), 
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.scrapAllIngredient = [];
                      });
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.redAccent),
                  ),
                ],
              )),
    ]);
  }

  
  Widget showIngredientsSelected() {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 242, 255, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 400,
        child: ListView.builder(
          itemCount: widget.scrapAllIngredient.length,
          itemBuilder: (context, index) {
            
            
            

            
            return ListTile(
              title: Text(widget.scrapAllIngredient[index]),
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
                              text: widget.scrapAllIngredient[index].toString(),
                            ));
                          });
                      if (result != null) {
                        String addedIngredScrap = result;
                        setState(() {});
                        widget.scrapAllIngredient[index] = addedIngredScrap;
                      }
                    },
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        widget.scrapAllIngredient.removeAt(index);
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
        builder: (context) => const CreateSteps(),
      ),
    );

    if (result != null) {
      List<String> stepsRecipe = result;
      setState(() {});
      widget.scrapStepsRecipe.addAll(stepsRecipe);
    }
  }

  
  Widget addSteps() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      isshowStepsAddedPressed
          ? TextButton(
              onPressed: () {
                setState(() {
                  isshowStepsAddedPressed = false;
                });
              },
              child: Row(
                children: [
                  Text(
                    "Collapse",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_downward,
                    size: 16, 
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      getDataFromCreateSteps(context);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                      width: 16), 
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.scrapStepsRecipe = [];
                      });
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.redAccent),
                  ),
                ],
              ))
          : TextButton(
              onPressed: () {
                setState(() {
                  isshowStepsAddedPressed = true;
                });
              },
              child: Row(
                children: [
                  Text(
                    "Show steps",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_upward,
                    size: 16, 
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      getDataFromCreateSteps(context);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                      width: 16), 
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.scrapStepsRecipe = [];
                      });
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.redAccent),
                  ),
                ],
              )),
    ]);
  }

  
  Widget showStepsAdded() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 400,
      child: ListView.builder(
        itemCount: widget.scrapStepsRecipe.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                ' ${"Step"} ${index + 1}:\n${widget.scrapStepsRecipe[index]}'),
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
                                text:
                                    widget.scrapStepsRecipe[index].toString()),
                          );
                        });
                    if (result != null) {
                      String stepEdited = result;
                      setState(() {});
                      widget.scrapStepsRecipe[index] = stepEdited;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.scrapStepsRecipe.removeAt(index);
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
        builder: (context) => const AddTags(),
      ),
    );

    if (result != null) {
      List data = result;
      setState(() {});
      widget.scrapTags!.addAll(data);
    }
  }

  
  Widget addTags() {
    setState(() {});
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      isshowTagsAddedPressed
          ? TextButton(
              onPressed: () {
                setState(() {
                  isshowTagsAddedPressed = false;
                });
              },
              child: Row(
                children: [
                  Text(
                    "Collapse",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_downward,
                    size: 16, 
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      getDataFromAddTags(context);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                      width: 16), 
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.scrapTags!.clear();
                      });
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.redAccent),
                  ),
                ],
              ))
          : TextButton(
              onPressed: () {
                setState(() {
                  isshowTagsAddedPressed = true;
                });
              },
              child: Row(
                children: [

                  const Icon(
                    Icons.arrow_upward,
                    size: 16, 
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      getDataFromAddTags(context);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                      width: 16), 
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        widget.scrapTags!.clear();
                      });
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.redAccent),
                  ),
                ],
              )),
    ]);
  }

  
  Widget showTagsAdded() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 242, 255, 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 400,
      child: ListView.builder(
        itemCount: widget.scrapTags!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${widget.scrapTags![index]}'),
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
                                text: widget.scrapTags![index].toString()),
                          );
                        });
                    if (result != null) {
                      String data = result;
                      setState(() {});
                      widget.scrapTags![index] = data;
                    }
                  },
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.scrapTags!.removeAt(index);
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

  
  

  Widget ShowWidget() {
    setState(() {});
    if (isShowIngredientsSelectedPressed == false &&
        isshowStepsAddedPressed == false &&
        isshowTagsAddedPressed == false) {
      return Column(children: [
        addCategory(),
        addRecipeName(),
        addTotalTime(),
        addDifficulty(),
        addCost(),
        addPicture(),
        addIngred(),
        addSteps(),
        addTags(),
      ]);
    } else if (isShowIngredientsSelectedPressed == true) {
      return Column(children: [addIngred(), showIngredientsSelected()]);
    } else if (isshowStepsAddedPressed == true) {
      return Column(children: [
        addSteps(),
        showStepsAdded(),
      ]);
    } else if (isshowTagsAddedPressed == true) {
      return Column(children: [
        addTags(),
        showTagsAdded(),
      ]);
    } else {
      return const Text("Error, no widgets to display");
    }
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Center(
                      child: Text("You can save changes and edit later",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)))
                ])),
            actions: <Widget>[
              TextButton(
                child: Text("Yes, exit",
                    style: const TextStyle(color: Colors.red)),
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
                    style: const TextStyle(color: Colors.lightGreen)),
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
          "Add from web",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          canPop: _isConfirmBack,
          onPopInvoked: (bool didPop) async {
            if (didPop) return;
            _showDialog();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ShowWidget(),
                  ],
                ),
              ),
              if (!isShowIngredientsSelectedPressed &&
                  !isshowStepsAddedPressed &&
                  !isshowTagsAddedPressed)
                _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _handleSubmit,
        child: Text(
          "Add",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    
    final finalscrapRecipeName = widget.scrapRecipeName ==
            "Deleted"
        ? "No title"
        : widget.scrapRecipeName;

    final finalscrapTotalTime = widget.scrapTotalTime ==
            "Deleted"
        ? ""
        : widget.scrapTotalTime;

    final finalscrapDifficulty = scrapDifficulty ==
            "Deleted"
        ? ""
        : scrapDifficulty;

    final finalscrapCost =
        scrapCost == "Deleted"
            ? ""
            : scrapCost;

    
    DateTime now = DateTime.now();
    String creationDate =
        'variable_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

    
    List listOfLists = _myBox.get('ALL_LISTS') ?? [];

    
    double? stars = null;
    List? detailTIme = null;
    List? utensils = null;

    
    
    try {
      listOfLists.add([
        finalscrapRecipeName,
        finalscrapTotalTime,
        finalscrapDifficulty,
        finalscrapCost,
        widget.scrapAllIngredient,
        widget.pathImageSelectedFromImagePicker,
        widget.scrapStepsRecipe,
        widget.scrapRecipeCategory!,
        isFromScrap,
        creationDate,
        widget.scrapTags,
        stars,
        detailTIme,
        utensils,
        widget.urlImageScrap,
        widget.sourceUrlScrap
      ]);
    } catch (e) {
      return showDialogCategoryEmpty();
    }

    
    _myBox.put("ALL_LISTS", listOfLists);

    
    RecipeStruct recipeDetailsPage = RecipeStruct(
      recipeName: finalscrapRecipeName,
      totalTime: finalscrapTotalTime,
      difficulty: finalscrapDifficulty,
      cost: finalscrapCost,
      allIngredientSelected: widget.scrapAllIngredient,
      pathImageSelectedFromImagePicker:
          widget.pathImageSelectedFromImagePicker,
      stepsRecipeFromCreateSteps: widget.scrapStepsRecipe,
      isFromScrap: isFromScrap,
      tags: widget.scrapTags,
      uniqueId: creationDate,
      recipeCategory: widget.scrapRecipeCategory!,
      isFromFilteredNameRecipe: false,
      urlImageScrap: widget.urlImageScrap,
      sourceUrlScrap: widget.sourceUrlScrap,
    );

    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => recipeDetailsPage),
    );
  }
}

class AppColors {
  static const Color primary = Color(0xFF2196F3);      
  static const Color secondary = Color(0xFF03A9F4);    
  static const Color accent = Color(0xFFFF9800);       
  static const Color background = Color(0xFFFFFFFF);   
  static const Color text = Color(0xFF000000);         
  static const Color error = Color(0xFFB00020);
  
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color secondaryLight = Color(0xFFB3E5FC);
  static const Color accentLight = Color(0xFFFFE0B2);
  static const Color cardBackground = Color(0xFFF7F2FF);
}

