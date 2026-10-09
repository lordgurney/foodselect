import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/home_ordering_screen.dart';
import 'ui/state/canteen_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodSelectApp());
}

class FoodSelectApp extends StatefulWidget {
  const FoodSelectApp({super.key});

  @override
  State<FoodSelectApp> createState() => _FoodSelectAppState();
}

class _FoodSelectAppState extends State<FoodSelectApp> {
  late final CanteenController _canteenController;

  @override
  void initState() {
    super.initState();
    _canteenController = CanteenController();
  }

  @override
  void dispose() {
    _canteenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oakwood High School Canteen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeOrderingScreen(controller: _canteenController),
    );
  }
}
