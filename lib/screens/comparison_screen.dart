import 'package:flutter/material.dart';
import '../models/shop_comparison.dart';
import '../core/utils/helpers.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final List<ShopComparison> _shops = [];
  final _shopNameController = TextEditingController();
  final _priceController = TextEditingController();

  void _addShop() {
    if (_shopNameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      setState(() {
        _shops.add(ShopComparison(
          shopName: _shopNameController.text,
          price: double.parse(_priceController.text),
        ));
        _shopNameController.clear();
        _priceController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مقارنة عروض المحلات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _shopNameController,
                    label: 'اسم المحل',
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(
                    controller: _priceController,
                    label: 'السعر المعروض',
                  ),
                ),
              ],
            ),
            CustomButton(
              text: 'إضافة للجدول',
              icon: Icons.add,
              onPressed: _addShop,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _shops.isEmpty
                  ? const Center(child: Text('قم بإضافة عروض المحلات لمقارنتها'))
                  : ListView.builder(
                      itemCount: _shops.length,
                      itemBuilder: (ctx, index) {
                        final shop = _shops[index];
                        return Card(
                          child: ListTile(
                            title: Text(shop.shopName),
                            trailing: Text(
                              Helpers.formatCurrency(shop.price),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}