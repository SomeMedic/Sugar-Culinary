



import 'package:flutter/material.dart';


class AddIngredientQuantity extends StatefulWidget {
  const AddIngredientQuantity({super.key});

  @override
  State<AddIngredientQuantity> createState() => _AddIngredientQuantityState();
}

class _AddIngredientQuantityState extends State<AddIngredientQuantity> {
  List<int> numbers = List.generate(1000, (index) => index + 1);
  late List<String> units;

  List finalQuantity = ["", ""];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    units = "g, kg, mg, ml, l, cl, tsp, tbsp, pinch, drop, piece, tbspoz, pound, cup, pt, qt, gal".split(',');
  }

  void addQuantity(String value) {
    setState(() {
      finalQuantity.replaceRange(0, 1, [value]);
    });
  }

  void addUnit(String value) {
    setState(() {
      finalQuantity.replaceRange(1, 2, [value]);
    });
  }

  Widget displayQuantity(List value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value[0],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          value[1],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          "Quantity",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildNumbersList(),
                  Container(
                    width: 1,
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                  _buildUnitsList(),
                ],
              ),
            ),
          ),
          _buildQuantityDisplay(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildNumbersList() {
    return Expanded(
      child: ListView.builder(
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              '${numbers[index]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
            onTap: () => addQuantity('${numbers[index]}'),
            hoverColor: AppColors.primaryLight,
          );
        },
      ),
    );
  }

  Widget _buildUnitsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: units.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              units[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
            onTap: () => addUnit(units[index]),
            hoverColor: AppColors.secondaryLight,
          );
        },
      ),
    );
  }

  Widget _buildQuantityDisplay() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            finalQuantity[0],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: AppColors.primary,
            ),
          ),
          Text(
            finalQuantity[1],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primary),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, finalQuantity),
            child: Text("Add"),
          ),
        ],
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
  static const Color cardBackground = Color(0xFFF7F2FF);
}
