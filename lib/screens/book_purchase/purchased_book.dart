import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/edit_book_purchase.dart';

class PurchasedBookWidget extends StatefulWidget {
  final BookPurchaseListItemModel data;
  final bool loggedIn;
  final void Function() updateUI;

  const PurchasedBookWidget(
      {super.key,
      required this.data,
      required this.loggedIn,
      required this.updateUI});

  @override
  State<PurchasedBookWidget> createState() => _PurchasedBookState();
}

class _PurchasedBookState extends State<PurchasedBookWidget> {
  void _deletePurchase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this purchase?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteBookPurchase(widget.data.purchaseID);
                widget.updateUI();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void onPressEdit() {
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
                child: EditBookPurchaseWidget(
                  data: widget.data,
                  updateUI: widget.updateUI,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(widget.data.bookName)),
        Expanded(child: Text(widget.data.publisherName)),
        Expanded(child: Text(widget.data.categoryName)),
        Expanded(child: Text(widget.data.quantityPurchased.toString())),
        Expanded(child: Text(widget.data.bookPrice.toString())),
        Expanded(child: Text(widget.data.formattedPurchaseDate)),
        if (widget.loggedIn)
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: onPressEdit,
          ),
        if (widget.loggedIn)
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: _deletePurchase,
          )
      ],
    );
  }
}
