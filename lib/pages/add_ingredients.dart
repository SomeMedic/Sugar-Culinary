



import 'package:sugarCulinary/utils/dialbox_add_ingredient_quantity.dart';
import 'package:flutter/material.dart';


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

class AddIngred extends StatefulWidget {
  const AddIngred({super.key});

  @override
  State<AddIngred> createState() => _AddIngredState();
}

class _AddIngredState extends State<AddIngred> {
  late List<String> ingredientList;
  late List<String> filteredList = [];
  final List selectedIngredientName = [];
  final List allIngredientSelected = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  late TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    filteredList = ingredientList;
    _searchController = TextEditingController();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList = ingredientList.where((item) {
        final itemLowerCase = item.toLowerCase();
        final input = query.toLowerCase();
        return itemLowerCase.contains(input);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Add ingredients",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.background),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryLight.withOpacity(0.1),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          filterSearchResults('');
                        },
                        icon: Icon(Icons.clear, color: AppColors.primary),
                      )
                    : null,
                hintText: "Search an ingredient",
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
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.text.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddIngredientQuantity(),
                          ),
                        );
                        if (result != null) {
                          List finalQuantity = result;
                          setState(() {
                            finalQuantity.insert(0, filteredList[index]);
                            allIngredientSelected.add(finalQuantity);
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Text(
                          filteredList[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.text.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Selected ingredients",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: allIngredientSelected.length,
                    itemBuilder: (context, index) {
                      final ingredient = allIngredientSelected[index][0];
                      final quantity = allIngredientSelected[index][1];
                      final unit = allIngredientSelected[index][2];
                      final formattedString = '$ingredient: $quantity$unit';
                      
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            formattedString,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.text,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                allIngredientSelected.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        backgroundColor: AppColors.accent,
                        onPressed: () => _showAddCustomIngredientDialog(),
                        child: Icon(Icons.add, color: AppColors.background),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, allIngredientSelected);
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomIngredientDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Add custom ingredient",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: _controller,
                hintText: "Ingredient name",
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _controller2,
                hintText: "Quantity",
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _controller3,
                hintText: "Unit",
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDialogButton(
                text: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                  _clearControllers();
                },
                isPrimary: false,
              ),
              SizedBox(width: 16),
              _buildDialogButton(
                text: "Add",
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      allIngredientSelected.add([
                        _controller.text,
                        _controller2.text,
                        _controller3.text
                      ]);
                    });
                    Navigator.pop(context);
                    _clearControllers();
                  }
                },
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryLight.withOpacity(0.1),
        hintText: hintText,
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
    );
  }

  Widget _buildDialogButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.accent : AppColors.background,
        foregroundColor: isPrimary ? AppColors.background : AppColors.text,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary 
              ? BorderSide.none
              : BorderSide(color: AppColors.text.withOpacity(0.2)),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _clearControllers() {
    _controller.clear();
    _controller2.clear();
    _controller3.clear();
  }
}
