import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/functions/book_sale.dart';
import 'package:vadavathoor_book_stall/utils.dart';

class SaleWidget extends StatefulWidget {
  final SaleListItemModel data;
  final bool loggedIn;
  final void Function() updateUI;

  const SaleWidget(
      {super.key,
      required this.data,
      required this.loggedIn,
      required this.updateUI});

  @override
  State<SaleWidget> createState() => _SaleState();
}

class _SaleState extends State<SaleWidget> {
  void _onPressDelete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Confirm'),
              content: const Text('Are you sure you want to delete?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      await deleteBookSale(widget.data.saleID);
                      widget.updateUI();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete'))
              ]);
        });
  }

  void _onPressEdit() {
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       Size screenSize = MediaQuery.of(context).size;
    //       double dialogWidth = screenSize.width * 0.7;
    //       double dialogHeight = screenSize.height * 0.5;

    //       return Dialog(
    //           child: Container(
    //               constraints: BoxConstraints(
    //                 minHeight: dialogHeight,
    //                 maxWidth: dialogWidth
    //               ),
    //               child: Padding(
    //                   padding: const EdgeInsets.all(16.0),
    //                   child: SingleChildScrollView(
    //                       //#pending - while scrolling, header and submit should be sticky
    //                       child: EditBookPurchaseWidget(
    //                           data: widget.data, updateUI: widget.updateUI)))));
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(widget.data.bookName)),
      Expanded(child: Text(widget.data.quantity.toString())),
      Expanded(child: Text(getPaymentModeName(widget.data.paymentMode))),
      Expanded(child: Text(widget.data.grandTotal.toString())),
      Expanded(child: Text(widget.data.date)),
      if (widget.loggedIn)
        IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: _onPressEdit),
      if (widget.loggedIn)
        IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: _onPressDelete)
    ]);
  }
}
