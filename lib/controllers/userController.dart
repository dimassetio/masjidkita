import 'package:mosq/integrations/firestore.dart';
import 'package:mosq/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static CollectionReference user =
      FirebaseFirestore.instance.collection('users');

  static Future<DocumentSnapshot> getUsers(String id) async {
    return await user.doc(id).get();
  }

  Stream<List<UserModel>> userStream() {
    return firebaseFirestore
        .collection("users")
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(UserModel.fromSnapshot(element));
      });
      return retVal;
    });
  }

  RxList<UserModel> userList = RxList<UserModel>();

  List<UserModel> get users => userList.value;

  @override
  void onInit() {
    userList.bindStream(userStream());
  }

  static CollectionReference userData =
      FirebaseFirestore.instance.collection('users');

  Future getUserList() async {
    List itemsList = [];

    try {
      await userData.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
