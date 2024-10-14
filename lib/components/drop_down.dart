import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<Map<String, String>> items;
  final String selectedValue;
  final String label;
  final bool hasError;
  final bool? disabled;
  final List<String>? excludeIDs;
  final Function(String) onValueChanged;

  const CustomDropdown(
      {super.key,
      required this.items,
      required this.selectedValue,
      required this.label,
      required this.onValueChanged,
      required this.hasError,
      this.excludeIDs,
      this.disabled});

  @override
  CustomPopupDropdownState createState() => CustomPopupDropdownState();
}

class CustomPopupDropdownState extends State<CustomDropdown> {
  String getSelectedItemName() {
    if (widget.selectedValue.isNotEmpty && widget.selectedValue != '0') {
      String? itemName = widget.items.firstWhere(
          (i) => i['id'] == widget.selectedValue,
          orElse: () => {'name': ''})['name'];
      return itemName ?? '';
    } else {
      return widget.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      enabled: widget.disabled == null || widget.disabled == false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: widget.hasError ? Colors.red : Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                getSelectedItemName(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return widget.items.where((i) {
          if (widget.excludeIDs != null) {
            return widget.excludeIDs!.contains(i['id']) == false;
          } else {
            return true;
          }
        }).map((value) {
          return PopupMenuItem<String>(
            value: value['id'],
            child: Text(value['name']!),
          );
        }).toList();
      },
      onSelected: (String value) {
        widget.onValueChanged(value);
      },
    );
  }
}
