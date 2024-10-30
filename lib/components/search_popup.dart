import 'package:flutter/material.dart';

class SearchablePopup extends StatefulWidget {
  final List<Map<String, String>> items;
  final String selectedValue;
  final String label;
  final bool hasError;
  final bool? disabled;
  final List<String>? excludeIDs;
  final Function(String) onValueChanged;

  const SearchablePopup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.label,
    required this.onValueChanged,
    required this.hasError,
    this.excludeIDs,
    this.disabled,
  });

  @override
  SearchablePopupState createState() => SearchablePopupState();
}

class SearchablePopupState extends State<SearchablePopup> {
  String query = '';
  String buttonLabel = '';

  void _showDialog() {
    query = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Select Item",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration:
                            const InputDecoration(hintText: "Search..."),
                      ),
                      Expanded(
                        child: ListView(
                          children: widget.items
                              .where((item) {
                                if (widget.excludeIDs != null &&
                                    widget.excludeIDs!.contains(item['id'])) {
                                  return false;
                                }
                                return item['name']!
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              })
                              .map((item) => ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    title: Text(
                                      item['name']!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      widget.onValueChanged(item['id']!);
                                      Navigator.of(context).pop();
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

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
    return TextButton(
      onPressed: (widget.disabled == null || widget.disabled == false)
          ? _showDialog
          : null,
      style: TextButton.styleFrom(
          side: BorderSide(
              color: widget.hasError ? Colors.red : Colors.grey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              getSelectedItemName(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: widget.disabled == true ? Colors.grey : Colors.black),
            ),
          ),
          Icon(Icons.arrow_drop_down,
              color: widget.disabled == true ? Colors.grey : Colors.black),
        ],
      ),
    );
  }
}
