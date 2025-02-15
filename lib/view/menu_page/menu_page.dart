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
import '../custom_ui/per_item_nutrition_chart.dart';
import '../custom_ui/total_nutrition_chart.dart';
import '../custom_ui/recipe_dialog.dart';
import '../custom_ui/show_delete_dialog.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  // Variables to hold the selected day and focused day
  // Initialize the selected day
  DateTime _focusedDay = DateTime.now();

  // Initialize the selected day
  DateTime? _selectedDay;

  // Controller instance for the menu
  late MenusController menuController;

  // Controller instance for allergies
  late AllergensController allergiesController;

  // Tabbar controller
  late TabController _tabController;

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

  // Refresh button enabled
  bool isRefreshButtonEnabled = true;

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
  // Function to calculate daily nutrition
  Future<void> _calculateDailyNutrition() async {
    // Get the selected day
    DateTime selectedDay = _selectedDay!;

    // Fetch all items by date
    List<MenuData> allItems = await menuController.fetchItemsByDate(
      selectedDay,
    );

    // Initialize the total nutrition values for calories
    int totalCalories = 0;

    // Initialize the total nutrition values for protein
    int totalProtein = 0;

    // Initialize the total nutrition values for fat
    int totalFat = 0;

    // Initialize the total nutrition values for carbohydrates
    int totalCarbs = 0;

    // Initialize the list to hold nutrition data
    List<NutritionData> nutritionDataList = [];

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

      // Add the item nutrition data to the list
      nutritionDataList.add(
        NutritionData(
          item.content,
          item.calories,
          Colors.purple,
          mealName: item.mealType,
          calories: item.calories,
          fat: item.fat,
          carbohydrates: item.carbohydrate,
          protein: item.protein,
        ),
      );
    }

    // Set the nutrition data
    setState(() {
      // Set the nutrition data
      _nutritionData = nutritionDataList;
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize the tab controller
    _tabController = TabController(length: 2, vsync: this);

    // Add listener to the tab controller for controlling the refresh button
    _tabController.addListener(_handleTabChange);

    // Initialize the generative model
    model = generativeModel();

    // Start chat session
    chatSession = model.startChat();

    // Call the createInterstitialAd method
    showInterstitialAd();

    // Call the createBannerAd method
    createBannerAd();

    // Call the createInterstitialAd method
    createInterstitialAd();

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
    // Dispose the tab controller
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();

    // Dispose the interstitial ad
    _interstitialAd?.dispose();

    // Dispose the banner ad
    _bannerAd?.dispose();

    super.dispose();
  }

  // Handle tab change
  void _handleTabChange() {
    // Check if the tab controller index is 0
    if (_tabController.index == 1) {
      // Set the refresh button enabled to true
      setState(() => isRefreshButtonEnabled = false);
    } else {
      // Set the refresh button enabled to false
      setState(() => isRefreshButtonEnabled = true);
    }
    debugPrint("Refresh: $isRefreshButtonEnabled");
  }

  // Function to create a banner ad
  void createBannerAd() {
    // Initialize the banner ad
    _bannerAd = BannerAd(
      // Ad unit ID for the banner ad
      size: AdSize.banner,

      // Ad unit ID for the banner ad
      adUnitId: "API_KEY",

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
      adUnitId: "API_KEY",

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
    }
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
      selectedDay,
      'Food',
      'Breakfast',
    );

    // Desserts for breakfast
    breakfastDesserts = await menuController.fetchItemsByDateAndMeal(
      selectedDay,
      'Dessert',
      'Breakfast',
    );

    // Food items for lunch
    lunchItems = await menuController.fetchItemsByDateAndMeal(
      selectedDay,
      'Food',
      'Lunch',
    );

    // Desserts for lunch
    lunchDesserts = await menuController.fetchItemsByDateAndMeal(
      selectedDay,
      'Dessert',
      'Lunch',
    );

    // Food items for dinner
    dinnerItems = await menuController.fetchItemsByDateAndMeal(
      selectedDay,
      'Food',
      'Dinner',
    );

    // Desserts for dinner
    dinnerDesserts = await menuController.fetchItemsByDateAndMeal(
      selectedDay,
      'Dessert',
      'Dinner',
    );

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
    int id,
    String newContent,
    bool isMenuDetailUpdate,
  ) async {
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
    final TextEditingController controller = TextEditingController(
      text: item.content,
    );

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
              child:
                  const Text(
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
              label:
                  const Text(
                    'updateItem',
                    style: TextStyle(fontSize: 16.0),
                  ).tr(),

              // Set style
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
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
    BuildContext context,
    String mealType,
    String itemType,
  ) async {
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
                  await saveMenuItem(
                    itemType,
                    mealType,
                    _selectedDay!,
                    content,
                    "",
                    0,
                    0,
                    0,
                    0,
                    false,
                    false,
                  );

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

  // Function to extract nutrition values from the AI response
  List<int> extractNutritionValues(String response) {
    final List<int> nutritionValues = [];
    final RegExp regex = RegExp(r'(\d+)');
    final matches = regex.allMatches(response);

    for (final match in matches) {
      final value = int.parse(match.group(1)!);
      nutritionValues.add(value);
    }

    return nutritionValues;
  }

  // Function to update all items nutrition
  Future<void> updateAllItemsNutrition() async {
    if (!mounted) return;

    // Fetch all menu items for the selected date
    List<MenuData> allItems = await menuController.fetchItemsByDate(
      _selectedDay!,
    );

    for (MenuData item in allItems) {
      // Ask the AI for the nutrition values
      String askNutrition = 'askNutrition'.tr(args: [item.content]);

      try {
        // Fetch the calories, protein, fat, and carbs from the AI
        final nutritionResponse = await chatSession.sendMessage(
          Content.text(askNutrition),
        );

        String response = nutritionResponse.text!.replaceAll(
          RegExp(r'\*+'),
          '',
        );
        debugPrint("Nutrition response: $response");

        if (nutritionResponse.text != null) {
          // Extract the nutrition values from the response
          final nutritionValues = extractNutritionValues(response);

          // Check if at least one nutrition value is valid
          if (nutritionValues.isNotEmpty) {
            // Assign the nutrition values based on the order
            final calories =
                nutritionValues.isNotEmpty ? nutritionValues[0] : 0;
            final protein = nutritionValues.length > 1 ? nutritionValues[1] : 0;
            final fat = nutritionValues.length > 2 ? nutritionValues[2] : 0;
            final carbohydrates =
                nutritionValues.length > 3 ? nutritionValues[3] : 0;

            // Update the database with the new nutrition values
            await menuController.updateMenuDetails(
              item.id,
              item.recipe, // Keep the existing recipe
              false,
              calories, // Calories
              protein, // Protein
              fat, // Fat
              carbohydrates, // Carbs
              false,
            );
          }
        }
      } catch (e) {
        debugPrint("Error fetching nutrition for ${item.content}: $e");
      }
    }

    // Refresh the menu items
    await _fetchMenuItems();
  }

  // Show recipe dialog
  Future<void> fetchAndShowRecipe(BuildContext context, MenuData item) async {
    // Check if the widget is mounted
    if (!mounted) return;

    // Fetch the allergens
    List<Allergen> allergen = await allergiesController.fetchAllergensItems();

    // Ask the AI for the recipe
    String askRecipe = 'whatIsRecipe'.tr(args: [item.content]);

    // Check if the allergen is not empty
    if (allergen.isNotEmpty) {
      // Get the allergen string
      String allergenString = allergen.map((e) => e.allergens).join(', ');

      // Ask the AI for the recipe without allergens
      askRecipe = 'whatIsRecipeWithoutAllergen'.tr(
        args: [item.content, allergenString],
      );
    }

    // Check if the recipe exists for the item in the database
    if (item.recipe.isNotEmpty &&
        !item.isMenuDetailUpdate &&
        !item.isAllergensUpdated) {
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
      showInterstitialAd();

      // Show a loading dialog while fetching the recipe
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
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
        final response = await chatSession.sendMessage(Content.text(askRecipe));

        // Check if the widget is mounted
        if (!mounted) return;

        // If the response is not empty
        if (response.text != null && response.text!.isNotEmpty) {
          // Clean up the response
          String newRecipe = response.text!.replaceAll(RegExp(r'\*+'), '');

          // Update the database with the new recipe
          await menuController.updateMenuDetails(
            item.id,
            newRecipe,
            false,
            0, // Calories
            0, // Protein
            0, // Fat
            0, // Carbs
            false,
          );

          // Refresh the menu items
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
          Navigator.pop(context); // Close the loading dialog
          showDialog(
            context: context,
            builder: (context) {
              return recipeDialog(
                context: context,
                title: 'noRecipeFound'.tr(),
                content: 'aiCouldNotFindRecipe'.tr(),
              );
            },
          );
        }
      } catch (e) {
        // Handle errors (e.g., no internet connection)
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return recipeDialog(
              context: context,
              title: 'somethingWentWrong'.tr(),
              content: 'pleaseTryLater'.tr(),
            );
          },
        );
      }
    });
  }

  // Build meal section
  Widget _buildMealSection(
    String title,
    List<MenuData> items,
    String mealType, {
    bool isDessert = false,
  }) {
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
                      colors: [Colors.purple.shade500, Colors.purple.shade700],
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
                      icon: const Icon(
                        Icons.receipt_long_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await fetchAndShowRecipe(context, item);
                      },
                    ),

                    // Edit item
                    onTap: () {
                      // Edit menu item
                      _editMenuItem(context, item);
                    },

                    // Delete item
                    onLongPress: () {
                      // Show delete dialog
                      showDeleteDialog(
                        context,
                        "deleteItem".tr(),
                        "delete".tr(),
                        "cancel".tr(),
                        () {
                          // Delete menu item
                          deleteMenuItem(item.id);

                          // Pop the context
                          Navigator.of(context).pop();
                        },
                        () {
                          // Pop the context
                          Navigator.of(context).pop();
                        },
                      );
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.food_bank_outlined)),
              Tab(icon: Icon(Icons.dashboard_outlined)),
            ],
          ),

          // Reduce the height of the AppBar
          toolbarHeight: 0,
        ),
        // Make it scrollable
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      headerVisible: false,
                      firstDay: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
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
                        weekendTextStyle: TextStyle(color: Color(0xff9370db)),
                        selectedDecoration: BoxDecoration(
                          color: Color(0xff9370db),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(color: Color(0xffd8bfd8)),
                        selectedTextStyle: TextStyle(color: Color(0xffe6e6fa)),
                      ),
                      selectedDayPredicate: (day) {
                        // Return is same day
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        // Set state
                        setState(() {
                          // Set selected day
                          _selectedDay = DateTime(
                            selectedDay.year,
                            selectedDay.month,
                            selectedDay.day,
                          );

                          // Set focused day
                          _focusedDay = DateTime(
                            focusedDay.year,
                            focusedDay.month,
                            focusedDay.day,
                          );
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
                          'breakfast'.tr(),
                          breakfastItems,
                          'Breakfast',
                        ),

                        // Breakfast desserts
                        _buildMealSection(
                          'breakfastSnacks'.tr(),
                          breakfastDesserts,
                          'Breakfast',
                          isDessert: true,
                        ),

                        // Lunch items
                        _buildMealSection('lunch'.tr(), lunchItems, 'Lunch'),

                        // Lunch desserts
                        _buildMealSection(
                          'lunchSnacks'.tr(),
                          lunchDesserts,
                          'Lunch',
                          isDessert: true,
                        ),

                        // Dinner items
                        _buildMealSection('dinner'.tr(), dinnerItems, 'Dinner'),

                        // Dinner desserts
                        _buildMealSection(
                          'dinnerSnacks'.tr(),
                          dinnerDesserts,
                          'Dinner',
                          isDessert: true,
                        ),
                      ],
                    ),

                  // Give space
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Nutrition Tab
            Padding(
              // Padding
              padding: const EdgeInsets.all(16.0),

              // Future builder
              child: FutureBuilder(
                // Calculate daily nutrition
                future: _calculateDailyNutrition(),

                // Builder method
                builder: (context, snapshot) {
                  // Check if the snapshot has data
                  if (_nutritionData.isEmpty) {
                    // Return center widget for no food in list
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text widget for no food in list
                          Text(
                            'noFoodinList'.tr(),
                            style: const TextStyle(fontSize: 18),
                          ),

                          // Give space
                          const SizedBox(height: 10),

                          // Icon widget for no food in list
                          const Icon(
                            Icons.no_food_outlined,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  }

                  // Return safe area
                  return SafeArea(
                    // Custom scroll view
                    child: CustomScrollView(
                      // Slivers for the scroll view
                      slivers: [
                        // Sliver app bar for the nutrition page
                        SliverAppBar(
                          pinned: true,
                          floating: false,
                          expandedHeight: 100.0,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text widget for daily nutrition
                                Flexible(
                                  child: Text(
                                    'dailyNutrition'.tr(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () async {
                                    // Show interstitial ad
                                    showInterstitialAd();

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        // Return alert dialog
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Circular progress indicator
                                              const CircularProgressIndicator(),

                                              // Give space
                                              const SizedBox(height: 16),

                                              // Text widget for updating
                                              const Text('updatingList').tr(),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    try {
                                      // Update all items nutrition
                                      await updateAllItemsNutrition();
                                    } finally {
                                      // Pop the context after updating
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Sliver fill remaining
                        SliverFillRemaining(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: PageView(
                              scrollDirection: Axis.vertical,
                              children: [
                                // SizedBox for horizontal nutrition bar
                                SizedBox(
                                  height: 220,
                                  child: PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _nutritionData.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: perItemNutritionBar(
                                          _nutritionData[index],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // SizedBox for nutrition chart
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: totalNutritionChart(
                                          _nutritionData,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Add floating action button for asking AI for what can i make with existing items
        floatingActionButton:
            isRefreshButtonEnabled
                ? FloatingActionButton(
                  onPressed: () {
                    // Show the bottom sheet for opening the AI page
                    showBottomSheet(
                      context: context,
                      showDragHandle: true,
                      enableDrag: true,
                      clipBehavior: Clip.antiAlias,
                      builder: (BuildContext build) {
                        return const AiPage();
                      },
                    );
                  },
                  child: const Icon(Icons.emoji_food_beverage),
                )
                : null,

        // Display the banner ad at the bottom
        bottomNavigationBar:
            _isLoaded
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
