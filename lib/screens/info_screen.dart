import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دليل ونصائح الذهب')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text('كيف تحسب المصنعية؟'),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('تتراوح المصنعية العادلة في السوق عادة بين 8% إلى 15% للقطع العادية، بينما تزيد للقطع المصنوعة يدوياً أو الماركات.'),
              )
            ],
          ),
          ExpansionTile(
            title: Text('الفرق بين عيارات الذهب'),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('عيار 24 هو ذهب خالص 100%. عيار 21 يحتوي على 87.5% ذهب، وعيار 18 يحتوي على 75% ذهب ومخلوط بمعادن أخرى للصلابة.'),
              )
            ],
          ),
          ExpansionTile(
            title: Text('نصائح عند الشراء من المحل'),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('اطلب دائماً الفاتورة المفصلة التي توضح سعر جرام الخام بشكل منفصل عن اجرة المصنعية مع توضيح نسبة الضريبة 15%.'),
              )
            ],
          ),
        ],
      ),
    );
  }
}