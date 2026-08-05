import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/theme_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const AppRoot(),
    ),
  );
}