import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:launch_app_store/launch_app_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum ThemeMode { light, dark, system }

class _SettingsPageState extends State<SettingsPage> {
  // Default theme mode is system
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  // Load the saved theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    setState(() {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString().split('.').last == themeModeString,
        orElse: () => ThemeMode.system,
      );
    });
  }

  // Save the theme mode to shared preferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }

  // Update theme mode and save the selection
  void _updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      if (mode == ThemeMode.system) {
        AdaptiveTheme.of(context).setSystem();
      } else if (mode == ThemeMode.light) {
        AdaptiveTheme.of(context).setLight();
      } else {
        AdaptiveTheme.of(context).setDark();
      }
      _saveThemeMode(mode);
    });
  }

  // Generic button for theme selection
  Widget _themeModeButton(ThemeMode mode, String label, IconData icon) {
    return Card(
      color: _themeMode == mode
          ? (mode == ThemeMode.light
              ? const Color(0xffeab5ed)
              : const Color(0xff300938))
          : null,
      child: TextButton.icon(
        icon: Icon(icon),
        onPressed: _themeMode == ThemeMode.system
            ? null
            : () => _updateThemeMode(mode),
        label: Text(label),
      ),
    );
  }

  // Generic settings section
  Widget _settingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("settings").tr(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "systemTheme".tr(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _themeMode == ThemeMode.system,
                  onChanged: (bool value) {
                    _updateThemeMode(
                        value ? ThemeMode.system : _getOppositeThemeMode());
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Theme mode buttons
                _themeModeButton(
                    ThemeMode.light, "lightMode".tr(), Icons.light_mode),
                _themeModeButton(
                    ThemeMode.dark, "darkMode".tr(), Icons.dark_mode),
              ],
            ),
          ),
          _settingsSection(
            "moreSettings".tr(),
            [
              _settingsButton(
                  "manageSubscription".tr(), Icons.person_2_outlined, () {}),
              _settingsButton(
                  "giveFeedback".tr(), Icons.feedback_outlined, () {}),
              _settingsButton("rateUs".tr(), Icons.reviews_outlined, () {
                LaunchReview.launch(androidAppId: "", iOSAppId: "");
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for creating settings buttons
  Widget _settingsButton(String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: ListTile(
          title: Text(title),
          trailing: Icon(icon),
        ),
      ),
    );
  }

  // Helper method to get the opposite theme mode
  ThemeMode _getOppositeThemeMode() {
    return _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
