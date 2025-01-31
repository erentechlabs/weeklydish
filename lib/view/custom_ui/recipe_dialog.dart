// Build recipe dialog
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget recipeDialog({
  required BuildContext context,
  required String title,
  required dynamic content,
}) {
  // Return alert dialog
  return AlertDialog(
    // Set title
    title: Text(title),

    // Make it scrollable
    content: SingleChildScrollView(
      // Set content
      child: content is String

          // Check if content is a string
          ? Text(content)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                content,
              ],
            ),
    ),
    actions: [
      // Close button
      TextButton(
        // Pop the context
        onPressed: () => Navigator.pop(context),
        // Set text
        child: const Text('close').tr(),
      ),
    ],
  );
}
