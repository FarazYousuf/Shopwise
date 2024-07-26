import 'package:flutter/material.dart';
import 'package:shop_wise/common/widgets/custom_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> _items = []; // List to hold items

  // Method to add an item to the list
  void _addItem(String item) {
    setState(() {
      _items.add(item);
    });
  }

  // Method to show a dialog for adding a new item
  void _showAddItemDialog() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter item name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _addItem(_controller.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show a dialog for clearing data
  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Clear Data'),
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
              onPressed: () {
                setState(() {
                  _items.clear();
                });
                Navigator.of(context).pop();
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
        // Navigate to the history screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen()),
        );
        break;
      case 1:
        // Show add item dialog
        _showAddItemDialog();
        break;
      case 2:
        // Navigate to the suggestions screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuggestionScreen()),
        );
        break;
      case 3:
        // Show clear data dialog
        _showClearDataDialog();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 70.0), // Adjust this value to move the title
          child: Text('Shopwise'),
        ),
        toolbarHeight: kToolbarHeight,
        backgroundColor: Color.fromARGB(31, 172, 170, 170),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_vert),
            onPressed: () {
              // Implement the swap functionality
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Edit functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 173, 173, 173), // Change the background color of the button
        foregroundColor: Colors.white,
        tooltip: 'Add Item',
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                _onItemTapped(1);
              },
            ),
            IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () {
                _onItemTapped(2);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for HistoryScreen
class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Center(
        child: Text('History Screen'),
      ),
    );
  }
}

// Placeholder for SuggestionScreen
class SuggestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestions'),
      ),
      body: Center(
        child: Text('Suggestions Screen'),
      ),
    );
  }
}
