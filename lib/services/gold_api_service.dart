import 'dart:convert';
import 'package:http/http.dart' as http;

class GoldApiService {
  static Future<Map<int, double>?> fetchLiveGoldPricesSAR() async {
    // المحاولة الأولى: استخدام API مباشر مع ترويسة الطلب
    try {
      final response = await http.get(
        Uri.parse('https://api.gold-api.com/price/XAU'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double priceUsdOunce = (data['price'] as num).toDouble();
        return _calculateSarGramPrices(priceUsdOunce);
      }
    } catch (_) {}

    // المحاولة الثانية: استخدام مصدر بديل في حال فشل الأولي
    try {
      final backupResponse = await http.get(
        Uri.parse('https://open.er-api.com/v6/latest/XAU'),
      ).timeout(const Duration(seconds: 8));

      if (backupResponse.statusCode == 200) {
        final data = json.decode(backupResponse.body);
        final double priceSarOunce = (data['rates']['SAR'] as num).toDouble();
        final double priceSarGram24 = priceSarOunce / 31.1034768;

        return {
          24: priceSarGram24,
          22: priceSarGram24 * (22 / 24),
          21: priceSarGram24 * (21 / 24),
          18: priceSarGram24 * (18 / 24),
        };
      }
    } catch (_) {}

    return null;
  }

  static Map<int, double> _calculateSarGramPrices(double priceUsdOunce) {
    // سعر الأونصة بالدولار * 3.75 (سعر صرف الريال) / 31.1034768 (جرام الأونصة)
    final double priceSarGram24 = (priceUsdOunce * 3.75) / 31.1034768;

    return {
      24: priceSarGram24,
      22: priceSarGram24 * (22 / 24),
      21: priceSarGram24 * (21 / 24),
      18: priceSarGram24 * (18 / 24),
    };
  }
}