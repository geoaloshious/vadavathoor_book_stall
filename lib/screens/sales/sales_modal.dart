import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/components/modal_close_confirmation.dart';
import 'package:vadavathoor_book_stall/components/button.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/screens/sales/sale_item_book.dart';
import 'package:vadavathoor_book_stall/utils.dart';

class SaleModalWidget extends StatefulWidget {
  final String saleID;
  final void Function() updateUI;

  const SaleModalWidget(
      {super.key, required this.saleID, required this.updateUI});

  @override
  State<SaleModalWidget> createState() => _SaleModalState();
}

class _SaleModalState extends State<SaleModalWidget> {
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _customerBatchController = TextEditingController();

  Map<String, bool> inputErrors = {};
  List<SaleItemBookModel> booksToCheckout = [];
  double grandTotal = 0;
  List<String> selectedBookIDs = [];
  String _paymentMode = PaymentModes.cash;
  Map<String, Map<String, Map<String, Object>>> allBooksWithPurchases = {};
  List<BookModel> allBooks = [];

  bool didSetData = false;

  Future<void> _handleSubmit() async {
    // print(booksToCheckout.length);
    // booksToCheckout.forEach((i) => print(i.toJson()));

    /**
       * Below statement following things:
       * Checks whether any purchases selected
       * Checks whether quantity > 0 in purchases
       * Copy original price to sold price if not specified.
       */
    final validBooks = booksToCheckout.where((bk) {
      final List<SaleItemBookPurchaseVariantModel> validPVs = [];

      for (var pv in bk.purchaseVariants) {
        if (pv.soldPrice == 0) {
          pv.soldPrice = allBooksWithPurchases[bk.bookID]?[pv.purchaseID]
              ?['price'] as double;
        }

        if (pv.quantity > 0) {
          validPVs.add(pv);
        }
      }

      bk.purchaseVariants = validPVs;

      return validPVs.isNotEmpty;
    }).toList();

    if (validBooks.isNotEmpty) {
      if (widget.saleID == '') {
        await addSale(
            validBooks,
            grandTotal,
            _customerNameController.text.trim(),
            _customerBatchController.text.trim(),
            _paymentMode);
      } else {
        await editSale(
            widget.saleID,
            validBooks,
            grandTotal,
            _customerNameController.text.trim(),
            _customerBatchController.text.trim(),
            _paymentMode);
      }

      widget.updateUI();
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please add/complete book details'),
            actions: [
              TextButton(
                autofocus: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    }
  }

  void _updateGrandTotal() {
    double tempTotal = 0;

    for (SaleItemBookModel i in booksToCheckout) {
      if (i.bookID != '') {
        for (var pv in i.purchaseVariants) {
          tempTotal = tempTotal +
              (pv.soldPrice != 0
                      ? pv.soldPrice
                      : allBooksWithPurchases[i.bookID]?[pv.purchaseID]
                          ?['price'] as double) *
                  pv.quantity;
        }
      }
    }

    setState(() {
      grandTotal = tempTotal;
    });
  }

  /// Store selected books for using in excludeIDS
  void _updateSelectedBookIDs() {
    final List<String> tempArr = [];

    for (SaleItemBookModel i in booksToCheckout) {
      if (i.bookID != '') {
        tempArr.add(i.bookID);
      }
    }

    setState(() {
      selectedBookIDs = tempArr;
    });
  }

  void setData() async {
    List<String> savedPurchaseIDs = [];
    List<SaleItemBookModel> tempBooksCheckout = [];
    String tempPaymentMode = PaymentModes.cash;
    double tempGrandTotal = 0;

    if (widget.saleID != '') {
      final temp = await getSaleData(widget.saleID);
      if (temp != null) {
        _customerNameController =
            TextEditingController(text: temp.customerName);
        _customerBatchController =
            TextEditingController(text: temp.customerBatch);

        tempBooksCheckout = temp.books;
        tempPaymentMode = temp.paymentMode;
        tempGrandTotal = temp.grandTotal;

        for (SaleItemBookModel b in temp.books) {
          for (SaleItemBookPurchaseVariantModel p in b.purchaseVariants) {
            savedPurchaseIDs.add(p.purchaseID);
          }
        }
      }
    }

    final tempBookPurchases = await getBookWithPurchases(savedPurchaseIDs);
    final tempBooks = await getBooks();

    setState(() {
      allBooksWithPurchases = tempBookPurchases;
      allBooks = tempBooks;

      booksToCheckout = tempBooksCheckout;
      _paymentMode = tempPaymentMode;
      grandTotal = tempGrandTotal;

      didSetData = true;
    });

    _updateSelectedBookIDs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didSetData) {
      setData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '${widget.saleID == '' ? 'New' : 'Edit'} Sale',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () {
              showModalCloseConfirmation(context);
            })
      ]),
      const SizedBox(height: 20.0),
      Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              border: Border.all(
                  width: 1, color: const Color.fromARGB(255, 208, 204, 204)),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Books',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Column(
                children: List.generate(booksToCheckout.length, (index) {
              return SaleItemBookWidget(
                  key: Key(index.toString()),
                  allBooksWithPurchases: allBooksWithPurchases,
                  allBooks: allBooks,
                  savedData: booksToCheckout[index],
                  selectedBookIDs: selectedBookIDs,
                  updateData: (
                      {String? bkId,
                      String? prchID,
                      bool? selected,
                      double? prc,
                      double? dsPr,
                      int? qty}) {
                    if (bkId != null) {
                      booksToCheckout[index].bookID = bkId;
                      booksToCheckout[index].purchaseVariants = [];
                      _updateSelectedBookIDs();
                    }

                    if (prchID != null) {
                      if (selected != null) {
                        if (selected) {
                          booksToCheckout[index].purchaseVariants.add(
                              SaleItemBookPurchaseVariantModel(
                                  purchaseID: prchID,
                                  soldPrice: 0,
                                  quantity: 0));
                        } else {
                          booksToCheckout[index]
                              .purchaseVariants
                              .removeWhere((pv) => pv.purchaseID == prchID);
                        }
                      } else {
                        var pvItm = booksToCheckout[index]
                            .purchaseVariants
                            .firstWhere((pv) => pv.purchaseID == prchID,
                                orElse: emptySaleItemBookPurchaseVariant);
                        if (dsPr != null) {
                          pvItm.soldPrice = dsPr;
                        }
                        if (qty != null) {
                          pvItm.quantity = qty;
                        }
                      }
                    }

                    _updateGrandTotal();
                  },
                  onClickDelete: () {
                    setState(() {
                      booksToCheckout.removeAt(index);
                    });

                    _updateGrandTotal();
                    _updateSelectedBookIDs();
                  });
            })),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomButton(
                  label: 'Add book',
                  backgroundColor: Colors.white,
                  textColor: Colors.blueGrey,
                  onPressed: () {
                    setState(() {
                      booksToCheckout.add(emptyBookSaleItem());
                    });
                  })
            ])
          ])),
      const SizedBox(height: 30),
      Row(children: [
        Expanded(
            child: TextField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 2)),
                    filled: true,
                    fillColor: Colors.white,
                    hoverColor: Colors.transparent,
                    hintText: 'Customer name'),
                controller: _customerNameController)),
        const SizedBox(width: 10),
        Expanded(
            child: TextField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 2)),
                    filled: true,
                    fillColor: Colors.white,
                    hoverColor: Colors.transparent,
                    hintText: 'Customer batch'),
                controller: _customerBatchController))
      ]),
      const SizedBox(height: 20),
      Align(
          alignment: Alignment.centerRight,
          child: Text('Grand Total : $grandTotal',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
      const SizedBox(height: 20),
      Row(children: [
        const Expanded(
            child: Text('Payment Mode',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
        Expanded(
            child: RadioListTile<String>(
                title: const Text('Cash'),
                value: PaymentModes.cash,
                groupValue: _paymentMode,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _paymentMode = value;
                    });
                  }
                })),
        Expanded(
            child: RadioListTile<String>(
                title: const Text('UPI'),
                value: PaymentModes.upi,
                groupValue: _paymentMode,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _paymentMode = value;
                    });
                  }
                })),
        Expanded(
            child: RadioListTile<String>(
                title: const Text('Card'),
                value: PaymentModes.card,
                groupValue: _paymentMode,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _paymentMode = value;
                    });
                  }
                }))
      ]),
      const SizedBox(height: 30),
      CustomButton(onPressed: _handleSubmit, label: 'Submit')
    ]);
  }
}
