import 'package:flutter/material.dart';
import '../core/utils/helpers.dart';
import '../services/gold_api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class UsedGoldScreen extends StatefulWidget {
  const UsedGoldScreen({super.key});

  @override
  State<UsedGoldScreen> createState() => _UsedGoldScreenState();
}

class _UsedGoldScreenState extends State<UsedGoldScreen> {
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();

  int _selectedKarat = 21;
  double? _resultPrice;
  bool _isLoadingPrice = false;

  // خريطة لتخزين أسعار البيع بعد خصم هامش التاجر لكل عيار
  Map<int, double> _sellPricesMap = {};

  // نسبة خصم هامش المحل التقديرية (1.5%)
  final double _merchantMarginPercent = 1.5;

  // دالة جلب أسعار البيع المباشرة لجميع العيارات
  Future<void> _fetchLiveSellPrices() async {
    setState(() {
      _isLoadingPrice = true;
    });

    final prices = await GoldApiService.fetchLiveGoldPricesSAR();

    if (prices != null) {
      final Map<int, double> updatedSellPrices = {};

      // تطبيق خصم هامش التاجر على كل عيار
      prices.forEach((karat, price) {
        updatedSellPrices[karat] = price * (1 - (_merchantMarginPercent / 100));
      });

      setState(() {
        _sellPricesMap = updatedSellPrices;
        _isLoadingPrice = false;

        // تحديث حقل السعر بالعيار المختار حالياً
        if (_sellPricesMap.containsKey(_selectedKarat)) {
          _priceController.text = _sellPricesMap[_selectedKarat]!.toStringAsFixed(2);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث سعر بيع عيار $_selectedKarat بنجاح!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {
        _isLoadingPrice = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر جلب السعر، يرجى إدخاله يدوياً'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  // تحديث حقل السعر عند تغيير العيار من القائمة
  void _onKaratChanged(int? newKarat) {
    if (newKarat == null) return;

    setState(() {
      _selectedKarat = newKarat;

      // إذا كانت الأسعار المحملة موجودة، نقوم بتحديث الحقل فوراً
      if (_sellPricesMap.containsKey(newKarat)) {
        _priceController.text = _sellPricesMap[newKarat]!.toStringAsFixed(2);
      }
    });

    // إعادت الحسبة تلقائياً إن كان هناك وزن مدخل
    if (_weightController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      _calculateUsedPrice();
    }
  }

  void _calculateUsedPrice() {
    if (_weightController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      final double weight = double.tryParse(_weightController.text) ?? 0;
      final double pricePerGram = double.tryParse(_priceController.text) ?? 0;

      final double totalPrice = weight * pricePerGram;

      setState(() {
        _resultPrice = totalPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حاسبة بيع الذهب المستعمل')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // زر تحديث السعر المباشر
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _isLoadingPrice ? null : _fetchLiveSellPrices,
                  icon: _isLoadingPrice
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, color: Color(0xFFFFD700)),
                  label: Text(
                    _isLoadingPrice ? 'جاري التحديث...' : 'تحديث سعر البيع المباشر',
                    style: const TextStyle(color: Color(0xFFFFD700)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFFD700)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedKarat,
                decoration: InputDecoration(
                  labelText: 'العيار',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: [24, 22, 21, 18].map((karat) {
                  return DropdownMenuItem(value: karat, child: Text('عيار $karat'));
                }).toList(),
                onChanged: _onKaratChanged,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _weightController,
                label: 'وزن الذهب المستعمل (جرام)',
                icon: Icons.scale,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _priceController,
                label: 'سعر جرام عيار $_selectedKarat عند البيع',
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'حساب القيمة المستحقة',
                icon: Icons.calculate,
                onPressed: _calculateUsedPrice,
              ),
              if (_resultPrice != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('المبلغ التقديري المستحق لك عند البيع:',
                            style: TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text(
                          Helpers.formatCurrency(_resultPrice!),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '* تم احتساب سعر جرام عيار $_selectedKarat مباشرة مع مراعاة خصم التاجر التقديري ($_merchantMarginPercent%).',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}