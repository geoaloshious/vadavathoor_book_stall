import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (cntx, user, _) {
      final loggedIn = user.user.userID != '';

      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text(
                'Purchases',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (loggedIn)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: newPurchase,
                    child: const Text('New purchase',
                        style: TextStyle(color: Colors.white)))
            ]),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(
                  child: Text('Book',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Publisher',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Category',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Balance Stock/Purchased Quantity',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Price',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Purchase date',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              if (loggedIn) const SizedBox(width: 80)
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.blueGrey)))),
            Expanded(
                child: purchases.isNotEmpty
                    ? ListView.builder(
                        itemCount: purchases.length,
                        itemBuilder: (context, index) => PurchasedBookWidget(
                            key: Key('$index'),
                            data: purchases[index],
                            loggedIn: loggedIn,
                            updateUI: setData))
                    : const Text("No records found"))
          ]));
    });
  }
}
