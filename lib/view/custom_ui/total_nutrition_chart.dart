import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../model/nutrition_data.dart';

Widget totalNutritionChart(List<NutritionData> data) {
  // Aggregate the total values for each nutrient
  int totalCalories = 0;
  int totalProtein = 0;
  int totalFat = 0;
  int totalCarbohydrates = 0;

  for (var item in data) {
    totalCalories += item.calories ?? 0;
    totalProtein += item.protein ?? 0;
    totalFat += item.fat ?? 0;
    totalCarbohydrates += item.carbohydrates ?? 0;
  }

  // Create a list with the total values
  List<NutritionData> totalData = [
    NutritionData('calories'.tr(), totalCalories, Colors.purple),
    NutritionData('protein'.tr(), totalProtein, Colors.blue),
    NutritionData('fat'.tr(), totalFat, Colors.green),
    NutritionData('carbohydrates'.tr(), totalCarbohydrates, Colors.orange),
  ];

  // Return container
  return Container(
    height: 250,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
    ),
    child: BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              NutritionData nutrition = totalData[group.x.toInt()];
              return BarTooltipItem(
                nutrition.nutrient,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ${nutrition.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                return Text(
                  totalData[index].nutrient,
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        barGroups: totalData.map((nutrition) {
          return BarChartGroupData(
            x: totalData.indexOf(nutrition),
            barRods: [
              BarChartRodData(
                toY: nutrition.value.toDouble(),
                color: nutrition.color,
                width: 30,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}
