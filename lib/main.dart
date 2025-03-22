import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
