import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_wise/common/widgets/custom_navbar.dart';
import 'package:shop_wise/features/screens/suggestion_screen.dart';
import 'package:shop_wise/common/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_wise/features/screens/location_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<String>> _itemsStream;
  String _selectedLocationName = 'Select Location';

  String locationName = '';

  @override
  void initState() {
    super.initState();
    _itemsStream = _firestore.collection('items').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc['name'] as String).toList(),
        );
  }

  // Update the selected location name
  void _updateSelectedLocationName(String locationName) {
    setState(() {
      _selectedLocationName = locationName;
    });
  }

  void _saveItemToFirestore(
    String name,
    String brand,
    int quantity,
    String unit,
    double price,
    String location,
  ) async {
    await FirebaseFirestore.instance.collection('items').add({
      'name': name,
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'locationName': locationName,
      // 'locationCoordinates': GeoPoint(
      //   location['coordinates'].latitude,
      //   location['coordinates'].longitude,
      // ),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Method to show the Add Item dialog
  void _showAddItemDialog(String selectedLocation) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: ',
                      style: TextStyle(color: textColor),
                    ),
                    Flexible(
                      child: Text(
                        locationName,
                        style: TextStyle(color: textColor),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
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
                      double.tryParse(itemPriceController.text) ?? 0;

                  _saveItemToFirestore(
                    itemName,
                    itemBrand,
                    itemQuantity,
                    itemUnit,
                    itemPrice,
                    selectedLocation,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _openLocationPicker() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPickerScreen()),
    );

    // if (selectedLocation != null) {
    _showAddItemDialog(selectedLocation);
    // }
  }

  // Method to handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        // _showAddItemDialog();
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuggestionScreen()),
        );
        break;
      case 3:
        _showClearConfirmationDialog();
        break;
    }
  }

  // Method to show clear confirmation dialog
  void _showClearConfirmationDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonTextColor = isDarkMode ? Colors.grey.shade300 : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Clear Data',
            style: TextStyle(color: textColor),
          ),
          content: Text(
            'Are you sure you want to clear all data?',
            style: TextStyle(color: textColor),
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
                'Clear',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () async {
                final batch = _firestore.batch();
                final snapshot = await _firestore.collection('items').get();
                for (final doc in snapshot.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show the edit dialog
  void _showEditItemDialog(String itemId, String currentItemName) {
    final TextEditingController _controller =
        TextEditingController(text: currentItemName);

    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor =
            isDarkMode ? Colors.grey.shade900 : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final buttonTextColor =
            isDarkMode ? Colors.grey.shade300 : Colors.black;

        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Edit Item',
            style: TextStyle(color: textColor),
          ),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter new item name',
              hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            ),
            style: TextStyle(color: textColor),
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
                'Save',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await _firestore
                      .collection('items')
                      .doc(itemId)
                      .update({'name': _controller.text});
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _changeLocation() async {
    locationName = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPickerScreen()),
    );
    print(locationName);
    _updateSelectedLocationName(locationName);
  }

  void _deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
      // Optionally, show a snackbar or dialog to confirm the deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully')),
      );
    } catch (e) {
      // Handle errors, e.g., network issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final drawerIconColor = isDarkMode ? Colors.grey.shade400 : Colors.black;
    final ribbonColor =
        isDarkMode ? Colors.grey.shade900 : Color.fromARGB(255, 218, 218, 215);
    final ribbonTextColor = isDarkMode ? Colors.white : Colors.grey.shade800;
    final LabelTextColor =
        isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500;
    final TileColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
    final itemLabelColor =
        isDarkMode ? Colors.grey.shade300 : Colors.grey.shade900;
    final itemDescColor =
        isDarkMode ? Colors.grey.shade500 : Colors.grey.shade900;
    final changeButtonColor = isDarkMode
        ? Color.fromARGB(255, 226, 155, 96)
        : Color.fromARGB(255, 62, 150, 65);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 70.0),
          child: Row(
            children: [
              Text(
                'Shopwise',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: kToolbarHeight,
        backgroundColor: Color.fromARGB(31, 172, 170, 170),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: drawerIconColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_vert,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              // Implement the swap functionality
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ribbonColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: ribbonTextColor,
                ),
                SizedBox(width: 6.0),
                Text(
                  'Location: ',
                  style: TextStyle(
                    color: ribbonTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    _selectedLocationName,
                    style: TextStyle(
                      color: ribbonTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _changeLocation,
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: changeButtonColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('items').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        'List is Empty, Please add a product for comparison',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: LabelTextColor),
                        textAlign: TextAlign
                            .center, // Centers the text within the padding
                      ),
                    ),
                  );
                }

                final items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final itemName = item['name'] as String;
                    final itemBrand = item['brand'] as String;
                    final itemQuantity = item['quantity'] as int;
                    final itemPrice = item['price'] as double;
                    final itemUnit = item['unit'] as String;
                    final itemId = item.id;

                    return Slidable(
                      key: ValueKey(itemId),
                      endActionPane: ActionPane(
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _deleteItem(itemId);
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 189, 43, 32),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            padding: EdgeInsets.zero,
                            flex: 100, // Adjust flex to fit content
                          ),
                        ],
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        color: TileColor,
                        child: Container(
                          height: 97.0,
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      itemName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: itemLabelColor,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Brand: $itemBrand',
                                      style: TextStyle(
                                        color: itemDescColor,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Quantity: $itemQuantity $itemUnit',
                                      style: TextStyle(
                                        color: itemDescColor,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                'Rs.${itemPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("button");
          if (_selectedLocationName == 'Select Location') {
            print("Please select Location first");
            locationName = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationPickerScreen()),
            );
          }
          if (locationName != '') {
            _showAddItemDialog(_selectedLocationName);
          }
          _updateSelectedLocationName(locationName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        tooltip: 'Add Item',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: _onItemTapped,
        currentIndex: 0, // or any default index you prefer
      ),
    );
  }
}
