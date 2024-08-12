import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/purchased_book.dart';

import '../../classes.dart';
import 'new_purchase.dart';

class BookPurchase extends StatefulWidget {
  const BookPurchase({super.key});

  @override
  State<BookPurchase> createState() => _BookPurchaseState();
}

class _BookPurchaseState extends State<BookPurchase> {
  List<BookPurchaseListItemModel> purchases = [];

  void newPurchase() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        double dialogWidth = screenSize.width * 0.7;
        double dialogHeight = screenSize.height * 0.5;

        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              minHeight: dialogHeight,
              maxWidth: dialogWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                //#pending - while scrolling, header and submit should be sticky
                child: NewPurchaseWidget(updateUI: setData),
              ),
            ),
          ),
        );
      },
    );
  }

  void setData() async {
    var tempData = await getBookPurchaseList();
    setState(() {
      purchases = tempData;
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purchases',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                  onPressed: newPurchase, child: const Text('New purchase')),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                  child: Text(
                'Book',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              Expanded(
                  child: Text(
                'Publisher',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              Expanded(
                  child: Text(
                'Quantity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              Expanded(
                  child: Text(
                'Price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              Expanded(
                  child: Text(
                'Purchase date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              SizedBox(width: 80)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.2, color: Colors.blueGrey))),
          ),
          Expanded(
              child: purchases.isNotEmpty
                  ? ListView.builder(
                      itemCount: purchases.length,
                      itemBuilder: (context, index) => PurchasedBookWidget(
                          data: purchases[index], updateUI: setData))
                  : const Text(
                      "No records found. Click 'New purchase' button to add."))
          // BookCard(data: purchases[index]))))
        ],
      ),
    );
  }
}
