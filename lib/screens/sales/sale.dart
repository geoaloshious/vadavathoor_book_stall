import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/utils/create_bill_pdf.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/screens/sales/sales_modal.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

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
                      deleteSale(widget.data.saleID).then((_) {
                        widget.updateUI();
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text('Delete'))
              ]);
        });
  }

  void _onPressEdit() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

          return Dialog(
              child: Container(
                  constraints:
                      BoxConstraints(minHeight: screenSize.height * 0.5),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                          //#pending - while scrolling, header and submit should be sticky
                          child: SaleModalWidget(
                              saleID: widget.data.saleID,
                              updateUI: widget.updateUI)))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(widget.data.customerName)),
      Expanded(child: Text(widget.data.books)),
      Expanded(child: Text(widget.data.paymentMode)),
      Expanded(child: Text(widget.data.grandTotal.toString())),
      Expanded(child: Text(widget.data.createdDate)),
      Expanded(child: Text(widget.data.modifiedDate)),
      IconButton(
          icon: const Icon(Icons.print),
          tooltip: 'Bill',
          onPressed: () {
            saveAndOpenPDF(widget.data.saleID);
          }),
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
