import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_wise/common/widgets/custom_navbar.dart';
import 'package:shop_wise/features/screens/suggestion_screen.dart';
import 'package:shop_wise/common/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_wise/features/screens/location_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<String>> _itemsStream;

  @override
  void initState() {
    super.initState();
    _itemsStream = _firestore.collection('items').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc['name'] as String).toList(),
        );
  }

  // Method to show a dialog for adding a new item
  void _showAddItemDialog() {
    final TextEditingController _controller = TextEditingController();

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
            'Add Item',
            style: TextStyle(color: textColor),
          ),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter item name',
              hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
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
                'Add',
                style: TextStyle(color: buttonTextColor),
              ),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await _firestore
                      .collection('items')
                      .add({'name': _controller.text});
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final drawerIconColor = isDarkMode ? Colors.grey.shade400 : Colors.black;
    // final tileColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final double tileHeight = 70.0;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 70.0),
          child: Text(
            'Shopwise',
            style: TextStyle(
              color: isDarkMode
                  ? Colors.grey.shade400
                  : Colors.black, // Text color based on theme
            ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No items found'));
          }

          final items = snapshot.data!.docs;
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDarkMode ? Colors.white : Colors.black;
          final tileColor = isDarkMode ? Colors.grey[850] : Colors.white;
          final iconColor = isDarkMode ? Colors.white : Colors.black;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final itemId = item.id; // Get the document ID
              final itemName = item['name'] as String;

              return Dismissible(
                key: Key(itemId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await _firestore.collection('items').doc(itemId).delete();
                },
                background: Container(
                  color: Colors.redAccent,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: tileColor, // Set color based on theme
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: tileHeight,
                    child: ListTile(
                      title: Text(
                        itemName,
                        style: TextStyle(
                            color: textColor), // Set text color based on theme
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 22.0,
                            color: iconColor, // Set icon color based on theme
                          ),
                          onPressed: () {
                            _showEditItemDialog(itemId, itemName);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          LatLng? selectedLocation = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationPickerScreen()),
          );
          if (selectedLocation != null) {
            // Handle the selectedLocation here, e.g., update the state or perform an action
            print('Selected location: $selectedLocation');
          }
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
