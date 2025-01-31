import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

void showAdDialog(BuildContext context, VoidCallback onAdAccepted) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "getRecipe",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ).tr(),
        content: const Text(
          "getRecipeContent",
          style: TextStyle(fontSize: 16),
        ).tr(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "no",
              style: TextStyle(fontWeight: FontWeight.bold),
            ).tr(),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onAdAccepted();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "yes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ).tr(),
          ),
        ],
      );
    },
  );
}
