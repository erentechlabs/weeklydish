import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../controller/allergen_controller.dart';
import '../../controller/menu_controller.dart';
import '../../database/app_database.dart';
import '../custom_ui/show_delete_dialog.dart';

class AllergensAddPage extends StatefulWidget {
  const AllergensAddPage({super.key});

  @override
  State<AllergensAddPage> createState() => _AllergensAddPageState();
}

class _AllergensAddPageState extends State<AllergensAddPage> {
  // TextController to read text entered in text field
  final TextEditingController allergensTextController = TextEditingController();

  // Allergen controller to interact with the database
  late AllergensController allergenController;

  // Menu controller to interact with the database
  late MenusController menuController;

  // List to store new
  final newAllergens = <String>[];

  // List to store old allergens
  final oldAllergens = <String>[];

  @override
  void initState() {
    // Call the super class initState method
    super.initState();
    // Initialize the AllergensController with the database instance
    allergenController = AllergensController(AppDatabase());

    // Initialize the MenuController with the database instance
    menuController = MenusController(AppDatabase());

    // Fetch allergens from the database and populate the newAllergens list
    fetchAllergensItems().then((value) {
      setState(() {
        newAllergens
          // Clear the list before adding items
          ..clear()
          ..addAll(value.map((e) => e.allergens));

        // Copy the new allergens to the old allergens list
        oldAllergens.addAll(newAllergens);
      });
    });
  }

  // Function to fetch allergens items from the database
  Future<List<Allergen>> fetchAllergensItems() async {
    // Fetch all allergens items from the database
    return await allergenController.fetchAllergensItems();
  }

  // Function to save an allergen item to the database
  Future<void> saveAllergenItem(String newAllergen) async {
    // Insert the allergen item into the database
    await allergenController.insertAllergens(newAllergen);

    // Refresh the UI after saving
    setState(() {});
  }

  // Function to delete an allergen item from the database
  Future<void> deleteAllergenItem(int id) async {
    // Delete the allergen item from the database
    await allergenController.deleteAllergenItem(id);

    // Refresh the UI after deleting
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Prevent the user from going back, if the user wants to go back, they must press the back button
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("addAllergems").tr(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () async {
              // Fetch all allergens from the database
              final existingAllergens = await fetchAllergensItems();

              // Get the titles of the existing allergens
              final existingAllergenTitles =
                  existingAllergens.map((e) => e.allergens).toSet();

              // Change the case of the new allergens to lowercase
              Set<String> newAllergensSet =
                  newAllergens.map((e) => e.toLowerCase()).toSet();

              // Change the case of the old allergens to lowercase
              Set<String> oldAllergensSet =
                  oldAllergens.map((e) => e.toLowerCase()).toSet();

              // Difference between the new and old allergens
              Set<String> difference =
                  newAllergensSet.difference(oldAllergensSet);

              // Determine if the lists have different items
              bool isDifferentCount =
                  newAllergens.length != oldAllergens.length;

              // Check if the lists have different items
              if (difference.isNotEmpty || isDifferentCount) {
                // Update the allergens for all menu items
                menuController.updateAllergensForAllMenuItems(true);
              }

              // Check if there are any new allergens
              if (newAllergens.isNotEmpty) {
                // Save only new allergens
                for (var element in newAllergens) {
                  // Check if the allergen is not already in the database
                  if (!existingAllergenTitles.contains(element)) {
                    // Add only new allergens
                    await saveAllergenItem(element);
                  }
                }
              }

              // Close the page
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: newAllergens.isNotEmpty
                  ? ListView.builder(
                      itemCount: newAllergens.length,
                      itemBuilder: (BuildContext context, int index) {
                        final allergen = newAllergens[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(allergen),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outlined),
                                onPressed: () async {
                                  showDeleteDialog(context, "deleteItem".tr(),
                                      "delete".tr(), "cancel".tr(), () async {
                                    // Find the allergen by its name
                                    final allergenName = newAllergens[index];

                                    // Fetch all allergens to find the corresponding ID
                                    final allergenList =
                                        await allergenController
                                            .fetchAllergensItems();

                                    // Find the allergen to delete
                                    final allergenToDelete =
                                        allergenList.firstWhere(
                                      (element) =>
                                          element.allergens == allergenName,
                                      orElse: () =>
                                          const Allergen(id: -1, allergens: ''),
                                    );

                                    // If allergen exists, delete it
                                    await allergenController.deleteAllergenItem(
                                        allergenToDelete.id);

                                    // Refresh the list from the database
                                    final updatedAllergens =
                                        await fetchAllergensItems();

                                    // Update the UI
                                    setState(() {
                                      newAllergens.clear();
                                      newAllergens.addAll(updatedAllergens
                                          .map((e) => e.allergens));
                                    });

                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  }, () {
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.health_and_safety_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                          Text(
                            "noAllergensAdded".tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Row to add item in list
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
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
                          controller: allergensTextController,
                          decoration: InputDecoration(
                            hintText: "enterItem".tr(),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // IconButton to add item in list
                  IconButton(
                    icon: const Icon(Icons.add_outlined, size: 40),
                    onPressed: () async {
                      // Get the text entered in the text field
                      final newAllergen = allergensTextController.text.trim();

                      // Check if the text is not empty and not already in the list
                      if (newAllergen.isNotEmpty &&
                          !newAllergens.contains(newAllergen)) {
                        // Save the allergen to the database FIRST
                        await saveAllergenItem(newAllergen);

                        // Refresh the allergens list from the database
                        final updatedAllergens = await fetchAllergensItems();

                        // Update the UI
                        setState(() {
                          newAllergens.clear();
                          newAllergens
                              .addAll(updatedAllergens.map((e) => e.allergens));
                        });

                        // Clear the text field
                        allergensTextController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
