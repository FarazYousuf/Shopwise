import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DialogUtils {
  static void showAddItemDialog(
    BuildContext context,
    Map<String, dynamic> selectedLocation,
  ) {
    final TextEditingController itemNameController = TextEditingController();
    final TextEditingController itemBrandController = TextEditingController();
    final TextEditingController itemQuantityController =
        TextEditingController();
    final TextEditingController itemUnitController = TextEditingController();
    final TextEditingController itemPriceController = TextEditingController();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonTextColor = isDarkMode ? Colors.grey.shade300 : Colors.black;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Add Item',
            style: TextStyle(color: textColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                TextField(
                  controller: itemBrandController,
                  decoration: InputDecoration(
                    labelText: 'Item Brand',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                TextField(
                  controller: itemQuantityController,
                  decoration: InputDecoration(
                    labelText: 'Item Quantity',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                ),
                TextField(
                  controller: itemUnitController,
                  decoration: InputDecoration(
                    labelText: 'Unit (e.g., kg)',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                TextField(
                  controller: itemPriceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Location: ${selectedLocation['name']}',
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Add',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () async {
                if (itemNameController.text.isNotEmpty &&
                    itemBrandController.text.isNotEmpty &&
                    itemQuantityController.text.isNotEmpty &&
                    itemUnitController.text.isNotEmpty &&
                    itemPriceController.text.isNotEmpty) {
                  final itemName = itemNameController.text;
                  final itemBrand = itemBrandController.text;
                  final itemQuantity =
                      int.tryParse(itemQuantityController.text) ?? 0;
                  final itemUnit = itemUnitController.text;
                  final itemPrice =
                      double.tryParse(itemPriceController.text) ?? 0.0;

                  await FirebaseFirestore.instance.collection('items').add({
                    'name': itemName,
                    'brand': itemBrand,
                    'quantity': itemQuantity,
                    'unit': itemUnit,
                    'price': itemPrice,
                    'locationName': selectedLocation['name'],
                    'locationCoordinates': selectedLocation['coordinates'],
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
