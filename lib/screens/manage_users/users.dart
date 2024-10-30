import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';
import 'package:vadavathoor_book_stall/screens/manage_users/user_modal.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

class UsersWidget extends StatefulWidget {
  const UsersWidget({super.key});

  @override
  State<UsersWidget> createState() => _UsersState();
}

class _UsersState extends State<UsersWidget> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];

  int currentPage = 0;
  final int itemsPerPage = 50;
  String searchQuery = '';
  int sortColumnIndex = 0;
  Map<int, bool> sortOrder = {0: true};

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = users.where((u) {
        return u.name.toLowerCase().contains(query.toLowerCase()) ||
            u.username.toLowerCase().contains(query.toLowerCase());
      }).toList();
      currentPage = 0;
    });
  }

  void sortItems(int column) {
    setState(() {
      sortOrder[column] = !sortOrder[column]!;
      bool ascending = sortOrder[column]!;

      switch (column) {
        case 0:
          filteredUsers.sort((a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          break;
      }

      sortColumnIndex = column;
    });
  }

  onPressNewUser() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        double dialogWidth = screenSize.width * 0.6;
        double dialogHeight = screenSize.height * 0.4;

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
                child: UsermodalWidget(
                    mode: UserModalMode.add,
                    updateUI: () {
                      setData();
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ),
        );
      },
    );
  }

  onPressEdit(UserModel selectedUser) {
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
                child: UsermodalWidget(
                    mode: UserModalMode.edit,
                    data: selectedUser,
                    updateUI: () {
                      setData();
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ),
        );
      },
    );
  }

  onPressDelete(String selectedUserID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                deleteUser(selectedUserID).then((_) {
                  setData();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void setData() async {
    final loggedInUser = Provider.of<UserProvider>(context, listen: false);
    List<UserModel> tempData = await getUsers();

    //If logged in user is not developer, then filter out developer users.
    if (loggedInUser.user.role != UserRole.developer) {
      tempData = tempData.where((i) => i.role != UserRole.developer).toList();
    }

    setState(() {
      users = tempData;
      filteredUsers = users;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (cntx, loggedInUser, _) {
      final totalPages = (filteredUsers.length / itemsPerPage).ceil();
      final startIndex = currentPage * itemsPerPage;
      final endIndex = startIndex + itemsPerPage < filteredUsers.length
          ? startIndex + itemsPerPage
          : filteredUsers.length;

      return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                    width: 300,
                    child: TextField(
                        onChanged: updateSearchQuery,
                        decoration: const InputDecoration(
                            labelText: 'Search name or usenname',
                            border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 0
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                          }
                        : null,
                  ),
                  Text('Page ${currentPage + 1} of ${totalPages}',
                      style: const TextStyle(fontSize: 14)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages - 1
                        ? () {
                            setState(() {
                              currentPage++;
                            });
                          }
                        : null,
                  ),
                ]),
                const SizedBox(width: 10),
                if (loggedInUser.user.userID != '')
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: onPressNewUser,
                      child: const Text('Add User',
                          style: TextStyle(color: Colors.white)))
              ]),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortOrder[sortColumnIndex]!,
                    columns: [
                      DataColumn(
                        label: const Text('Name'),
                        onSort: (columnIndex, _) => sortItems(0),
                      ),
                      const DataColumn(label: Text('Username')),
                      const DataColumn(label: Text('Role')),
                      const DataColumn(label: Text('Status')),
                      const DataColumn(label: Text('Created Date')),
                      const DataColumn(label: Text('')),
                    ],
                    rows: filteredUsers
                        .sublist(startIndex, endIndex)
                        .map((user) => DataRow(cells: [
                              DataCell(Text(user.name)),
                              DataCell(Text(user.username)),
                              DataCell(Text(getRoleName(user.role))),
                              DataCell(Text(getStatusName(user.status))),
                              DataCell(Text(formatTimestamp(
                                  timestamp: user.createdDate))),
                              DataCell(Row(children: [
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      onPressEdit(user);
                                    }),
                                //Logged user cannot delete himself
                                user.userID == loggedInUser.user.userID
                                    ? const SizedBox(width: 40)
                                    : IconButton(
                                        icon: const Icon(Icons.delete),
                                        tooltip: 'Delete',
                                        onPressed: () {
                                          onPressDelete(user.userID);
                                        })
                              ]))
                            ]))
                        .toList()),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.2, color: Colors.blueGrey)))),
            ]),
          ));
    });
  }
}
