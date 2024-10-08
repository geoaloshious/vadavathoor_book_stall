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

  onPressDelete(int selectedUserID) {
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
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (loggedInUser.user.userID != 0)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: onPressNewUser,
                    child: const Text('Add User',
                        style: TextStyle(color: Colors.white)))
            ]),
            const SizedBox(height: 20),
            const Row(children: [
              Expanded(
                  child: Text('Name',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Username',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Role',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Status',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('Created Date',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              SizedBox(width: 80)
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.2, color: Colors.blueGrey)))),
            Expanded(
                child: users.isNotEmpty
                    ? ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) => Row(children: [
                              Expanded(child: Text(users[index].name)),
                              Expanded(child: Text(users[index].username)),
                              Expanded(
                                  child: Text(getRoleName(users[index].role))),
                              Expanded(
                                  child:
                                      Text(getStatusName(users[index].status))),
                              Expanded(
                                  child: Text(formatTimestamp(
                                      timestamp: users[index].createdDate))),
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    onPressEdit(users[index]);
                                  }),
                              //Logged user cannot delete himself
                              users[index].userID == loggedInUser.user.userID
                                  ? const SizedBox(width: 40)
                                  : IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Delete',
                                      onPressed: () {
                                        onPressDelete(users[index].userID);
                                      })
                            ]))
                    : const Text("No records found"))
          ]));
    });
  }
}
