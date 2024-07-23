import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';
import 'package:vadavathoor_book_stall/db/models/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/purchase_attachment.dart';
import 'package:vadavathoor_book_stall/db/models/publisher.dart';
import 'package:vadavathoor_book_stall/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(BookModelAdapter().typeId)) {
    Hive.registerAdapter(BookModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BookPurchaseModelAdapter().typeId)) {
    Hive.registerAdapter(BookPurchaseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BookSaleModelAdapter().typeId)) {
    Hive.registerAdapter(BookSaleModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PurchaseAttachmentModelAdapter().typeId)) {
    Hive.registerAdapter(PurchaseAttachmentModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PublisherModelAdapter().typeId)) {
    Hive.registerAdapter(PublisherModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
