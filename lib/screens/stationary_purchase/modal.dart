import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/components/modal_close_confirmation.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/models/stationary_item.dart';

import '../../classes.dart';
import '../../components/drop_down.dart';

class StationaryPurchaseModalWidget extends StatefulWidget {
  final PurchaseListItemModel? data;
  final void Function() updateUI;

  const StationaryPurchaseModalWidget(
      {super.key, this.data, required this.updateUI});

  @override
  State<StationaryPurchaseModalWidget> createState() =>
      _StationaryPurchaseModalState();
}

class _StationaryPurchaseModalState
    extends State<StationaryPurchaseModalWidget> {
  var _quantityController = TextEditingController();
  var _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _itemID = '';
  Map<String, bool> inputErrors = {};

  List<StationaryItemModel> items = [];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }

    //#pending - do we need an option to pick time
    // final TimeOfDay? timePicked = await showTimePicker(
    //     context: context, initialTime: TimeOfDay.fromDateTime(_selectedDate));
  }

  void _saveData() async {
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final purchaseDate = _selectedDate.millisecondsSinceEpoch;

    Map<String, bool> tempInputErrors = {};

    if (quantity == 0) {
      tempInputErrors['quantity'] = true;
    }

    if (price == 0) {
      tempInputErrors['price'] = true;
    }

    if (tempInputErrors.isEmpty) {
      if (widget.data != null) {
        editStationaryPurchase(
                widget.data!.purchaseID, _itemID, quantity, price, purchaseDate)
            .then((res) {
          if (res['message'] == null) {
            widget.updateUI();
            Navigator.of(context).pop();
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
      } else {
        await addStationaryPurchase(_itemID, purchaseDate, price, quantity);
        widget.updateUI();
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() async {
    if (widget.data != null) {
      _itemID = widget.data!.itemID;

      _selectedDate =
          DateTime.fromMillisecondsSinceEpoch(widget.data!.purchaseDate);

      _quantityController = TextEditingController(
          text: widget.data!.quantityPurchased.toString());
      _priceController =
          TextEditingController(text: widget.data!.price.toString());
    }

    final tempItems = await getStationaryItems();

    setState(() {
      items = tempItems;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${widget.data == null ? 'Add' : 'Edit'} Purchase',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () {
              showModalCloseConfirmation(context);
            }),
      ]),
      const SizedBox(height: 10.0),
      Row(children: [
        Expanded(
            child: CustomDropdown(
                items: items.map((i) => i.toDropdownData()).toList(),
                selectedValue: _itemID,
                label: 'Select item',
                hasError: inputErrors['item'] == true,
                onValueChanged: (value) {
                  if (_itemID != value) {
                    setState(() {
                      _itemID = value;
                      inputErrors = {...inputErrors, 'item': false};
                    });
                  }
                })),
        const SizedBox(width: 16.0),
        Expanded(
            child: TextField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['quantity'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'quantity': false};
                  });
                }))
      ]),
      const SizedBox(height: 20.0),
      Row(children: [
        Expanded(
            child: TextField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                    labelText: 'Price',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['price'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'price': false};
                  });
                })),
        const SizedBox(width: 16.0),
        Expanded(
            child: GestureDetector(
                onTap: _selectDate,
                child: InputDecorator(
                    decoration: const InputDecoration(
                        labelText: 'Purchase Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder()),
                    child:
                        Text(DateFormat('yyyy-MM-dd').format(_selectedDate)))))
      ]),
      const SizedBox(height: 20.0),
      ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          onPressed: _saveData,
          child: const Text('Submit', style: TextStyle(color: Colors.white)))
    ]);
  }
}
