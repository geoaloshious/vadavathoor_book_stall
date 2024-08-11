import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/screens/home.dart';
import 'package:vadavathoor_book_stall/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHiveDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book stall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
