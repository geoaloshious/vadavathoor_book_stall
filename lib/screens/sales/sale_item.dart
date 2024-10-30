import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/components/search_popup.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';
import 'package:vadavathoor_book_stall/screens/sales/purchase_variant.dart';

class SaleItemWidget extends StatefulWidget {
  final Map<String, Map<String, Map<String, Object>>> allPurchases;
  final List<Map<String, String>> dropdownData;
  final SaleItemModel savedData;
  final List<String> selectedBookIDs;
  final VoidCallback onClickDelete;
  final void Function(
      {String? bkId,
      String? prchID,
      bool? selected,
      double? prc,
      double? dsPr,
      int? qty}) updateData;

  const SaleItemWidget(
      {super.key,
      required this.allPurchases,
      required this.dropdownData,
      required this.savedData,
      required this.selectedBookIDs,
      required this.onClickDelete,
      required this.updateData});

  @override
  State<SaleItemWidget> createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItemWidget> {
  ForNewSaleItem selectedItem = emptyForNewSaleItem();
  bool didSetData = false;

  void onChangeBook(String itemID) {
    final tempPurchases = widget.allPurchases[itemID]?.keys.map((purchaseID) {
      final p = widget.allPurchases[itemID]?[purchaseID];

      return ForNewSalePurchaseVariant(
          purchaseID: purchaseID,
          purchaseDate: p?['date'] as String,
          balanceStock: p?['balanceStock'] as int,
          originalPrice: p?['price'] as double,
          soldPrice: 0,
          quantitySold: 0,
          selected: false);
    }).toList();

    setState(() {
      selectedItem.itemID = itemID;
      if (tempPurchases != null) {
        selectedItem.purchases = tempPurchases;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didSetData &&
        widget.savedData.itemID != '' &&
        widget.allPurchases.keys.isNotEmpty) {
      final List<ForNewSalePurchaseVariant> tempPurchases = [];

      final bookPurchases = widget.allPurchases[widget.savedData.itemID];

      if (bookPurchases != null) {
        for (String purchaseID in bookPurchases.keys) {
          final p = bookPurchases[purchaseID];
          if (p != null) {
            final savedPV = widget.savedData.purchaseVariants
                .where((i) => i.purchaseID == purchaseID)
                .firstOrNull;

            tempPurchases.add(ForNewSalePurchaseVariant(
                purchaseID: purchaseID,
                purchaseDate: p['date'] as String,
                balanceStock:
                    (p['balanceStock'] as int) + (savedPV?.quantity ?? 0),
                originalPrice: p['price'] as double,
                soldPrice: savedPV?.soldPrice ?? 0,
                quantitySold: savedPV?.quantity ?? 0,
                selected: savedPV != null));
          }
        }
      }

      setState(() {
        selectedItem.itemID = widget.savedData.itemID;
        selectedItem.purchases = tempPurchases;

        didSetData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(children: [
                Expanded(
                  flex: 5,
                  child: SearchablePopup(
                      items: widget.dropdownData,
                      selectedValue: selectedItem.itemID,
                      label: 'Select Item',
                      hasError: false,
                      excludeIDs: widget.selectedBookIDs,
                      onValueChanged: (value) {
                        setState(() {
                          if (value != selectedItem.itemID) {
                            onChangeBook(value);
                            widget.updateData(bkId: selectedItem.itemID);
                          }
                        });
                      }),
                ),
                const SizedBox(width: 8),
                IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: widget.onClickDelete)
              ]),
              if (selectedItem.purchases.isNotEmpty) const SizedBox(height: 10),
              Column(
                  children:
                      List.generate(selectedItem.purchases.length, (index) {
                return PurchaseVariantWidget(
                    key: Key(index.toString()),
                    data: selectedItem.purchases[index],
                    updateData: ({bool? selected, double? dsPr, int? qty}) {
                      if (selected != null) {
                        setState(() {
                          selectedItem.purchases[index].selected = selected;
                        });
                      }

                      widget.updateData(
                          prchID: selectedItem.purchases[index].purchaseID,
                          selected: selected,
                          prc: selected == true
                              ? selectedItem.purchases[index].originalPrice
                              : null,
                          dsPr: dsPr,
                          qty: qty);
                    });
              }))
            ])));
  }
}
