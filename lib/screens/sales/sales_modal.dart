import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/components/modal_close_confirmation.dart';
import 'package:vadavathoor_book_stall/components/button.dart';
import 'package:vadavathoor_book_stall/components/search_popup.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';
import 'package:vadavathoor_book_stall/screens/sales/sale_item.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

class SaleModalWidget extends StatefulWidget {
  final String saleID;
  final void Function() updateUI;

  const SaleModalWidget(
      {super.key, required this.saleID, required this.updateUI});

  @override
  State<SaleModalWidget> createState() => _SaleModalState();
}

class _SaleModalState extends State<SaleModalWidget> {
  TextEditingController _billNoController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerBatchController = TextEditingController();

  bool newUser = false;
  bool newBatch = false;
  String _selectedUserID = '';
  String _selectedBatchID = '';
  List<UserModelForSales> users = [];
  List<UserBatchModel> userBatches = [];

  List<SaleItemModel> booksToCheckout = [];
  List<SaleItemModel> stationaryItemsToCheckout = [];
  double grandTotal = 0;
  List<String> selectedBookIDs = [];
  List<String> selectedStationaryIDs = [];
  String _paymentMode = PaymentModes.cash;
  Map<String, Map<String, Map<String, Object>>> allBooksWithPurchases = {};
  Map<String, Map<String, Map<String, Object>>>
      allStationaryItemsWithPurchases = {};
  List<BookModel> allBooks = [];
  List<StationaryItemModel> allStationaryItems = [];

  Map<String, bool> inputErrors = {};

  bool didSetData = false;

  Future<void> _handleSubmit() async {
    final billNo = _billNoController.text.trim();
    final customerName = _customerNameController.text.trim();
    final customerBatch = _customerBatchController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (billNo == '') {
      tempInputErrors['billNo'] = true;
    }

    if (newUser) {
      if (customerName == '') {
        tempInputErrors['customerName'] = true;
      }

      if (newBatch) {
        if (customerBatch == '') {
          tempInputErrors['customerBatchName'] = true;
        }
      } else if (_selectedBatchID == '') {
        tempInputErrors['customerBatch'] = true;
      }
    } else if (_selectedUserID == '') {
      tempInputErrors['customer'] = true;
    }

    if (tempInputErrors.isEmpty) {
      /**
       * Below statement following things:
       * Checks whether any purchases selected
       * Checks whether quantity > 0 in purchases
       * Copy original price to sold price if not specified.
       */
      final validBooks = booksToCheckout.where((bk) {
        final List<SaleItemPurchaseVariantModel> validPVs = [];

        for (var pv in bk.purchaseVariants) {
          if (pv.soldPrice == 0) {
            pv.soldPrice = allBooksWithPurchases[bk.itemID]?[pv.purchaseID]
                ?['price'] as double;
          }

          if (pv.quantity > 0) {
            validPVs.add(pv);
          }
        }

        bk.purchaseVariants = validPVs;

        return validPVs.isNotEmpty;
      }).toList();

      final validStationaryItems = stationaryItemsToCheckout.where((itm) {
        final List<SaleItemPurchaseVariantModel> validPVs = [];

        for (var pv in itm.purchaseVariants) {
          if (pv.soldPrice == 0) {
            pv.soldPrice = allStationaryItemsWithPurchases[itm.itemID]
                ?[pv.purchaseID]?['price'] as double;
          }

          if (pv.quantity > 0) {
            validPVs.add(pv);
          }
        }

        itm.purchaseVariants = validPVs;

        return validPVs.isNotEmpty;
      }).toList();

      if (validBooks.isNotEmpty || validStationaryItems.isNotEmpty) {
        if (widget.saleID == '') {
          await addSale(
              billNo,
              validBooks,
              validStationaryItems,
              grandTotal,
              _selectedUserID,
              _customerNameController.text.trim(),
              _selectedBatchID,
              _customerBatchController.text.trim(),
              _paymentMode);
        } else {
          await editSale(
              widget.saleID,
              billNo,
              validBooks,
              validStationaryItems,
              grandTotal,
              _selectedUserID,
              _customerNameController.text.trim(),
              _selectedBatchID,
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
                        child: const Text('OK'))
                  ]);
            });
      }
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void _updateGrandTotal() {
    double tempTotal = 0;

    for (SaleItemModel i in booksToCheckout) {
      if (i.itemID != '') {
        for (var pv in i.purchaseVariants) {
          tempTotal = tempTotal +
              (pv.soldPrice != 0
                      ? pv.soldPrice
                      : allBooksWithPurchases[i.itemID]?[pv.purchaseID]
                          ?['price'] as double) *
                  pv.quantity;
        }
      }
    }

    for (SaleItemModel i in stationaryItemsToCheckout) {
      if (i.itemID != '') {
        for (var pv in i.purchaseVariants) {
          tempTotal = tempTotal +
              (pv.soldPrice != 0
                      ? pv.soldPrice
                      : allStationaryItemsWithPurchases[i.itemID]
                          ?[pv.purchaseID]?['price'] as double) *
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

    for (SaleItemModel i in booksToCheckout) {
      if (i.itemID != '') {
        tempArr.add(i.itemID);
      }
    }

    setState(() {
      selectedBookIDs = tempArr;
    });
  }

  void _updateSelectedStationaryIDs() {
    final List<String> tempArr = [];

    for (SaleItemModel i in stationaryItemsToCheckout) {
      if (i.itemID != '') {
        tempArr.add(i.itemID);
      }
    }

    setState(() {
      selectedStationaryIDs = tempArr;
    });
  }

  void setData() async {
    List<String> savedPurchaseIDs = [];
    List<SaleItemModel> tempBooksCheckout = [];
    List<SaleItemModel> tempSIsCheckout = [];
    String tempPaymentMode = PaymentModes.cash;
    double tempGrandTotal = 0;
    String tempCustomerID = '';
    String tempBillNo = '';

    if (widget.saleID != '') {
      final temp = await getSaleData(widget.saleID);
      if (temp != null) {
        tempBillNo = temp.billNo;
        tempBooksCheckout = temp.books;
        tempSIsCheckout = temp.stationaryItems;
        tempPaymentMode = temp.paymentMode;
        tempGrandTotal = temp.grandTotal;
        tempCustomerID = temp.customerID;

        for (SaleItemModel b in temp.books) {
          for (SaleItemPurchaseVariantModel p in b.purchaseVariants) {
            savedPurchaseIDs.add(p.purchaseID);
          }
        }
      }
    } else {
      tempBillNo = await getNewSaleBillNo();
    }

    final tempBookPurchases = await getBookWithPurchases(savedPurchaseIDs);
    final tempSIPurchases =
        await getStationaryItemsWithPurchases(savedPurchaseIDs);
    final tempBooks = await getBooks();
    final tempSIs = await getStationaryItems();
    final tempUsers = await getUsersForSales();
    final tempUserBatches = await getUserBatchList();

    setState(() {
      allBooksWithPurchases = tempBookPurchases;
      allStationaryItemsWithPurchases = tempSIPurchases;
      allBooks = tempBooks;
      allStationaryItems = tempSIs;
      users = tempUsers;
      userBatches = tempUserBatches;
      _selectedUserID = tempCustomerID;

      booksToCheckout = tempBooksCheckout;
      stationaryItemsToCheckout = tempSIsCheckout;
      _paymentMode = tempPaymentMode;
      grandTotal = tempGrandTotal;

      _billNoController = TextEditingController(text: tempBillNo);

      didSetData = true;
    });

    _updateSelectedBookIDs();
    _updateSelectedStationaryIDs();
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
      Row(children: [
        const Text('Bill number', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 10),
        SizedBox(
          width: 300,
          child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: inputErrors['billNo'] == true
                        ? const BorderSide(color: Colors.red, width: 2)
                        : const BorderSide(color: Colors.grey, width: 1)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.transparent,
              ),
              controller: _billNoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  inputErrors = {...inputErrors, 'billNo': false};
                });
              }),
        )
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
              return SaleItemWidget(
                  key: Key(index.toString()),
                  allPurchases: allBooksWithPurchases,
                  dropdownData:
                      allBooks.map((i) => i.toDropdownData()).toList(),
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
                      booksToCheckout[index].itemID = bkId;
                      booksToCheckout[index].purchaseVariants = [];
                      _updateSelectedBookIDs();
                    }

                    if (prchID != null) {
                      if (selected != null) {
                        if (selected) {
                          booksToCheckout[index].purchaseVariants.add(
                              SaleItemPurchaseVariantModel(
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
                  label: '+ Add',
                  backgroundColor: Colors.white,
                  textColor: Colors.blueGrey,
                  onPressed: () {
                    setState(() {
                      booksToCheckout.add(emptyBookSaleItem());
                    });
                  })
            ])
          ])),
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
            const Text('Stationary Items',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Column(
                children:
                    List.generate(stationaryItemsToCheckout.length, (index) {
              return SaleItemWidget(
                  key: Key(index.toString()),
                  allPurchases: allStationaryItemsWithPurchases,
                  dropdownData: allStationaryItems
                      .map((i) => i.toDropdownData())
                      .toList(),
                  savedData: stationaryItemsToCheckout[index],
                  selectedBookIDs: selectedStationaryIDs,
                  updateData: (
                      {String? bkId,
                      String? prchID,
                      bool? selected,
                      double? prc,
                      double? dsPr,
                      int? qty}) {
                    if (bkId != null) {
                      stationaryItemsToCheckout[index].itemID = bkId;
                      stationaryItemsToCheckout[index].purchaseVariants = [];
                      _updateSelectedStationaryIDs();
                    }

                    if (prchID != null) {
                      if (selected != null) {
                        if (selected) {
                          stationaryItemsToCheckout[index].purchaseVariants.add(
                              SaleItemPurchaseVariantModel(
                                  purchaseID: prchID,
                                  soldPrice: 0,
                                  quantity: 0));
                        } else {
                          stationaryItemsToCheckout[index]
                              .purchaseVariants
                              .removeWhere((pv) => pv.purchaseID == prchID);
                        }
                      } else {
                        var pvItm = stationaryItemsToCheckout[index]
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
                      stationaryItemsToCheckout.removeAt(index);
                    });

                    _updateGrandTotal();
                    _updateSelectedStationaryIDs();
                  });
            })),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomButton(
                  label: '+ Add',
                  backgroundColor: Colors.white,
                  textColor: Colors.blueGrey,
                  onPressed: () {
                    setState(() {
                      stationaryItemsToCheckout.add(emptyBookSaleItem());
                    });
                  })
            ])
          ])),
      const SizedBox(height: 30),
      Row(
        children: [
          const Text('Customer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: CheckboxListTile(
                title: const Text('New'),
                value: newUser,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    newUser = value ?? false;
                    _selectedUserID = '';
                  });
                }),
          ),
          Expanded(
              child: newUser
                  ? Row(children: [
                      Expanded(
                          child: TextField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          inputErrors['customerName'] == true
                                              ? const BorderSide(
                                                  color: Colors.red, width: 2)
                                              : const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey, width: 2)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.transparent,
                                  hintText: 'Customer name'),
                              controller: _customerNameController,
                              onChanged: (value) {
                                setState(() {
                                  inputErrors = {
                                    ...inputErrors,
                                    'customerName': false
                                  };
                                });
                              })),
                      SizedBox(
                        width: 130,
                        child: CheckboxListTile(
                            title: const Text('New batch'),
                            value: newBatch,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                newBatch = value ?? false;
                                _selectedBatchID = '';
                              });
                            }),
                      ),
                      Expanded(
                          child: newBatch
                              ? TextField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: inputErrors[
                                                      'customerBatchName'] ==
                                                  true
                                              ? const BorderSide(
                                                  color: Colors.red, width: 2)
                                              : const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: 2)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hoverColor: Colors.transparent,
                                      hintText: 'Customer batch'),
                                  controller: _customerBatchController,
                                  onChanged: (value) {
                                    setState(() {
                                      inputErrors = {
                                        ...inputErrors,
                                        'customerBatchName': false
                                      };
                                    });
                                  })
                              : SearchablePopup(
                                  items: userBatches
                                      .map((i) => i.toDropdownData())
                                      .toList(),
                                  selectedValue: _selectedBatchID.toString(),
                                  label: 'Select batch',
                                  hasError:
                                      inputErrors['customerBatch'] == true,
                                  onValueChanged: (value) {
                                    setState(() {
                                      _selectedBatchID = value;
                                      inputErrors = {
                                        ...inputErrors,
                                        'customerBatch': false
                                      };
                                    });
                                  }))
                    ])
                  : Row(
                      children: [
                        Expanded(
                          child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.5,
                              child: SearchablePopup(
                                  items: users
                                      .map((i) => i.toDropdownData())
                                      .toList(),
                                  selectedValue: _selectedUserID.toString(),
                                  label: 'Select user',
                                  hasError: inputErrors['customer'] == true,
                                  onValueChanged: (value) {
                                    setState(() {
                                      _selectedUserID = value;
                                      inputErrors = {
                                        ...inputErrors,
                                        'customer': false
                                      };
                                    });
                                  })),
                        )
                      ],
                    ))
        ],
      ),
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
