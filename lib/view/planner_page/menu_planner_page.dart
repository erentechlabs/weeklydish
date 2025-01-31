import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weeklydish/view/planner_page/allergens_add_page.dart';
import '../../controller/food_and_dessert_contoller.dart';
import '../../controller/menu_controller.dart';
import '../../database/app_database.dart';
import 'menu_add_page.dart';

class MenuPlannerPage extends StatelessWidget {
  MenuPlannerPage({super.key});

  // Initialize the controllers
  final foodAndDessertController = FoodAndDessertController(AppDatabase());

  // Initialize the menu controller
  final menuController = MenusController(AppDatabase());

  // Schedule the menu items
  Future<void> scheduleMenuItems() async {
    // All Food and Dessert items
    final allItems =
        await foodAndDessertController.fetchAllFoodAndDessertItems();

    // Group by categories
    final Map<String, List<FoodAndDessertData>> groupedItems = {
      'Food Breakfast': [],
      'Food Lunch': [],
      'Food Dinner': [],
      'Dessert Breakfast': [],
      'Dessert Lunch': [],
      'Dessert Dinner': [],
    };

    // Every item in the list
    for (var item in allItems) {
      // Get the key
      final key = '${item.itemType} ${item.mealType}';

      // If the key is in the grouped items
      if (groupedItems.containsKey(key)) {
        // Add the item
        groupedItems[key]!.add(item);
      }
    }

    // Shuffle the contents for each category
    final random = Random();

    // For each category
    for (var category in groupedItems.keys) {
      // Shuffle the items
      groupedItems[category]!.shuffle(random);
    }

    // Menu items in order by assigning a date
    DateTime currentDate = DateTime.now();

    // Check if there are any items remaining
    bool itemsRemaining = true;

    // While there are items remaining
    while (itemsRemaining) {
      // Check if there are any items remaining
      itemsRemaining = false;

      // For each category
      for (var category in groupedItems.keys) {
        // Get the items
        final items = groupedItems[category]!;

        // If there are any items
        if (items.isNotEmpty) {
          // Get the first item
          final item = items.removeAt(0);

          // Get the item type and meal type
          final itemType = category.split(' ').first;
          final mealType = category.split(' ').last;

          bool itemAddedForDay = false; // Track if item was added for this day

          // Check the date and advance until you find a suitable empty date
          while (!itemAddedForDay) {
            // Fetch the existing items
            final existingItems = await menuController.fetchItemsByDateAndMeal(
              DateTime(currentDate.year, currentDate.month, currentDate.day),
              itemType,
              mealType,
            );

            // If there are no existing items
            if (existingItems.isEmpty) {
              // If item.content is a list, handle each item separately
              List<String> contents = List<String>.from(item.content);

              for (var content in contents) {
                // Add each content item to the menu separately
                await menuController.insertMenu(
                  itemType,
                  mealType,
                  DateTime(
                      currentDate.year, currentDate.month, currentDate.day),
                  content,
                  "",
                  false,
                  false,
                );
              }

              // Item was added, so set flag
              itemAddedForDay = true;
              itemsRemaining = true;
            } else {
              // If item already exists for this day, continue to check the next day
              currentDate = currentDate.add(const Duration(days: 1));
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),

              // Title of the food and drinks
              menuTitleText("foodAndDrinks".tr()),

              // Button for breakfast
              menuButtons("breakfast".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuAddPage(
                      insersType: InsersType.foodBreakfast,
                      title: "addBreakfast".tr(),
                    ),
                  ),
                );
              }, Icons.breakfast_dining_outlined),

              // Button for lunch
              menuButtons("lunch".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuAddPage(
                      insersType: InsersType.foodLunch,
                      title: "addLunch".tr(),
                    ),
                  ),
                );
              }, Icons.lunch_dining_outlined),

              // Button for dinner
              menuButtons("dinner".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuAddPage(
                      insersType: InsersType.foodDinner,
                      title: "addDinner".tr(),
                    ),
                  ),
                );
              }, Icons.dinner_dining_outlined),

              // Title of the dessert
              menuTitleText("snacks".tr()),

              // Button for breakfast dessert
              menuButtons("breakfastSnacks".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuAddPage(
                      insersType: InsersType.dessertBreakfast,
                      title: "addBreakfastSnacks".tr(),
                    ),
                  ),
                );
              }, Icons.cookie_outlined),

              // Button for lunch dessert
              menuButtons("lunchSnacks".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuAddPage(
                      insersType: InsersType.dessertLunch,
                      title: "addLunchSnacks".tr(),
                    ),
                  ),
                );
              }, Icons.icecream_outlined),

              // Button for dinner dessert
              menuButtons("dinnerSnacks".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuAddPage(
                      insersType: InsersType.dessertDinner,
                      title: "addDinnerSnacks".tr(),
                    ),
                  ),
                );
              }, Icons.cake_outlined),

              // Title of the extra
              menuTitleText("extra".tr()),

              // Button for allergens
              menuButtons("allergens".tr(), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllergensAddPage(),
                  ),
                );
              }, Icons.health_and_safety_outlined),

              // Give some space
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Determine count of items
          foodAndDessertController
              .fetchAllFoodAndDessertItems()
              .then((value) async {
            // If there are no items
            if (value.length >= 3) {
              // Schedule the menu items
              await scheduleMenuItems();

              // Show a snack bar for items successfully added to the menu
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      // Show a check mark icon
                      const Icon(Icons.check_circle_outline,

                          // Success icon color
                          color: Colors.white,
                          size: 28),

                      // Add some space
                      const SizedBox(width: 12),

                      // Show a celebratory message
                      Expanded(
                        child: Text(
                          "succes".tr(args: ['🎉', '🎯']),
                          // Set the snack bar text style
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  // Success color
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  // Slightly rounded corners
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Gives a subtle shadow effect
                  elevation: 6,
                  // Keeps it visible for 3 seconds
                  duration: const Duration(seconds: 3),
                ),
              );
            } else {
              // Show a snack bar for at least 3 items
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'menuCreator'.tr(),

                    // Set the snack bar text style
                    style: const TextStyle(color: Colors.white),
                  ),

                  // Set the snack bar background color
                  backgroundColor: Colors.purple.shade400,

                  // Set the snack bar behavior
                  behavior: SnackBarBehavior.floating,

                  // Set the snack bar shape
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              );
            }
          });
        },

        // Set icon for the floating action button
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  // Widget for the title of the menu
  Widget menuTitleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24).copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // Widget for the buttons in the menu
  Widget menuButtons(String buttonText, VoidCallback onPressed, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
