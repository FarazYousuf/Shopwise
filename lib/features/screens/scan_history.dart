import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_wise/common/widgets/custom_navbar.dart';
import 'package:shop_wise/features/screens/suggestion_screen.dart';

class ScanHistoryScreen extends StatefulWidget {
  @override
  _ScanHistoryScreenState createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                      .collection('scan_history')
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

  Future<void> _deleteItem(String itemId) async {
    await _firestore.collection('scan_history').doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final drawerIconColor = isDarkMode ? Colors.grey.shade400 : Colors.black;
    final appBarColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = isDarkMode ? Colors.grey.shade400 : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textColor,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 60.0),
          child: Text(
            'Scan History',
            style: TextStyle(color: textColor),
          ),
        ),
        toolbarHeight: kToolbarHeight,
        backgroundColor: Color.fromARGB(31, 172, 170, 170),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.swap_vert,
        //       color: textColor,
        //     ),
        //     onPressed: () {
        //       // Implement the swap functionality
        //     },
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.grey.shade200,
              ),
            ),
            ListTile(
              leading: Icon(Icons.history, color: drawerIconColor),
              title: Text('Scan History',
                  style: TextStyle(color: drawerIconColor)),
              onTap: () {
                // Navigate to scan history screen
                Navigator.pushNamed(context, '/scanHistory');
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: drawerIconColor),
              title: Text('Currency Picker',
                  style: TextStyle(color: drawerIconColor)),
              onTap: () {
                // Implement currency picker functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.adjust, color: drawerIconColor),
              title: Text('Unit Metrics Picker',
                  style: TextStyle(color: drawerIconColor)),
              onTap: () {
                // Implement unit metrics picker functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.clear_all, color: drawerIconColor),
              title:
                  Text('Clear Data', style: TextStyle(color: drawerIconColor)),
              onTap: () {
                // Implement data clearing functionality
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Are you sure you want to clear all data?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Clear'),
                        onPressed: () async {
                          // Clear data functionality
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('scan_history').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No history available.'));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final itemId = item.id;
              final itemName = item['name'] as String;

              return Dismissible(
                key: Key(itemId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await _deleteItem(itemId);
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
                child: ListTile(
                  title: Text(itemName),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showEditItemDialog(itemId, itemName);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: _onItemTapped,
        currentIndex: 0, // or any default index you prefer
      ),
    );
  }
}
