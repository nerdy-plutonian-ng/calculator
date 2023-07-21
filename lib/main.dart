import 'package:calculator/data/repositories/db_saver.dart';
import 'package:calculator/ui/screens/home.dart';
import 'package:calculator/ui/screens/home_state.dart';
import 'package:calculator/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (_) => HomeState(DbSaver()),
      child: const CalculatorApp(),
    ));

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: theme,
      darkTheme: darkTheme,
      home: const Home(),
    );
  }
}
