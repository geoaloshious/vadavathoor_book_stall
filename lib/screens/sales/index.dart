import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/utils/export_excel.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/screens/sales/sale.dart';
import 'package:vadavathoor_book_stall/screens/sales/sales_modal.dart';

class SalesWidget extends StatefulWidget {
  const SalesWidget({super.key});

  @override
  State<SalesWidget> createState() => _SalesState();
}

class _SalesState extends State<SalesWidget> {
  List<SaleListItemModel> sales = [];

  void setData() async {
    final temp = await getSalesList();
    setState(() {
      sales = temp;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  void newSale() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        return Dialog(
          child: Container(
            constraints: BoxConstraints(minHeight: screenSize.height * 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                //#pending - while scrolling, header, grand total and submit should be sticky
                child: SaleModalWidget(saleID: '', updateUI: setData),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (cntx, user, _) {
      final loggedIn = user.user.userID != '';

      return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Sales',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      exportExcel(context: context, sales: sales);
                    },
                    child: const Text('Export Excel',
                        style: TextStyle(color: Colors.white))),
                const SizedBox(width: 10),
                if (loggedIn)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: newSale,
                      child: const Text('New sale',
                          style: TextStyle(color: Colors.white)))
              ])
            ]),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(
                  child: Text('Bill No.',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Customer',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Books (Qty)',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Stationaries (Qty)',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Paid Via',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Total',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Created Date',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const Expanded(
                  child: Text('Modified Date',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              const SizedBox(width: 40),
              if (loggedIn) const SizedBox(width: 80)
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.blueGrey)))),
            Expanded(
                child: sales.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (ctx2, index) {
                          return SaleWidget(
                              key: Key('$index'),
                              data: sales[index],
                              loggedIn: loggedIn,
                              updateUI: setData);
                        },
                        itemCount: sales.length)
                    : const Text("No records found"))
          ]));
    });
  }
}
