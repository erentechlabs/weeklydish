import 'package:flutter/material.dart';

// Method to show delete dialog
Future<void> showDeleteDialog(
  BuildContext context,
  String title,
  String confirmText,
  String cancelText,
  VoidCallback onConfirm,
  VoidCallback onCancel,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        title: Center(child: Text(title)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Confirm button
              FilledButton(
                onPressed: onConfirm,
                child: Text(confirmText),
              ),

              // Cancel button
              TextButton(
                onPressed: onCancel,
                child: Text(cancelText),
              ),
            ],
          ),
        ],
      );
    },
  );
}
