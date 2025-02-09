import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../extension/generative_model.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  // Input text from the user for the AI model
  final TextEditingController controller = TextEditingController();

  // AI model
  late final GenerativeModel model;

  // Chat session with the AI model
  late final ChatSession chatSession;

  // Loading indicator
  bool isLoading = false;

  // Responses from the AI model
  String responses = "";

  // Interstitial Ad Variable
  InterstitialAd? _interstitialAd;

  // Counter for interstitial ad
  int counter = 0;

  // Initialize the AI model and chat session
  @override
  void initState() {
    super.initState();

    // Call the createInterstitialAd method
    createInterstitialAd();

    // Initialize the AI model
    model = generativeModel();

    // Dispose the interstitial ad
    _interstitialAd?.dispose();

    // Start a chat session with the AI model
    chatSession = model.startChat();
  }

  @override
  void dispose() {
    // Dispose the interstitial ad
    _interstitialAd?.dispose();

    super.dispose();
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

  // Send the user message to the AI model
  void sendMessage() async {
    // Increment the counter
    counter++;

    // If the counter is 3, show the interstitial ad and reset the counter
    if (counter == 3) {
      showInterstitialAd();
      counter = 0;
    }

    // Show the loading indicator
    setState(() {
      isLoading = true;
    });

    // Get the user message
    final userMessage = controller.text;

    // Clear the input field
    controller.clear();

    try {
      // Check if the user message is not empty
      if (userMessage.isNotEmpty) {
        // Send the user message to the AI model
        final response =
            await chatSession.sendMessage(Content.text(userMessage));

        // Update the responses from the AI model
        setState(() {
          // Hide the loading indicator
          isLoading = false;

          // Show the responses from the AI model
          responses = response.text!.replaceAll('*', '');
        });
      } else {
        // Hide the loading indicator
        setState(() {
          // Hide the loading indicator
          isLoading = false;

          // Show an error message
          responses = "discoverAI".tr();
        });
      }
    } catch (e) {
      // Handle any errors
      setState(() {
        // Hide the loading indicator
        isLoading = false;

        // Show an error message
        responses = "aiError".tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Give some space at the top
          const SizedBox(height: 20),

          // Loading indicator or result list
          Expanded(
            // Show the loading indicator while waiting for the AI model
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      // Show the responses from the AI model
                      child: cardViewer(
                        // Show the initial text if the
                        responses.isEmpty

                            // Initial text shown at the beginning
                            ? "discoverAI".tr()

                            // Answer from the AI model
                            : responses,
                      ),
                    ),
                  ),
          ),

          // Input field and submit button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Input field for the user message
                Expanded(
                  child: TextField(
                    // Get the user message
                    controller: controller,

                    // Style the input field
                    decoration: InputDecoration(
                      hintText: 'enterYourTextHere'.tr(),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),

                // Give some space between the input field and the button
                const SizedBox(width: 8),

                // Submit button
                ElevatedButton(
                  // Send the user message to the AI model
                  onPressed: sendMessage,

                  // Style the button
                  child: const Text('submit').tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show the responses from the AI model in a card
  Card cardViewer(String text) {
    // Show the responses from the AI model in a card
    return Card(
      // Give some margin around the card
      margin: const EdgeInsets.symmetric(vertical: 8.0),

      // Show the responses from the AI model
      child: Padding(
        // Give some padding inside the card
        padding: const EdgeInsets.all(16.0),

        // Show the responses from the AI model in the center
        child: Center(
          // Show the responses from the AI model
          child: Text(
            // Show the responses from the AI model
            text,

            // Center the text
            textAlign: TextAlign.center,

            // Style the text
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
