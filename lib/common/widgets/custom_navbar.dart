import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  CustomBottomNavBar({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // Get the current brightness mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade800;
    final iconColor = isDarkMode ? Colors.grey.shade200 : Colors.white;
    final activeTabBackgroundColor = isDarkMode ? Colors.grey.shade800  : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 2.0, right: 2.0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(33.0),
            child: Container(
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 11.0),
                child: GNav(
                  backgroundColor: backgroundColor,
                  color: isDarkMode ? Colors.white : Colors.black,
                  activeColor: Colors.white,
                  tabBackgroundColor: activeTabBackgroundColor,
                  tabBorderRadius: 22.0,
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 11.0),
                  gap: 7,
                  selectedIndex: currentIndex,
                  tabs: [
                    GButton(
                      icon: Iconsax.home,
                      text: 'Home',
                      iconColor: iconColor,
                    ),
                    GButton(
                      icon: Iconsax.search_normal,
                      text: 'Search',
                      iconColor: iconColor,
                    ),
                    GButton(
                      icon: Icons.lightbulb_outline_sharp,
                      text: 'Suggestion',
                      iconColor: iconColor,
                    ),
                    GButton(
                      icon: Iconsax.trash,
                      text: 'Clear',
                      iconColor: iconColor,
                    ),
                  ],
                  onTabChange: onItemTapped,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
