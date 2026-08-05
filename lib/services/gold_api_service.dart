import 'dart:convert';
import 'package:http/http.dart' as http;

class GoldApiService {
  static const _timeout = Duration(seconds: 10);

  static const _goldPriceApis = [
    'https://api.gold-api.com/price/XAU',
  ];

  static const _exchangeRateApis = [
    'https://open.er-api.com/v6/latest/USD',
    'https://api.exchangerate-api.com/v4/latest/USD',
  ];

  static Future<Map<int, double>?> fetchLiveGoldPricesSAR() async {
    final goldPriceUsd = await _fetchGoldPriceUsd();
    final usdToSar = await _fetchUsdToSarRate();

    if (goldPriceUsd != null && usdToSar != null) {
      return _calculateSarGramPrices(goldPriceUsd, usdToSar);
    }

    return null;
  }

  static Future<double?> _fetchGoldPriceUsd() async {
    for (final url in _goldPriceApis) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'Mozilla/5.0',
          },
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is Map && data['price'] != null) {
            return (data['price'] as num).toDouble();
          }
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<double?> _fetchUsdToSarRate() async {
    for (final url in _exchangeRateApis) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'Mozilla/5.0',
          },
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is Map &&
              data['rates'] != null &&
              data['rates']['SAR'] != null) {
            return (data['rates']['SAR'] as num).toDouble();
          }
        }
      } catch (_) {}
    }
    return null;
  }

  static Map<int, double> _calculateSarGramPrices(
    double priceUsdOunce,
    double usdToSar,
  ) {
    final double priceSarGram24 = (priceUsdOunce * usdToSar) / 31.1034768;

    return {
      24: priceSarGram24,
      22: priceSarGram24 * (22 / 24),
      21: priceSarGram24 * (21 / 24),
      18: priceSarGram24 * (18 / 24),
    };
  }
}
