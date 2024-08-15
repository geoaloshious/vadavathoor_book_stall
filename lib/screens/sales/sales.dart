import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/functions/book_sale.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/screens/sales/new_sale.dart';

class SalesWidget extends StatefulWidget {
  const SalesWidget({super.key});

  @override
  State<SalesWidget> createState() => _SalesState();
}

class _SalesState extends State<SalesWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateBookSaleList();
  }

  void newSale() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        double dialogWidth = screenSize.width * 0.8;
        double dialogHeight = screenSize.height * 0.7;

        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              minHeight: dialogHeight,
              maxWidth: dialogWidth, // Set the desired maximum width
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                //#pending - while scrolling, header, grand total and submit should be sticky
                child: NewSaleWidget(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Sales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Consumer<UserProvider>(builder: (cntx, user, _) {
              if (user.user.userID != '') {
                return ElevatedButton(
                    onPressed: newSale, child: const Text('New sale'));
              } else {
                return const SizedBox.shrink();
              }
            })
          ]),
          const SizedBox(height: 20),
          const Row(children: [
            Expanded(
                child: Text('Book',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Expanded(
                child: Text('Qty',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Expanded(
                child: Text('Total',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Expanded(
                child: Text('Date',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))
          ]),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.2, color: Colors.blueGrey)))),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: salesNotifier,
                  builder: (ctx, sales, child) {
                    if (sales.isNotEmpty) {
                      return ListView.builder(
                          itemBuilder: (ctx2, index) {
                            return Row(children: [
                              Expanded(child: Text(sales[index].bookName)),
                              Expanded(
                                  child:
                                      Text(sales[index].quantity.toString())),
                              Expanded(
                                  child:
                                      Text(sales[index].grandTotal.toString())),
                              Expanded(child: Text(sales[index].date))
                            ]);
                          },
                          itemCount: sales.length);
                    } else {
                      return const Text("No records found");
                    }
                  }))
        ]));
  }
}
