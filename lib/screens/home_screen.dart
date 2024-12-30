import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/firebase_database/database_methods.dart';
import 'package:flutter_firebase_app/screens/add_new_data.dart';

import '../utils/show_toasts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? userStream;

  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  getInitaialUser() async {
    userStream = await DatabaseMethods().getUserData();
    setState(() {});
  }

  @override
  void initState() {
    getInitaialUser();
    super.initState();
  }

  Widget allUserDataList() {
    return StreamBuilder(
        stream: userStream,
        builder: (context, AsyncSnapshot snapShot) {
          return snapShot.hasData
              ? ListView.builder(
                  itemCount: snapShot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot userData = snapShot.data.docs[index];
                    return SizedBox(
                      height: 180.0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.purple.shade50,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.purple.shade700, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name :- ' + userData['Name'],
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Profession :- ' + userData['Profession'],
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Age :- ' + userData['Age'],
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.purple.shade100),
                                        onPressed: () {
                                          nameController.text =
                                              userData['Name'];
                                          professionController.text =
                                              userData['Profession'];
                                          ageController.text = userData['Age'];
                                          editUserDetail(userData['Id']);
                                        },
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.purple.shade700,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          deleteUserData(userData['Id']);
                                        },
                                        child: Text(
                                          'delete',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        title: Text(
          'Firebase Operations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNewData();
          }));
        },
      ),
      body: allUserDataList(),
    );
  }

  Future editUserDetail(String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit User Detail',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.purple.shade700,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Profession',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: professionController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Age',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: ageController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700),
                      onPressed: () async {
                        Map<String, dynamic> updatedUserData = {
                          "Name": nameController.text,
                          "Profession": professionController.text,
                          "Id": id,
                          "Age": ageController.text,
                        };
                        await DatabaseMethods()
                            .updateUserData(id, updatedUserData)
                            .then((value) {
                          Navigator.pop(context);
                          ShowToasts().getToast(
                              'Data Updated Successfully', Colors.green);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: Text(
                          'Update User',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future deleteUserData(String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 130.0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Are you sure ? Want to delete data ?',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700),
                      onPressed: () async {
                        await DatabaseMethods()
                            .deleteUserData(id)
                            .then((value) {
                          Navigator.pop(context);
                          ShowToasts().getToast(
                              'Data Deleted Successfully', Colors.red);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: Text(
                          'Delete User Data',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
