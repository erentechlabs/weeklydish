import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weeklydish/controller/food_and_dessert_contoller.dart';
import '../../database/app_database.dart';
import '../custom_ui/show_delete_dialog.dart';

// Menu Types
enum InsersType {
  foodBreakfast,
  foodLunch,
  foodDinner,
  dessertBreakfast,
  dessertLunch,
  dessertDinner,
}

class MenuAddPage extends StatefulWidget {
  // Menu Type
  final InsersType insersType;

  // Title
  final String title;
  const MenuAddPage({super.key, required this.insersType, required this.title});

  @override
  State<MenuAddPage> createState() => _MenuAddPageState();
}

class _MenuAddPageState extends State<MenuAddPage> {
  // Menu Item Controller
  final TextEditingController menuItemController = TextEditingController();

  // Add the items
  final List<String> localMenuItems = [];

  // Food and Dessert controller to interact with the database
  late FoodAndDessertController menuItemDatabaseController;

  @override
  void initState() {
    // Call the super class initState method
    super.initState();
    // Initialize the FoodAndDessertController with the database instance
    menuItemDatabaseController = FoodAndDessertController(AppDatabase());
  }

  // Function to fetch menu items from the database
  Future<List<FoodAndDessertData>> fetchMenuItemsByTypeAndMeal(
      String itemType, String mealType) async {
    // Fetch the items from the database
    return await menuItemDatabaseController.fetchItemsByTypeAndMeal(
        itemType, mealType);
  }

  // Function to save a food and dessert item to the database
  Future<void> saveMenuItem(
    String itemType,
    String mealType,
    List<String> content,
  ) async {
    await menuItemDatabaseController.insertFoodAndDessert(
      itemType,
      mealType,
      content,
    );
    // Refresh the UI after saving
    setState(() {});
  }

  // Function to delete a food and dessert item from the database
  Future<void> deleteMenuItem(int id) async {
    await menuItemDatabaseController.deleteFoodAndDessertItem(id);
    // Refresh the UI after deleting
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Title
          title: Text(widget.title),
          //Center the title
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                unselectedLabelColor: Colors.grey.shade500,
                tabs: <Widget>[
                  Tab(
                    text: "addItem".tr(),
                    icon: const Icon(Icons.add_outlined),
                  ),
                  Tab(
                    text: "viewItems".tr(),
                    icon: const Icon(Icons.restaurant_menu_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  // Add the items
                  addItems(),

                  // View the items
                  viewItems(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show the list of items
  Widget viewItems() {
    // Get the item type and meal type
    String itemType;
    String mealType;
    // Set the item type and meal type based on the menu type
    switch (widget.insersType) {
      case InsersType.foodBreakfast:
        itemType = "Food";
        mealType = "Breakfast";
        break;
      case InsersType.foodLunch:
        itemType = "Food";
        mealType = "Lunch";
        break;
      case InsersType.foodDinner:
        itemType = "Food";
        mealType = "Dinner";
        break;
      case InsersType.dessertBreakfast:
        itemType = "Dessert";
        mealType = "Breakfast";
        break;
      case InsersType.dessertLunch:
        itemType = "Dessert";
        mealType = "Lunch";
        break;
      case InsersType.dessertDinner:
        itemType = "Dessert";
        mealType = "Dinner";
        break;
    }

    return FutureBuilder<List<FoodAndDessertData>>(
      // Fetch the menu items
      future: fetchMenuItemsByTypeAndMeal(itemType, mealType),
      builder: (context, snapshot) {
        // Check the connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show the error
          return Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
              ),
              Text('error'.tr(args: [snapshot.error.toString()])),
            ],
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Show no items found
          return Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.restaurant_menu_outlined,
                size: 64,
              ),
              const Text("noItemsFound").tr(),
            ],
          ));
        }

        // Show the list of items
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            // Get the item
            final item = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(item.content.join(', ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outlined),
                    onPressed: () {
                      // Show the delete dialog
                      showDeleteDialog(context, "deleteItem".tr(),
                          "delete".tr(), "cancel".tr(), () {
                        // Delete the item
                        deleteMenuItem(item.id);
                        Navigator.of(context).pop();
                      }, () {
                        // Close the dialog
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Add the items
  Widget addItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // List of items
        Expanded(
          child: ListView.builder(
            // Item count
            itemCount: localMenuItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(localMenuItems[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outlined),
                      onPressed: () {
                        setState(() {
                          // Remove the item
                          localMenuItems.removeAt(index);
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Add the item
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: menuItemController,
                      decoration: InputDecoration(
                        hintText: "enterItem".tr(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),

              // Add the item
              IconButton(
                icon: const Icon(Icons.add_outlined, size: 40),
                onPressed: () {
                  setState(() {
                    if (menuItemController.text.isNotEmpty) {
                      // Add the item to the list
                      localMenuItems.add(menuItemController.text);
                      // Clear the text field
                      menuItemController.clear();
                    } else if (localMenuItems.isNotEmpty) {
                      // Get the item type
                      String itemType;

                      // Get the meal type
                      String mealType;

                      // Set the item type and meal type based on the menu type
                      switch (widget.insersType) {
                        case InsersType.foodBreakfast:
                          itemType = "Food";
                          mealType = "Breakfast";
                          break;
                        case InsersType.foodLunch:
                          itemType = "Food";
                          mealType = "Lunch";
                          break;
                        case InsersType.foodDinner:
                          itemType = "Food";
                          mealType = "Dinner";
                          break;
                        case InsersType.dessertBreakfast:
                          itemType = "Dessert";
                          mealType = "Breakfast";
                          break;
                        case InsersType.dessertLunch:
                          itemType = "Dessert";
                          mealType = "Lunch";
                          break;
                        case InsersType.dessertDinner:
                          itemType = "Dessert";
                          mealType = "Dinner";
                          break;
                      }

                      // Save the items with their recipes
                      saveMenuItem(
                        itemType,
                        mealType,
                        localMenuItems,
                      );

                      // Clear the list
                      localMenuItems.clear();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
