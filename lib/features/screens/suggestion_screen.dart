import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_wise/common/widgets/custom_navbar.dart';
import 'package:shop_wise/features/screens/main_screen.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Keep track of the current index for the bottom navigation bar
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        break;
      case 1:
        // Navigate to another screen if necessary
        break;
      case 2:
        // Current screen, no need to navigate
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            'Suggestions',
            style: TextStyle(color: textColor),
          ),
        ),
        toolbarHeight: kToolbarHeight,
        backgroundColor: Color.fromARGB(31, 172, 170, 170),
        actions: [
          IconButton(
            icon: Icon(
              Icons.swap_vert,
              color: textColor,
            ),
            onPressed: () {
              // Implement the swap functionality
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          '', // Add content here
          style: TextStyle(fontSize: 24, color: textColor),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
