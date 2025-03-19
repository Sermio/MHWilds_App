import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Widget _selectedScreen = Container(
  //   child: const Text('OLAa'),
  // );
  Widget _selectedScreen = const DecorationsList();

  void _changeScreen(Widget newScreen) {
    setState(() {
      _selectedScreen = newScreen;
    });
    Navigator.pop(context); // Cierra el Drawer después de seleccionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Cappbar(),
      drawer: Cdrawer(onItemSelected: _changeScreen),
      body: _selectedScreen,
    );
  }
}
