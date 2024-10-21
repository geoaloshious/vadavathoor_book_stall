import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/classes/books.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/components/edit_modal.dart';

class StationaryItemsWidget extends StatefulWidget {
  const StationaryItemsWidget({super.key});

  @override
  State<StationaryItemsWidget> createState() => _StationaryItemsState();
}

class _StationaryItemsState extends State<StationaryItemsWidget> {
  final _nameController = TextEditingController();
  List<StationaryListItemModel> items = [];

  void add() async {
    final name = _nameController.text.trim();
    if (name != '') {
      await addStationaryItem(name);
      _nameController.clear();
      setData();
    }
  }

  onPressEdit(StationaryListItemModel selectedItem) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

          return Dialog(
              child: Container(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.4),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                          child: EditModalWidget(
                              title: 'Item',
                              name: selectedItem.itemName,
                              saveData: (name) {
                                editStationaryItem(selectedItem.itemID, name)
                                    .then((_) {
                                  setData();
                                  Navigator.of(context).pop();
                                });
                              })))));
        });
  }

  onPressDelete(String selectedID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () {
                      deleteStationaryItem(selectedID).then((_) {
                        setData();
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text('Delete'))
              ]);
        });
  }

  void setData() async {
    final temp = await getStationaryItemList();
    setState(() {
      items = temp;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (cntx, user, _) {
      final loggedIn = user.user.userID != '';

      return Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (loggedIn)
              Row(children: [
                Expanded(
                    child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Item Name'),
                        controller: _nameController)),
                const SizedBox(width: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: add,
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)))
              ]),
            if (loggedIn) const SizedBox(height: 20),
            Row(children: [
              const Text('Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              if (loggedIn) const SizedBox(width: 80)
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.blueGrey)))),
            Expanded(
                child: items.isNotEmpty
                    ? ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => Row(children: [
                              Expanded(child: Text(items[index].itemName)),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      onPressEdit(items[index]);
                                    }),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      onPressDelete(items[index].itemID);
                                    })
                            ]))
                    : const Text("No records found"))
          ]));
    });
  }
}
