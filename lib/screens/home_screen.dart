import 'package:flutter/material.dart';
import '../services/gold_api_service.dart';
import '../models/gold_calculation.dart';
import '../core/utils/helpers.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'results_screen.dart';
import 'used_gold_screen.dart';
import 'history_screen.dart';
import 'comparison_screen.dart';
import 'info_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _merchantPriceController = TextEditingController();

  int _selectedKarat = 21;
  bool _isLoadingPrice = false;

  void _fetchLivePrice() async {
    setState(() => _isLoadingPrice = true);
    final prices = await GoldApiService.fetchLiveGoldPricesSAR();
    setState(() => _isLoadingPrice = false);

    if (prices != null && prices.containsKey(_selectedKarat)) {
      _priceController.text = prices[_selectedKarat]!.toStringAsFixed(2);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث أسعار الذهب بنجاح')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر جلب الأسعار، يرجى إدخال السعر يدوياً')),
        );
      }
    }
  }

  void _calculateFairPrice() {
    if (_formKey.currentState!.validate()) {
      final double weight = double.parse(_weightController.text);
      final double pricePerGram = double.parse(_priceController.text);
      final double merchantPrice = double.parse(_merchantPriceController.text);

      final double rawGoldValue = weight * pricePerGram;
      final double makingFee = rawGoldValue * 0.08;
      final double subtotal = rawGoldValue + makingFee;
      final double vat = subtotal * 0.15;
      final double totalFairPrice = subtotal + vat;
      final double priceDifference = merchantPrice - totalFairPrice;

      final calculation = GoldCalculation(
        weight: weight,
        karat: _selectedKarat,
        pricePerGram: pricePerGram,
        merchantPrice: merchantPrice,
        rawGoldValue: rawGoldValue,
        makingFee: makingFee,
        vat: vat,
        totalFairPrice: totalFairPrice,
        priceDifference: priceDifference,
        date: DateTime.now(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(calculation: calculation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ذهب+ | حاسبة الشراء'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('سعر المجرّد المباشر:'),
                          _isLoadingPrice
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : TextButton.icon(
                                  onPressed: _fetchLivePrice,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('تحديث السعر'),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedKarat,
                decoration: InputDecoration(
                  labelText: 'العيار',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: [24, 22, 21, 18].map((karat) {
                  return DropdownMenuItem(
                    value: karat,
                    child: Text('عيار $karat'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedKarat = val);
                },
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _weightController,
                label: 'الوزن (جرام)',
                icon: Icons.scale,
                validator: (v) => (v == null || v.isEmpty) ? 'أدخل الوزن' : null,
              ),
              CustomTextField(
                controller: _priceController,
                label: 'سعر الجرام خام (ر.س)',
                icon: Icons.attach_money,
                validator: (v) => (v == null || v.isEmpty) ? 'أدخل سعر الجرام' : null,
              ),
              CustomTextField(
                controller: _merchantPriceController,
                label: 'سعر التاجر المعروض (ر.س)',
                icon: Icons.store,
                validator: (v) => (v == null || v.isEmpty) ? 'أدخل سعر التاجر' : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'تحليل وحساب السعر العادل',
                icon: Icons.analytics,
                onPressed: _calculateFairPrice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFFD700)),
            child: Center(
              child: Text(
                'ذهب+',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('حاسبة شراء الجديد'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.sell),
            title: const Text('حاسبة بيع المستعمل'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UsedGoldScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: const Text('مقارنة المحلات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparisonScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('السجل والعمليات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('دليل ونصائح الذهب'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoScreen()));
            },
          ),
        ],
      ),
    );
  }
}