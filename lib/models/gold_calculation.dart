import 'package:hive/hive.dart';

part 'gold_calculation.g.dart';

@HiveType(typeId: 0)
class GoldCalculation extends HiveObject {
  @HiveField(0)
  final double weight;

  @HiveField(1)
  final int karat;

  @HiveField(2)
  final double pricePerGram;

  @HiveField(3)
  final double merchantPrice;

  @HiveField(4)
  final double rawGoldValue;

  @HiveField(5)
  final double makingFee;

  @HiveField(6)
  final double vat;

  @HiveField(7)
  final double totalFairPrice;

  @HiveField(8)
  final double priceDifference;

  @HiveField(9)
  final DateTime date;

  GoldCalculation({
    required this.weight,
    required this.karat,
    required this.pricePerGram,
    required this.merchantPrice,
    required this.rawGoldValue,
    required this.makingFee,
    required this.vat,
    required this.totalFairPrice,
    required this.priceDifference,
    required this.date,
  });
}