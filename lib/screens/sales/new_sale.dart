import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/book_sale.dart';
import 'package:vadavathoor_book_stall/db/models/book_sale.dart';
import 'package:vadavathoor_book_stall/screens/sales/new_sale_item_book.dart';

class NewSaleWidget extends StatefulWidget {
  const NewSaleWidget({super.key});

  @override
  State<NewSaleWidget> createState() => _NewSaleState();
}

class _NewSaleState extends State<NewSaleWidget> {
  final _customerNameController = TextEditingController();
  final _customerBatchController = TextEditingController();
  Map<String, bool> inputErrors = {};
  bool _isStationaryChecked = false;
  bool _isBookChecked = false;
  List<SaleItemBookModel> selectedBooks = [];
  double grandTotal = 0;
  List<String> selectedBookIDs = [];

  List<ForNewSaleBookItem> books = [];

  Future<void> _handleSubmit() async {
    if (_isBookChecked || _isStationaryChecked) {
      if (selectedBookIDs.isNotEmpty) {
        await addBookSale(
            selectedBooks,
            grandTotal,
            _customerNameController.text.trim(),
            _customerBatchController.text.trim());

        Navigator.of(context).pop();
      }
    }
  }

  void _updateGrandTotal() {
    double tempTotal = 0;

    for (SaleItemBookModel i in selectedBooks) {
      if (i.bookID != '') {
        for (var pv in i.purchaseVariants) {
          tempTotal = tempTotal +
              ((int.tryParse(pv.soldPrice != ''
                          ? pv.soldPrice
                          : pv.originalPrice) ??
                      0) *
                  pv.quantity);
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

    for (SaleItemBookModel i in selectedBooks) {
      if (i.bookID != '') {
        tempArr.add(i.bookID);
      }
    }

    setState(() {
      selectedBookIDs = tempArr;
    });
  }

  void setBooks() async {
    final tempBooks = await getBooksWithPurchaseVariants();
    setState(() {
      books = tempBooks;
    });
  }

  @override
  void initState() {
    super.initState();
    setBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Sale',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'Are you sure you want to discard this sale?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Discard'),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Book'),
                value: _isBookChecked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    selectedBooks.clear();
                    if (value == true) {
                      selectedBooks.add(emptyBookSaleItem());
                    }
                    _updateSelectedBookIDs();

                    _isBookChecked = value ?? false;
                  });
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Stationary'),
                enabled: false,
                value: _isStationaryChecked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isStationaryChecked = value ?? false;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Visibility(
          visible: _isBookChecked,
          child: Column(
            children: [
              Column(
                  children: List.generate(
                selectedBooks.length,
                (index) {
                  return NewBookSaleItemWidget(
                    key: Key(index.toString()),
                    books: books,
                    selectedBookIDs: selectedBookIDs,
                    bookDataToSave: selectedBooks[index],
                    updateData: (
                        {String? bkId,
                        String? prchID,
                        String? add,
                        String? remove,
                        String? prc,
                        String? dsPr,
                        int? qty}) {
                      if (bkId != null) {
                        selectedBooks[index].bookID = bkId;
                        _updateSelectedBookIDs();
                      }
                      if (prchID != null) {
                        if (add != null && prc != null) {
                          selectedBooks[index].purchaseVariants.add(
                              SaleItemBookPurchaseVariantModel(
                                  purchaseID: prchID,
                                  originalPrice: prc,
                                  soldPrice: '',
                                  quantity: 0));
                        } else {
                          if (remove != null) {
                            selectedBooks[index]
                                .purchaseVariants
                                .removeWhere((pv) => pv.purchaseID == prchID);
                          } else {
                            var pvItm = selectedBooks[index]
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
                      }

                      _updateGrandTotal();
                    },
                    onClickDelete: () {
                      setState(() {
                        selectedBooks.removeAt(index);
                      });

                      _updateGrandTotal();
                      _updateSelectedBookIDs();
                    },
                  );
                },
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedBooks.add(emptyBookSaleItem());
                    });
                  },
                  child: const Text('Add item')),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Customer name'),
                controller: _customerNameController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Customer batch'),
                controller: _customerBatchController,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Grand Total : $grandTotal',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            )),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 20),
            )),
      ],
    );
  }
}
