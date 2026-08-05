import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';
import '../models/gold_calculation.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحسابات'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<GoldCalculation>>(
        valueListenable: DatabaseService.getHistoryBox().listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد عمليات محفوظة في السجل حتى الآن',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              // العرض من الأحدث إلى الأقدم
              final reversedIndex = box.length - 1 - index;
              final calc = box.getAt(reversedIndex);

              // حماية في حال وجود عنصر فارغ
              if (calc == null) {
                return const SizedBox.shrink();
              }

              return Dismissible(
                key: Key('${calc.date.millisecondsSinceEpoch}_$reversedIndex'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  box.deleteAt(reversedIndex);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حذف العملية من السجل')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFD700),
                      child: Icon(Icons.monetization_on, color: Colors.black),
                    ),
                    title: Text(
                      'وزن: ${calc.weight.toStringAsFixed(2)} جم | عيار ${calc.karat}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${calc.date.year}-${calc.date.month.toString().padLeft(2, '0')}-${calc.date.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: Text(
                      '${calc.merchantPrice.toStringAsFixed(2)} ر.س',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}