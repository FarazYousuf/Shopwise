import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: 0,
        // onDestinationSelected: (index) => ,
        destinations: [
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Iconsax.add), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.lightbulb), label: 'Suggest'),
          NavigationDestination(icon: Icon(Icons.delete), label: 'Clear'),
        ],
        ),
    );
  }
}