import 'package:flutter/material.dart';
import '../../core/constants/api_config.dart';
import 'cars_screen.dart';

class MyInventoryScreen extends StatelessWidget {
  const MyInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarsScreen(
      title: "My Inventory",
      endpoint: ApiConfig.carsMyInventory,
    );
  }
}
