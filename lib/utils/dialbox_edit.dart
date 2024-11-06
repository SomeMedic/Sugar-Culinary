



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
  static const Color cardBackground = Color(0xFFF7F2FF);
}

class DialogEditRecipeField extends StatelessWidget {
  final TextEditingController controller;
  final bool isFromScrap;
  final VoidCallback showSuggestion;

  const DialogEditRecipeField({
    super.key,
    required this.controller,
    required this.isFromScrap,
    required this.showSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.background,
      content: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                maxLines: null,
                controller: controller,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showSuggestion();
                  },
                  icon: Icon(Icons.lightbulb_outline),
                  label: Text(
                    "Show suggestions",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.text,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: Text(
                        "Add",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
