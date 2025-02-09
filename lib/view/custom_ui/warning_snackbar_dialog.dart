import 'package:flutter/material.dart';

showWarningSnackbarDialog(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          // Warning icon
          const Icon(Icons.warning_amber_outlined,
              color: Colors.orange, size: 24),

          // Icon and text are separated by a space
          const SizedBox(width: 10),

          // Warning message
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),

      // Background color (red for warning)
      backgroundColor: Colors.redAccent,

      // Move the Snackbar to the top
      behavior: SnackBarBehavior.floating,

      // Margin around the snack bar
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      // Rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      // Duration of the message
      duration: const Duration(seconds: 2),
    ),
  );
}
