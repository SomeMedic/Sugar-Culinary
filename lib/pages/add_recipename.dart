



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

class AddRecipeName extends StatefulWidget {
  const AddRecipeName({super.key});

  @override
  State<AddRecipeName> createState() => _AddRecipeNameState();
}

class _AddRecipeNameState extends State<AddRecipeName> {
  final TextEditingController _controller = TextEditingController();
  late List<String> recipeNameList;
  late List<String> filteredList = [];
  late TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    filteredList = recipeNameList;
    _searchController = TextEditingController();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList = recipeNameList.where((item) {
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
          "Add a recipe name",
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
          Padding(
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
                hintText: "Search a recipe name",
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
                    color: AppColors.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.text.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => Navigator.pop(context, filteredList[index]),
                    title: Text(
                      filteredList[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add, color: AppColors.background),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    _searchController.clear();
    filterSearchResults('');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Add a recipe name",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDialogButton(
                text: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                  _controller.clear();
                },
                isPrimary: false,
              ),
              SizedBox(width: 16),
              _buildDialogButton(
                text: "Add",
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, _controller.text);
                },
                isPrimary: true,
              ),
            ],
          ),
        ],
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
}
