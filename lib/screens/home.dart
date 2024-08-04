import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/book_purchase.dart';
// import 'package:vadavathoor_book_stall/screens/publishers.dart';
import 'package:vadavathoor_book_stall/screens/sales/sales.dart';
// import 'package:vadavathoor_book_stall/screens/stationary.dart';
import 'package:vadavathoor_book_stall/screens/under_development.dart';

final a = {
  0: 'Book purchases',
  1: 'Sales',
  2: 'Stationary purchases',
  3: 'Publishers',
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
        return const SalesWidget();
      case 2:
        // return const Publishers();
        return UnderDevelopment();
      case 3:
        // return const Stationary();
        return UnderDevelopment();
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
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2, color: Colors.blueGrey),
                        // shape: BoxShape.circle,
                        boxShadow: const [
                      BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 4,
                      ),
                    ])),
              ),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: renderRightSide(),
                  ))
            ],
          )),
    );
  }
}
