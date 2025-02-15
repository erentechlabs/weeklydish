import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/nutrition_data.dart';

Widget perItemNutritionBar(NutritionData data) {
  // Return the padding
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),

    // Return the card
    child: Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 200,

        // Set the decoration
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the nutrient name
            Text(
              data.nutrient,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: data.color,
              ),
            ),
            const SizedBox(height: 30),

            // Display the pie chart
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: data.calories?.toDouble() ?? 0,
                      color: Colors.red,
                      title: 'calories'.tr(),
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: data.protein?.toDouble() ?? 0,
                      color: Colors.blue,
                      title: 'protein'.tr(),
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: data.fat?.toDouble() ?? 0,
                      color: Colors.green,
                      title: 'fat'.tr(),
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: data.carbohydrates?.toDouble() ?? 0,
                      color: Colors.orange,
                      title: 'carbohydrates'.tr(),
                      radius: 50,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Display the calories if available
            if (data.calories != null)
              Text(
                'caloriesWithParameter'.tr(args: [data.calories.toString()]),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

            // Display the fat if available
            if (data.fat != null)
              Text(
                'fatwWithParameter'.tr(args: [data.fat.toString()]),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

            // Display the protein if available
            if (data.protein != null)
              Text(
                'proteinwWithParameter'.tr(args: [data.protein.toString()]),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

            // Display the carbohydrates if available
            if (data.carbohydrates != null)
              Text(
                'carbohydratesWithParameter'
                    .tr(args: [data.carbohydrates.toString()]),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
