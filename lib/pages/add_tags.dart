



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

class AddTags extends StatefulWidget {
  const AddTags({super.key});

  @override
  State<AddTags> createState() => _AddTagsState();
}

class _AddTagsState extends State<AddTags> {
  late List<String> tags; 
  late List<String> filteredList = []; 

  final List selectedTags = []; 
  final TextEditingController _controller = TextEditingController();
  late TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    filteredList = tags;

    _searchController = TextEditingController();
  }

  
  void filterSearchResults(String query) {
    
    setState(() {
      filteredList = tags.where((item) {
        final itemLowerCase = item.toLowerCase(); 
        final input = query
            .toLowerCase(); 
        return itemLowerCase
            .contains(input); 
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
          "Add tags",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
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
                hintText: "Search a tag",
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
                    onTap: () {
                      setState(() {
                        if (!selectedTags.contains(filteredList[index])) {
                          selectedTags.insert(0, filteredList[index]);
                        }
                      });
                    },
                    title: Text(
                      filteredList[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedTags.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Selected Tags',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: selectedTags.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedTags[index],
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
                            selectedTags.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildButton(
                    icon: Icons.add,
                    text: "Add a tag",
                    onPressed: () => _showAddDialog(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildButton(
                    icon: Icons.check,
                    text: "Add",
                    onPressed: () => Navigator.pop(context, selectedTags),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.background,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Add a tag",
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
            hintText: "Write a tag here",
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
                  if (_controller.text.isNotEmpty) {
                    selectedTags.add(_controller.text);
                    Navigator.pop(context);
                    _controller.clear();
                    setState(() {});
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
