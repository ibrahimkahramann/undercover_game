import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/game_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undercover Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Placeholder(),
    );
  }
}
