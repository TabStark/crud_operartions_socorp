import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operartions/Model/crud_model.dart';

class Apis {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // READ
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return firebaseFirestore.collection('PRODUCTS').snapshots();
  }

// CREATE
  static Future<void> createDataInFirebase(
      String name, String subname, String price) async {
    final CrudModel createdata =
        CrudModel(Price: int.parse(price), Name: name, SubName: subname);
    await firebaseFirestore
        .collection('PRODUCTS')
        .doc()
        .set(createdata.toJson());
  }

  // UPDATE
  static Future<void> updateDataInFirebase(
      String name, String subname, String price, String productid) async {
    final CrudModel updatedata =
        CrudModel(Price: int.parse(price), Name: name, SubName: subname);
    await firebaseFirestore
        .collection('PRODUCTS')
        .doc(productid)
        .update(updatedata.toJson());
  }

  // DELETE
  Future<void> deletedata(String productid) async {
    await firebaseFirestore.collection('PRODUCTS').doc(productid).delete();
  }
}
