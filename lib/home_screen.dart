import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operartions/APIS/apis.dart';
import 'package:crud_operartions/Model/crud_model.dart';
import 'package:crud_operartions/main.dart';
import 'package:crud_operartions/utils/flushbar.dart';
import 'package:crud_operartions/utils/reusable_textfield.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference product =
      FirebaseFirestore.instance.collection('PRODUCTS');
  final _form = GlobalKey<FormState>();

  TextEditingController _NameController = TextEditingController();
  TextEditingController _SubNameController = TextEditingController();
  TextEditingController _PriceController = TextEditingController();
  List<CrudModel> _listItems = [];
  bool updateitem = false;
  String updateDataDocId = '';
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CRUD Operation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SizedBox(
        height: mq.height * 1,
        width: mq.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: mq.height * .3,
              width: mq.width * .5,
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // NAME
                        SizedBox(
                          width: mq.width * .23,
                          height: mq.height * .07,
                          child: ReusableTextField(
                            controller: _NameController,
                            hinttxt: 'Name',
                            keyboardType: 'TextInputType.name',
                          ),
                        ),

                        // SUB NAME
                        SizedBox(
                          width: mq.width * .23,
                          height: mq.height * .07,
                          child: ReusableTextField(
                            controller: _SubNameController,
                            hinttxt: 'Sub Name',
                            keyboardType: 'TextInputType.name',
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //  PRICE
                        SizedBox(
                          width: mq.width * .3,
                          height: mq.height * .07,
                          child: ReusableTextField(
                            controller: _PriceController,
                            hinttxt: 'Price',
                            keyboardType: 'TextInputType.number',
                          ),
                        ),

                        // ADD and UPDATE BUTTON
                        SizedBox(
                          width: mq.width * .15,
                          height: mq.height * .07,
                          child: ElevatedButton(
                            onPressed: () async {
                              updateitem ? updatefun() : createfun();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text(
                              updateitem ? 'Update' : 'Add',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream: Apis.getMyUserId(),
                builder: (context, snapShot) {
                  switch (snapShot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapShot.data!.docs;
                      _listItems = data
                          .map((e) => CrudModel.fromJson(e.data()))
                          .toList();
                      return Container(
                        padding: EdgeInsets.all(20),
                        height: mq.height * .6,
                        width: mq.width * .5,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _listItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(3),
                                  height: 60,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // READ NAME, SUBNAME & PRICE
                                      Container(
                                        width: mq.width * .3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(_listItems[index].Name),
                                                Text(_listItems[index].SubName)
                                              ],
                                            ),
                                            Text(
                                              '₹ ${_listItems[index].Price.toString()}',
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),

                                      // UPDATE & DELETE BUTTOn
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  updateDataintextField(
                                                      _listItems[index].Name,
                                                      _listItems[index].SubName,
                                                      _listItems[index]
                                                          .Price
                                                          .toString());
                                                  updateDataDocId = snapShot
                                                      .data!
                                                      .docs[index]
                                                      .reference
                                                      .id;
                                                },
                                                icon: Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () async {
                                                  // DELETE DATA
                                                  updateitem
                                                      ? customflushbar.showFlushBar(
                                                          context,
                                                          'First update the Data')
                                                      : await Apis()
                                                          .deletedata(snapShot
                                                              .data!
                                                              .docs[index]
                                                              .reference
                                                              .id)
                                                          .then((value) {
                                                          customflushbar
                                                              .showFlushBar(
                                                                  context,
                                                                  'Data Deleted Successfully');
                                                          setState(() {});
                                                        });
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      );
                  }
                }),
          ],
        ),
      ),
    );
  }

  // Condition and Create Data in Firebase
  void createfun() async {
    if (_form.currentState!.validate()) {
      await Apis.createDataInFirebase(_NameController.text,
              _SubNameController.text, _PriceController.text)
          .then((value) {
        _NameController.text = '';
        _SubNameController.text = '';
        _PriceController.text = '';
        customflushbar.showFlushBar(context, 'Data Added Successfully');
        setState(() {});
      });
    }
  }

  // Condition and Update Data in Firebase
  void updatefun() async {
    if (_form.currentState!.validate()) {
      await Apis.updateDataInFirebase(_NameController.text,
              _SubNameController.text, _PriceController.text, updateDataDocId)
          .then((value) {
        _NameController.text = '';
        _SubNameController.text = '';
        _PriceController.text = '';
        updateDataDocId = '';
        customflushbar.showFlushBar(context, 'Data Updated Successfully');
        setState(() {
          updateitem = false;
        });
      });
    }
  }

  // Auto fill Fields for Update
  void updateDataintextField(String name, String subname, String price) {
    _NameController.text = name;
    _SubNameController.text = subname;
    _PriceController.text = price;
    setState(() {
      updateitem = true;
    });
  }
}
