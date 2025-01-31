import 'package:flutter/material.dart';

showSuccessSnackbarDialog(BuildContext context, String message) {
  // Show a confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          // Success icon
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),

          // Icon and text are separated by a space
          const SizedBox(width: 10),

          // Success message
          Text(
            message,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),

      // Background color (light green for success)
      backgroundColor: Colors.greenAccent.shade700,

      // Move the Snackbar to the top
      behavior: SnackBarBehavior.floating,

      // Margin around the snack bar
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      // Rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      // Duration of the message
      duration: const Duration(seconds: 3),
    ),
  );
}
