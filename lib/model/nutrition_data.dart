import 'dart:ui';

class NutritionData {
  final String nutrient;
  final int value;
  final Color color;
  final String? mealName;
  final int? calories;
  final int? fat;
  final int? carbohydrates;
  final int? protein;

  NutritionData(
    this.nutrient,
    this.value,
    this.color, {
    this.mealName,
    this.calories,
    this.fat,
    this.carbohydrates,
    this.protein,
  });
}
