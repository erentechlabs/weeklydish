import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weeklydish/controller/allergen_controller.dart';
import 'package:weeklydish/view/ai_page/ai_page.dart';
import '../../controller/menu_controller.dart';
import '../../database/app_database.dart';
import '../../extension/generative_model.dart';
import '../../model/nutrition_data.dart';
import '../custom_ui/ads_dialog.dart';
import '../custom_ui/nutrition_chart.dart';
import '../custom_ui/recipe_dialog.dart';
import '../custom_ui/show_delete_dialog.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Variables to hold the selected day and focused day
  // Initialize the selected day
  DateTime _focusedDay = DateTime.now();

  // Initialize the selected day
  DateTime? _selectedDay;

  // Controller instance for the menu
  late MenusController menuController;

  // Controller instance for allergies
  late AllergensController allergiesController;

  // Variables to hold menu items
  // Breakfast items
  List<MenuData> breakfastItems = [];

  // Breakfast desserts
  List<MenuData> breakfastDesserts = [];

  // Lunch items
  List<MenuData> lunchItems = [];

  // Lunch desserts
  List<MenuData> lunchDesserts = [];

  // Dinner items
  List<MenuData> dinnerItems = [];

  // Dinner desserts
  List<MenuData> dinnerDesserts = [];

  // Nutrition values
  List<int> nutritionValues = [];

  // Track loading state
  bool loading = false;

  // Generative model
  late final GenerativeModel model;

  // Chat session
  late final ChatSession chatSession;

  // Interstitial Ad Variable
  InterstitialAd? _interstitialAd;

  // BannerAd Variable
  BannerAd? _bannerAd;

  // Boolean variable to check if the ad is loaded
  bool _isLoaded = false;

  // Nutrition data
  List<NutritionData> _nutritionData = [];

  // Function to calculate daily nutrition
  Future<void> _calculateDailyNutrition() async {
    // Get the selected day
    DateTime selectedDay = _selectedDay!;

    // Fetch all items by date
    List<MenuData> allItems =
        await menuController.fetchItemsByDate(selectedDay);

    // Initialize the total nutrition values for calories
    int totalCalories = 0;

    // Initialize the total nutrition values for protein
    int totalProtein = 0;

    // Initialize the total nutrition values for fat
    int totalFat = 0;

    // Initialize the total nutrition values for carbohydrates
    int totalCarbs = 0;

    // Loop through all items
    for (var item in allItems) {
      // Add the calories
      totalCalories += item.calories;

      // Add the protein
      totalProtein += item.protein;

      // Add the fat
      totalFat += item.fat;

      // Add the carbohydrates
      totalCarbs += item.carbohydrate;
    }

    // Set the nutrition data
    setState(() {
      // Set the nutrition data
      _nutritionData = [
        // Nutrition data for calories
        NutritionData('calories'.tr(), totalCalories, Colors.purple),

        // Nutrition data for protein
        NutritionData('protein'.tr(), totalProtein, Colors.purple[300]!),

        // Nutrition data for fat
        NutritionData('fat'.tr(), totalFat, Colors.purple[200]!),

        // Nutrition data for carbohydrates
        NutritionData('carbohydrates'.tr(), totalCarbs, Colors.purple[100]!),
      ];
    });
  }

  @override
  void initState() {
    super.initState();

    // Call the createInterstitialAd method
    showInterstitialAd();

    // Call the createBannerAd method
    createBannerAd();

    // Call the createInterstitialAd method
    createInterstitialAd();

    // Initialize the generative model
    model = generativeModel();

    // Start chat session
    chatSession = model.startChat();

    // Initialize the controller
    menuController = MenusController(AppDatabase());

    // Initialize the allergies controller
    allergiesController = AllergensController(AppDatabase());

    // Get the current date
    DateTime now = DateTime.now();

    // Set the selected day and focused day to the current date
    _selectedDay = DateTime(now.year, now.month, now.day);

    // Set the focused day to the current date
    _focusedDay = DateTime(now.year, now.month, now.day);

    // Fetch menu items
    _fetchMenuItems();
  }

  @override
  void dispose() {
    // Dispose the interstitial ad
    _interstitialAd?.dispose();

    // Dispose the banner ad
    _bannerAd?.dispose();

    super.dispose();
  }

  // Function to create a banner ad
  void createBannerAd() {
    // Initialize the banner ad
    _bannerAd = BannerAd(
      // Ad unit ID for the banner ad
      size: AdSize.banner,

      // Ad unit ID for the banner ad
      adUnitId:  "API_KEY",

      // Banner ad listener
      listener: BannerAdListener(
        // Called when an ad is loaded
        onAdLoaded: (_) {
          // Set the isLoaded variable to true
          setState(() {
            _isLoaded = true;
          });
        },

        // Called when an ad is failed to load
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),

      // Ad
      request: const AdRequest(),
    );

    // Load the banner ad
    _bannerAd?.load();
  }

  // Create interstitial ad
  void createInterstitialAd() {
    // Initialize the interstitial ad
    InterstitialAd.load(
      // Set the ad unit id
      adUnitId:  "API_KEY",

      // Set the ad
      request: const AdRequest(),

      // Set the
      adLoadCallback: InterstitialAdLoadCallback(
        // Set the onAdLoaded
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later
          _interstitialAd = ad;
        },

        // Set the onAdFailedToLoad
        onAdFailedToLoad: (LoadAdError error) {
          // Print the error
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  // Method to show the interstitial ad
  void showInterstitialAd() {
    // Check if the interstitial ad is not null
    if (_interstitialAd != null) {
      // Show the ad if it is loaded
      _interstitialAd?.show();
      print('Showing Interstitial Ad');
    } else {
      // If ad is not loaded, print message
      print('InterstitialAd is not ready yet.');
    }
  }

  // Extract nutrition values from the response
  List<int> extractAverageNutritionValues(String response) {
    final RegExp regex = RegExp(r'\d+-\d+');
    final matches = regex.allMatches(response);

    return matches.map((match) {
      final range = match.group(0)!.split('-').map(int.parse).toList();
      return (range[0] + range[1]) ~/ 2;
    }).toList();
  }

  // Fetch menu items
  Future<void> _fetchMenuItems() async {
    // Set loading to true
    setState(() {
      loading = true;
    });
    // Get the selected day
    DateTime selectedDay = _selectedDay!;

    // Fetch menu items for breakfast, lunch, and dinner
    // Food items for breakfast
    breakfastItems = await menuController.fetchItemsByDateAndMeal(
        selectedDay, 'Food', 'Breakfast');

    // Desserts for breakfast
    breakfastDesserts = await menuController.fetchItemsByDateAndMeal(
        selectedDay, 'Dessert', 'Breakfast');

    // Food items for lunch
    lunchItems = await menuController.fetchItemsByDateAndMeal(
        selectedDay, 'Food', 'Lunch');

    // Desserts for lunch
    lunchDesserts = await menuController.fetchItemsByDateAndMeal(
        selectedDay, 'Dessert', 'Lunch');

    // Food items for dinner
    dinnerItems = await menuController.fetchItemsByDateAndMeal(
        selectedDay, 'Food', 'Dinner');

    // Desserts for dinner
    dinnerDesserts = await menuController.fetchItemsByDateAndMeal(
        selectedDay, 'Dessert', 'Dinner');

    await _calculateDailyNutrition();

    // Set loading to false
    setState(() {
      loading = false;
    });
  }

  // Save menu item
  Future<void> saveMenuItem(
    String itemType,
    String mealType,
    DateTime datetime,
    String content,
    String recipe,
    int calories,
    int protein,
    int fat,
    int carbs,
    bool isMenuDetailUpdate,
    bool isAllergensUpdated,
  ) async {
    // Insert menu item
    await menuController.insertMenu(
      itemType,
      mealType,
      datetime,
      content,
      recipe,
      calories,
      protein,
      fat,
      carbs,
      isMenuDetailUpdate,
      isAllergensUpdated,
    );
    await _fetchMenuItems(); // Add await here
  }

  // Update menu item
  Future<void> updateMenuItem(
      int id, String newContent, bool isMenuDetailUpdate) async {
    // Update menu item
    await menuController.updateMenuItem(id, newContent, isMenuDetailUpdate);

    // Fetch menu items
    _fetchMenuItems();
  }

  // Delete menu item
  Future<void> deleteMenuItem(int id) async {
    // Delete menu item
    await menuController.deleteMenuItem(id);

    // Fetch menu items
    _fetchMenuItems();
  }

  // Get title for meal type
  String _getTitleForMealType(String mealType) {
    // Switch case for meal type
    switch (mealType.toLowerCase()) {
      // Check if the meal type is breakfast
      case 'breakfast':
        return 'addItemForBreakfast'.tr();

      // Check if the meal type is lunch
      case 'lunch':
        return 'addItemForLunch'.tr();

      // Check if the meal type is dinner
      case 'dinner':
        return 'addItemForDinner'.tr();

      // Check if the meal type is other
      default:
        return 'addItemForOther'.tr();
    }
  }

  // Edit menu item
  Future<void> _editMenuItem(BuildContext context, MenuData item) async {
    // Create a text editing controller
    final TextEditingController controller =
        TextEditingController(text: item.content);

    // Show dialog
    return showDialog(
      context: context,
      builder: (context) {
        // Return alert dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),

          // Set title
          title: Text(
            'editMenuItem'.tr(),
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),

          // Set content
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: controller,

              // Set input decoration
              decoration: InputDecoration(
                hintText: 'enterUpdatedItem'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),

                // Set focused border
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.purple),
                ),
              ),

              // Set style
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Set actions
          actions: <Widget>[
            // Set text button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              // Cancel button
              child: const Text(
                'cancel',
                style: TextStyle(fontSize: 16.0, color: Colors.purple),
              ).tr(),
            ),

            // Press edit button
            ElevatedButton.icon(
              onPressed: () async {
                // If the controller text is not empty
                if (controller.text.isNotEmpty) {
                  // Update menu item
                  await updateMenuItem(item.id, controller.text, true);

                  // Pop the context
                  Navigator.of(context).pop();
                }
              },

              // Set icon
              icon: const Icon(Icons.update, color: Colors.white),

              // Set label
              label: const Text('updateItem', style: TextStyle(fontSize: 16.0))
                  .tr(),

              // Set style
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add menu item
  Future<void> _addMenuItem(
      BuildContext context, String mealType, String itemType) async {
    // Create a text editing controller
    final TextEditingController contentController = TextEditingController();

    // Show dialog
    await showDialog(
      context: context,
      builder: (context) {
        // Return alert dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),

          // Set title for meal type
          title: Text(
            _getTitleForMealType(mealType.tr()),
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          // Set content
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'content'.tr(),
                    hintText: 'enterMenuItem'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Set actions
          actions: [
            // Set text button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('cancel').tr(),
            ),

            // Press add item button
            ElevatedButton(
              onPressed: () async {
                // If the content controller text is not empty
                if (contentController.text.isNotEmpty) {
                  // Split the content controller text by comma
                  final content = contentController.text;

                  // Save menu item
                  await saveMenuItem(itemType, mealType, _selectedDay!, content,
                      "", 0, 0, 0, 0, false, false);

                  // Pop the context
                  Navigator.of(context).pop();
                }
              },

              // Set text
              child: const Text('addItem').tr(),
            ),
          ],
        );
      },
    );
  }

  // Build meal section
  Widget _buildMealSection(String title, List<MenuData> items, String mealType,
      {bool isDessert = false}) {
    // Set item type
    final itemType = isDessert ? 'Dessert' : 'Food';

    // Return padding
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Set title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontFamily: 'Roboto',
            ),
          ),

          // Give space
          const SizedBox(height: 8.0),

          // Show list view
          ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // Get item
              final item = items[index];

              // Return padding
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  // Set decoration
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple.shade300),
                    borderRadius: BorderRadius.circular(12.0),

                    // Set gradient
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade500,
                        Colors.purple.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  // Set list tile
                  child: ListTile(
                    title: Text(
                      // Get content
                      item.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Get recipe
                    trailing: IconButton(
                        icon: const Icon(Icons.receipt_long_outlined,
                            color: Colors.white),
                        onPressed: () async {
                          // Check if the widget is mounted
                          if (!mounted) return;

                          // Fetch the allergens
                          List<Allergen> allergen =
                              await allergiesController.fetchAllergensItems();

                          // Ask the AI for the recipe
                          String askRecipe =
                              'whatIsRecipe'.tr(args: [item.content]);

                          // Ask the AI for the nutrition values
                          String askNutrition =
                              'askNutrition'.tr(args: [item.content]);

                          // Check if the allergen is not empty
                          if (allergen.isNotEmpty) {
                            // Get the allergen string
                            String allergenString =
                                allergen.map((e) => e.allergens).join(', ');

                            // Ask the AI for the recipe without allergens
                            askRecipe = 'whatIsRecipeWithoutAllergen'.tr(
                              args: [item.content, allergenString],
                            );

                            // Ask the AI for the nutrition values without allergens
                            askNutrition = 'askNutritionWithoutAllergen'.tr(
                              args: [item.content, allergenString],
                            );
                          }

                          // Check if the recipe exists for the item in the database
                          if (item.recipe.isNotEmpty &&
                              !item.isMenuDetailUpdate &&
                              !item.isAllergensUpdated) {
                            // Show the existing recipe in a dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return recipeDialog(
                                  context: context,
                                  title: 'recipe'.tr(),
                                  content: item.recipe,
                                );
                              },
                            );

                            return;
                          }

                          showAdDialog(context, () async {
                            // Create interstitial ad
                            showInterstitialAd();

                            // Show a loading dialog while fetching the recipe
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                // Return alert dialog for fetching recipe
                                return recipeDialog(
                                  context: context,
                                  title: 'searchingForRecipe'.tr(),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(height: 16),
                                      Text('waitForRecipe'.tr()),
                                    ],
                                  ),
                                );
                              },
                            );

                            try {
                              // Fetch the recipe from the AI
                              final response = await chatSession.sendMessage(
                                Content.text(askRecipe),
                              );

                              // Fetch the calories, protein, fat, and carbs from the AI
                              final nutritionResponse = await chatSession
                                  .sendMessage(Content.text(askNutrition));

                              // Check if the nutrition response is not empty
                              if (nutritionResponse.text != null) {
                                // Extract the average nutrition values
                                nutritionValues = extractAverageNutritionValues(
                                    nutritionResponse.text!.replaceAll('*', ''));
                              }

                              // Check if the widget is mounted
                              if (!mounted) return;

                              // If the response is not empty
                              if (response.text != null &&
                                  response.text!.isNotEmpty) {
                                // Separate the response by comma
                                String newRecipe =
                                    response.text!.replaceAll('*', '');

                                // If all nutrition values are 0 or empty, do not update
                                bool isNutritionValid =
                                    nutritionValues.any((value) => value > 0);

                                // Update the database with the new recipe
                                if (isNutritionValid) {
                                  // Update the database with the new recipe
                                  await menuController.updateMenuDetails(
                                    item.id,
                                    newRecipe,
                                    false,
                                    nutritionValues[0],
                                    // Calories
                                    nutritionValues[1],
                                    // Protein
                                    nutritionValues[2],
                                    // Fat
                                    nutritionValues[3],
                                    // Carbs
                                    false,
                                  );
                                } else {
                                  // If the nutrition values are not valid, do not update
                                  await menuController.updateMenuDetails(
                                    item.id,
                                    newRecipe,
                                    false,
                                    0,
                                    // Calories
                                    0,
                                    // Protein
                                    0,
                                    // Fat
                                    0,
                                    // Carbs
                                    false,
                                  );
                                }

                                // Refresh the menu items (or fetch the updated menu again)
                                await _fetchMenuItems();

                                // Close the loading dialog
                                Navigator.pop(context);

                                // Show the new recipe in a dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return recipeDialog(
                                      context: context,
                                      title: 'recipe'.tr(),
                                      content: newRecipe,
                                    );
                                  },
                                );
                              } else {
                                // Handle the case where AI returns an empty response
                                Navigator.pop(
                                    context); // Close the loading dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    // Return alert dialog for no recipe found
                                    return recipeDialog(
                                      context: context,
                                      title: 'noRecipeFound'.tr(),
                                      content: 'aiCouldNotFindRecipe'.tr(),
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              // Handle the case where there is no internet connection
                              Navigator.pop(context);

                              // Show dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  // Return alert dialog for no internet connection
                                  return recipeDialog(
                                    context: context,
                                    title: 'noRecipeFound'.tr(),
                                    content: 'aiCouldNotFindRecipe'.tr(),
                                  );
                                },
                              );
                            }
                          });
                        }),

                    // Edit item
                    onTap: () {
                      // Edit menu item
                      _editMenuItem(context, item);
                    },

                    // Delete item
                    onLongPress: () {
                      // Show delete dialog
                      showDeleteDialog(context, "deleteItem".tr(),
                          "delete".tr(), "cancel".tr(), () {
                        // Delete menu item
                        deleteMenuItem(item.id);

                        // Pop the context
                        Navigator.of(context).pop();
                      }, () {
                        // Pop the context
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              );
            },
          ),

          // Add text button
          TextButton(
            // Add item
            onPressed: () => _addMenuItem(context, mealType, itemType),

            child: Text("add".tr(args: [title])),
          ),
        ],
      ),
    );
  }

// Build method
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.food_bank_outlined),
              ),
              Tab(
                icon: Icon(Icons.dashboard_outlined),
              ),
            ],
          ),
          toolbarHeight: 0, // Reduce the height of the AppBar
        ),
        // Make it scrollable
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      headerVisible: false,
                      firstDay:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDay: DateTime.now().add(const Duration(days: 30)),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.week,
                      locale: context.locale.toString(),
                      pageJumpingEnabled: false,
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Color(0xff6a0dad),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: TextStyle(
                          color: Color(0xff9370db),
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color(0xff9370db),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: Color(0xffd8bfd8),
                        ),
                        selectedTextStyle: TextStyle(
                          color: Color(0xffe6e6fa),
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        // Return is same day
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        // Set state
                        setState(() {
                          // Set selected day
                          _selectedDay = DateTime(selectedDay.year,
                              selectedDay.month, selectedDay.day);

                          // Set focused day
                          _focusedDay = DateTime(focusedDay.year,
                              focusedDay.month, focusedDay.day);
                        });

                        // Fetch menu items
                        _fetchMenuItems();
                      },
                      onPageChanged: (focusedDay) {
                        // Set focused day
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  // Show loading spinner while fetching data
                  if (loading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Column(
                      children: [
                        // Breakfast items
                        _buildMealSection(
                            'breakfast'.tr(), breakfastItems, 'Breakfast'),

                        // Breakfast desserts
                        _buildMealSection('breakfastSnacks'.tr(),
                            breakfastDesserts, 'Breakfast',
                            isDessert: true),

                        // Lunch items
                        _buildMealSection('lunch'.tr(), lunchItems, 'Lunch'),

                        // Lunch desserts
                        _buildMealSection(
                            'lunchSnacks'.tr(), lunchDesserts, 'Lunch',
                            isDessert: true),

                        // Dinner items
                        _buildMealSection('dinner'.tr(), dinnerItems, 'Dinner'),

                        // Dinner desserts
                        _buildMealSection(
                            'dinnerSnacks'.tr(), dinnerDesserts, 'Dinner',
                            isDessert: true),
                      ],
                    ),
                ],
              ),
            ),

	    // Nutrition Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: _calculateDailyNutrition(),
                builder: (context, snapshot) {
                  if (_nutritionData.isEmpty) {
                    return Center(
                      child: Text(
                        'noNutritionData'.tr(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Text(
                        'dailyNutrition'.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: buildNutritionChart(_nutritionData)),
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ),
          ],
        ),

        // Add floating action button for asking AI for what can i make with existing items
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
                context: context,
                showDragHandle: true,
                enableDrag: true,
                clipBehavior: Clip.antiAlias,
                builder: (BuildContext build) {
                  return const AiPage();
                });
          },
          child: const Icon(
            Icons.emoji_food_beverage,
          ),
        ),

        // Display the banner ad at the bottom
        bottomNavigationBar: _isLoaded
            ? SizedBox(
          height: _bannerAd!.size.height.toDouble(),
          width: _bannerAd!.size.width.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        )
            : const SizedBox(),
      ),
    );
  }
}

