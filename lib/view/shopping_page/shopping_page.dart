import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:weeklydish/view/shopping_page/take_note_page.dart';
import 'package:weeklydish/controller/shopping_controller.dart';
import '../../database/app_database.dart';
import '../custom_ui/show_delete_dialog.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // Shopping controller to interact with the database
  late ShoppingController shoppingController;

  // BannerAd Variable
  BannerAd? _bannerAd;

  // Boolean variable to check if the ad is loaded
  bool _isLoaded = false;

  @override
  void initState() {
    // Call the super class initState method
    super.initState();

    // Call the createBannerAd method
    createBannerAd();

    // Initialize the ShoppingController with the database instance
    shoppingController = ShoppingController(AppDatabase());
  }

  // Dispose the banner ad
  @override
  void dispose() {
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
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-6150876719010892/6480074053'
          : 'ca-app-pub-6150876719010892/6478976570',

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

  // Function to fetch shopping items from the database
  Future<List<ShoppingData>> fetchShoppingItems() async {
    return await shoppingController.fetchShoppingItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ShoppingData>>(
        // Fetch shopping items from the database
        future: fetchShoppingItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ShoppingData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a progress indicator while fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if an error occurs
            return Center(
              child: Text('error'.tr(args: [snapshot.error.toString()])),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Display a message if there are no shopping items
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.note_add_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const Text(
                    'takeANote',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ).tr(),
                ],
              ),
            );
          }

          // List of shopping items fetched from the database
          final shoppingItems = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add some space at the top
                Padding(
                  padding: const EdgeInsets.all(18.0),

                  // Display the title
                  child: Text(
                    'shoppingList',
                    style: const TextStyle(fontSize: 24).copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ).tr(),
                ),

                // Display the shopping items in a ListView
                ListView.builder(
                  shrinkWrap: true,
                  // Disable scrolling in ListView
                  physics: const NeverScrollableScrollPhysics(),
                  // Display shopping items
                  itemCount: shoppingItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Shopping item at the current index
                    final item = shoppingItems[index];

                    // Decode the shopping list
                    var documentJson = jsonDecode(item.shoppingList);

                    // Create a Quill document from the JSON
                    var document = Document.fromJson(documentJson);

                    // Get plain text from the document
                    String plainText = document
                        .toPlainText()
                        .trim()
                        .replaceAll(RegExp(r'\s+'), ' ');
                    // Display the shopping item in a card
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      // Display the shopping item
                      child: ListTile(
                        onTap: () async {
                          // Navigate to the TakeNotePage with the note data
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakeNotePage(
                                noteId: item.id,
                                noteTitle: item.title,
                                noteBody: item.shoppingList,
                              ),
                            ),
                          );

                          // If the result is true, refresh the shopping list
                          if (result == true) {
                            setState(() {
                              // Fetch the updated list
                            });
                          }
                        },

                        // Show a dialog to delete the item on long press
                        onLongPress: () {
                          showDeleteDialog(context, "deleteItem".tr(),
                              "delete".tr(), "cancel".tr(), () {
                            setState(() {
                              shoppingController.deleteShoppingItem(item.id);
                            });
                            Navigator.of(context).pop();
                          }, () {
                            Navigator.of(context).pop();
                          });
                        },

                        // Display the shopping items first letter in a circle
                        leading: CircleAvatar(
                          child: Text(
                            item.title[0],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Display the title (plain text)
                        title: Text(
                          item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),

                        // Display the shopping text in the subtitle
                        subtitle: Text(
                          plainText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward_outlined, size: 16),
                      ),
                    );
                  },
                ),

                // Add some space at the bottom
                const SizedBox(height: 80.0),
              ],
            ),
          );
        },
      ),

      // Floating action button to navigate to the note page
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the TakeNotePage and wait for the result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TakeNotePage()),
          );

          // If the result is true, refresh the shopping list
          if (result == true) {
            setState(() {
              // Fetch the updated list
            });
          }
        },

        // Display an edit icon
        child: const Icon(Icons.edit_outlined),
      ),

      // Display the banner ad at the bottom
      bottomNavigationBar: _isLoaded
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox(),
    );
  }
}
