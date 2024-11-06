



import 'package:flutter/material.dart';


class AddCost extends StatefulWidget {
  const AddCost({super.key});

  @override
  State<AddCost> createState() => _AddCostState();
}

class _AddCostState extends State<AddCost> {
  final TextEditingController _controller = TextEditingController();
  late List<String> costList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    costList = 'Budget-friendly,Average,Expensive'.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Add cost",
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: costList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
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
                      onTap: () => Navigator.pop(context, costList[index]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        child: Text(
                          costList[index],
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
          Padding(
            padding: EdgeInsets.all(16),
            child: FloatingActionButton(
              backgroundColor: AppColors.accent,
              onPressed: () => _showAddDialog(context),
              child: Icon(Icons.add, color: AppColors.background, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Add cost",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text,
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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDialogButton(
                context: context,
                text: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                  _controller.clear();
                },
                isPrimary: false,
              ),
              SizedBox(width: 16),
              _buildDialogButton(
                context: context,
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
    required BuildContext context,
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
