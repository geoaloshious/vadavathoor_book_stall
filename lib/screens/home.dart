import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/book_purchase.dart';
import 'package:vadavathoor_book_stall/screens/book_sale.dart';
import 'package:vadavathoor_book_stall/screens/publishers.dart';
import 'package:vadavathoor_book_stall/screens/stationary.dart';

final a = {
  0: 'Book purchases',
  1: 'Book sales',
  2: 'Publishers',
  3: 'Stationary items'
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  renderRightSide() {
    switch (currentPage) {
      case 0:
        return const BookPurchase();
      case 1:
        return const BookSale();
      case 2:
        return const Publishers();
      case 3:
        return const Stationary();
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: currentPage == index
                                  ? Colors.lightBlue
                                  : Colors.white38 // Set the background color
                              ),
                          onPressed: () {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          child: ListTile(
                            title: Text(a[index]!),
                          ),
                        );
                      })),
              Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.amber,
                    child: renderRightSide(),
                  ))
            ],
          )),
    );
  }
}
