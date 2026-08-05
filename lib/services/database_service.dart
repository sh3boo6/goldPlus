import 'package:hive_flutter/hive_flutter.dart';
import '../models/gold_calculation.dart';

class DatabaseService {
  static const String historyBoxName = 'gold_history';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GoldCalculationAdapter());
    }
    await Hive.openBox<GoldCalculation>(historyBoxName);
  }

  static Box<GoldCalculation> getHistoryBox() {
    return Hive.box<GoldCalculation>(historyBoxName);
  }
}