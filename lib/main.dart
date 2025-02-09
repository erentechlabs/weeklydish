import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:weeklydish/theme/theme.dart';
import 'package:weeklydish/view/others/nav_page.dart';
import 'package:intl/date_symbol_data_local.dart';

// App Open Ad
AppOpenAd? appOpenAd;

// Load the app open ad
loadAppOpenAdd() {
  AppOpenAd.load(
      adUnitId: "ca-app-pub-6150876719010892/1317100809",
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            appOpenAd = ad;
            appOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}));
}

void main() async {
  // This is required to initialize the date formatting for the app
  WidgetsFlutterBinding.ensureInitialized();

  // This is required to initialize the localization for the app
  await EasyLocalization.ensureInitialized();

  // Adding the date formatting for Turkish
  await initializeDateFormatting('tr', null);

  // Adding the date formatting for English
  await initializeDateFormatting('en', null);

  // Adding the date formatting for German
  await initializeDateFormatting('de', null);

  // Adding the date formatting for Spanish
  await initializeDateFormatting('es', null);

  // Adding the date formatting for French
  await initializeDateFormatting('fr', null);

  // Adding the date formatting for Italian
  await initializeDateFormatting('it', null);

  // Adding the date formatting for Japanese
  await initializeDateFormatting('ja', null);

  // Adding the date formatting for Korean
  await initializeDateFormatting('ko', null);

  // Adding the date formatting for Russian
  await initializeDateFormatting('ru', null);

  // Admob initialization
  await MobileAds.instance.initialize();

  // Load the app open ad
  // loadAppOpenAdd();

  // Running the app
  runApp(EasyLocalization(

      // Localization
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
        Locale('ja'),
        Locale('ko'),
        Locale('ru'),
        Locale('tr')
      ],

      // Path of the translation files
      path: 'assets/translations',

      // Fallback Locale
      fallbackLocale: const Locale('en'),

      // Child
      child: const WeeklyDish()));
}

class WeeklyDish extends StatelessWidget {
  const WeeklyDish({super.key});

  // This is the default theme for the app
  final materialTheme = const MaterialTheme(TextTheme());

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      // Light Theme
      light: materialTheme.light(),

      // Dark Theme
      dark: materialTheme.dark(),

      // Initial Theme
      initial: AdaptiveThemeMode.system,

      // Builder
      builder: (theme, darkTheme) => MaterialApp(
        // Close the debug banner
        debugShowCheckedModeBanner: false,

        // Localization
        localizationsDelegates: context.localizationDelegates,

        // Supported Locales
        supportedLocales: context.supportedLocales,

        // Locale
        locale: context.locale,

        // Title of the app
        title: 'Weekly Dish',

        // Theme
        theme: theme,

        // Dark Theme
        darkTheme: darkTheme,

        // Home page
        home: const NavPage(),
      ),
    );
  }
}
