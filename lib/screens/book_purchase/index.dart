import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/utils/export_excel.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/purchase_modal.dart';

import '../../classes.dart';

class BookPurchase extends StatefulWidget {
  const BookPurchase({super.key});

  @override
  State<BookPurchase> createState() => _BookPurchaseState();
}

class _BookPurchaseState extends State<BookPurchase> {
  List<PurchaseListItemModel> purchases = [];

  void onPressAddOrEdit({PurchaseListItemModel? data}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

          return Dialog(
              child: Container(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.5),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                          //#pending - while scrolling, header and submit should be sticky
                          child: BookPurchaseModalWidget(
                              data: data, updateUI: setData)))));
        });
  }

  void _deletePurchase(String purchaseID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  const Text('Are you sure you want to delete this purchase?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      deleteBookPurchase(purchaseID).then((res) {
                        Navigator.of(context).pop();

                        if (res['message'] == null) {
                          setData();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(res['message']!),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'))
                                    ]);
                              });
                        }
                      });
                    },
                    child: const Text('Delete'))
              ]);
        });
  }

  void setData() async {
    final tempData = await getBookPurchaseList();
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
      final loggedIn = user.user.userID != 0;

      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Purchases',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      exportExcel(context: context, purchases: purchases);
                    },
                    child: const Text('Export Excel',
                        style: TextStyle(color: Colors.white))),
                const SizedBox(width: 10),
                if (loggedIn)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        onPressAddOrEdit();
                      },
                      child: const Text('New purchase',
                          style: TextStyle(color: Colors.white)))
              ])
            ]),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(
                  flex: 1,
                  child: Text('ID',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  flex: 3,
                  child: Text('Book',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  flex: 2,
                  child: Text('Balance Stock/Purchased Quantity',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  flex: 2,
                  child: Text('Price',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  flex: 3,
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
                        itemBuilder: (context, index) => Row(children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(purchases[index].purchaseID)),
                              Expanded(
                                  flex: 3,
                                  child: Text(purchases[index].itemName)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      '${purchases[index].balanceStock} / ${purchases[index].quantityPurchased}')),
                              Expanded(
                                  flex: 2,
                                  child:
                                      Text(purchases[index].price.toString())),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                      purchases[index].formattedPurchaseDate)),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      onPressAddOrEdit(data: purchases[index]);
                                    }),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      _deletePurchase(
                                          purchases[index].purchaseID);
                                    })
                            ]))
                    : const Text("No records found"))
          ]));
    });
  }
}
