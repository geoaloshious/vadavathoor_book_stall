import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/components/edit_modal.dart';

class UserBatchWidget extends StatefulWidget {
  const UserBatchWidget({super.key});

  @override
  State<UserBatchWidget> createState() => _UserBatchState();
}

class _UserBatchState extends State<UserBatchWidget> {
  final _nameController = TextEditingController();
  List<UserBatchModel> batchList = [];

  void add() async {
    final name = _nameController.text.trim();
    if (name != '') {
      await addUserBatch(name);
      _nameController.clear();
      setData();
    }
  }

  onPressEdit(UserBatchModel selectedItem) {
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
                              title: 'Batch',
                              name: selectedItem.batchName,
                              saveData: (name) {
                                editUserBatch(
                                        batchID: selectedItem.batchID,
                                        batchName: name)
                                    .then((_) {
                                  setData();
                                  Navigator.of(context).pop();
                                });
                              })))));
        });
  }

  onPressDelete(int selectedID) {
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
                    onPressed: () async {
                      editUserBatch(
                              batchID: selectedID, status: DBRowStatus.deleted)
                          .then((_) {
                        setData();
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text('Delete'))
              ]);
        });
  }

  void setData() async {
    final temp = await getUserBatchList();
    setState(() {
      batchList = temp;
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
      final loggedIn = user.user.userID != 0;

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
                            hintText: 'Batch Name'),
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
            Row(
              children: [
                const Text('Name',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                if (loggedIn) const SizedBox(width: 80)
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.blueGrey)))),
            Expanded(
                child: batchList.isNotEmpty
                    ? ListView.builder(
                        itemCount: batchList.length,
                        itemBuilder: (context, index) => Row(children: [
                              Expanded(child: Text(batchList[index].batchName)),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      onPressEdit(batchList[index]);
                                    }),
                              if (loggedIn)
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      onPressDelete(batchList[index].batchID);
                                    })
                            ]))
                    : const Text("No records found"))
          ]));
    });
  }
}
