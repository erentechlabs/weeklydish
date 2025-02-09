// Build nutrition chart widget
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../model/nutrition_data.dart';

Widget buildNutritionChart(List<NutritionData> data) {
  // Return container
  return Container(
    // Adjusted height for a better visual balance
    height: 250,

    // Adjusted padding for a better visual balance
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

    // Set decoration
    decoration: BoxDecoration(
      color: Colors.black.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
    ),

    // Bar chart widget
    child: BarChart(
      // Bar chart data
      BarChartData(
        borderData: FlBorderData(show: false),
        // Hide the border for a cleaner look
        titlesData: FlTitlesData(
          // Adjust the titles' text style
          leftTitles: AxisTitles(
            // Adjust the left titles' text style
            sideTitles: SideTitles(
              // Show the titles
              showTitles: true,

              // Adjust the titles' text style
              reservedSize: 28,

              // Adjust the titles' text style
              getTitlesWidget: (value, meta) {
                // Return text widget
                return Text(
                  // Show the integer values
                  value.toStringAsFixed(0),

                  // Adjust the text style
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),

          // Adjust the titles' text style
          bottomTitles: AxisTitles(
            // Adjust the bottom titles' text style
            sideTitles: SideTitles(
              // Show the titles
              showTitles: true,

              // Adjust the titles' text style
              getTitlesWidget: (value, meta) {
                // Get the index
                int index = value.toInt();

                // Return text widget
                return Text(
                  // Show the nutrient
                  data[index].nutrient,

                  // Adjust the text style
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
        ),

        // Adjust the bar groups
        gridData: FlGridData(
          // Adjust the horizontal lines
          show: true,

          // Adjust the vertical lines
          drawVerticalLine: false,
          // Adjust horizontal lines' intervals
          horizontalInterval: 20,

          // Adjust the horizontal lines' style
          getDrawingHorizontalLine: (value) {
            // Return the horizontal line style
            return const FlLine(
              // Adjust the color
              strokeWidth: 1,
            );
          },
        ),

        // Adjust the bar groups
        barGroups: data.map((nutrition) {
          // Return bar chart group data
          return BarChartGroupData(
            // Adjust the x index
            x: data.indexOf(nutrition),

            // Adjust the bar rods
            barRods: [
              // Adjust the bar chart rod data
              BarChartRodData(
                // Adjust the y value
                toY: nutrition.value.toDouble(),

                // Adjust the rod color
                color: nutrition.color,

                // Adjust the width
                width: 30,

                // Adjust the border radius
                borderRadius:
                    BorderRadius.circular(8), // Rounded bars for a softer look
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}
