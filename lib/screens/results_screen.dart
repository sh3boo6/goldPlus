import 'package:flutter/material.dart';
import '../models/gold_calculation.dart';
import '../core/utils/helpers.dart';
import '../services/database_service.dart';
import '../widgets/custom_button.dart';

class ResultsScreen extends StatelessWidget {
  final GoldCalculation calculation;

  const ResultsScreen({super.key, required this.calculation});

  void _saveToHistory(BuildContext context) {
    final box = DatabaseService.getHistoryBox();
    box.add(calculation);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ العملية في السجل')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverPriced = calculation.priceDifference > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('نتيجة التحليل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: isOverPriced ? Colors.red.shade50 : Colors.green.shade50,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      isOverPriced ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                      size: 48,
                      color: isOverPriced ? Colors.red : Colors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isOverPriced ? 'السعر أعلى من السعر العادل المقدر' : 'السعر ممتاز وعادل!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isOverPriced ? Colors.red.shade900 : Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الفرق: ${Helpers.formatCurrency(calculation.priceDifference.abs())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('وزن القطعة:', '${calculation.weight} جرام'),
                    _buildRow('العيار:', 'عيار ${calculation.karat}'),
                    _buildRow('قيمة الذهب الخام:', Helpers.formatCurrency(calculation.rawGoldValue)),
                    _buildRow('المصنعية التقديرية (8%):', Helpers.formatCurrency(calculation.makingFee)),
                    _buildRow('ضريبة القيمة المضافة (15%):', Helpers.formatCurrency(calculation.vat)),
                    const Divider(),
                    _buildRow('السعر العادل الإجمالي:', Helpers.formatCurrency(calculation.totalFairPrice), isBold: true),
                    _buildRow('سعر التاجر المعروض:', Helpers.formatCurrency(calculation.merchantPrice), isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'حفظ العملية في السجل',
              icon: Icons.save,
              onPressed: () => _saveToHistory(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}