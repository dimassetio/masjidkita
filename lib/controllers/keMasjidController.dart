// @dart=2.9
import 'package:masjidkita/controllers/authController.dart';
import 'package:masjidkita/helpers/showLoading.dart';
import 'package:masjidkita/models/keMasjid.dart';
import 'package:masjidkita/models/user.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masjidkita/screens/fitur/Kelola_Masjid/KeMasjid.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:masjidkita/screens/inventaris/inventaris_page.dart';

class KeMasjidController extends GetxController {
  static KeMasjidController instance = Get.find();

  final authC = Get.find<AuthController>();

  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController photo_url = TextEditingController();

  String masjidCollection = "masjid";
  Rx<KeMasjidModel> keMasjidModel = KeMasjidModel().obs;

  KeMasjidModel get keMasjid => keMasjidModel.value;
  set keMasjid(KeMasjidModel value) => this.keMasjidModel.value = value;
  RxBool isLoggedIn = false.obs;

  final googleSignIn = GoogleSignIn();

  // @override
  // void onReady() {
  //   super.onReady();
  //   // firebaseUser = Rx<User>(auth.currentUser);
  //   // firebaseUser.bindStream(auth.userChanges());

  //   // ever(firebaseUser, _setLogStatus);
  //   // ever(firebaseUser, _setUserModel);
  // }
  @override
  void onInit() {
    super.onInit();
    _initializeKeMasjidModel(authC.firebaseUser.value.uid);
    _setMasjidStatus(keMasjid);
  }

  void testdata() {
    _initializeKeMasjidModel(authC.firebaseUser.value.uid);
    _setMasjidStatus(keMasjid);
  }

  _setMasjidStatus(KeMasjidModel keMasjid) {
    if (keMasjid == null) {
      toast("null");
    } else {
      toast("setted");
    }
    print(keMasjid);
  }

  _setKeMasjidModel() {
    try {
      _initializeKeMasjidModel(authC.firebaseUser.value.uid);
    } catch (e) {
      keMasjidModel.value = KeMasjidModel();
      print(e);
    }
  }

  // void signIn() async {
  //   try {
  //     // showLoading();
  //     await auth
  //         .signInWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((result) {
  //       String _userId = result.user.uid;
  //       _initializeUserModel(_userId);
  //       // userRef.set({
  //       //   "last_login": auth.currentUser.metadata.lastSignInTime,
  //       // });
  //       _clearControllers();
  //       print(firebaseUser);
  //       toast("Sign In Success");
  //       Get.back();
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     Get.snackbar("Sign In Failed", "Try again");
  //   }
  // }

  // void signUp() async {
  //   showLoading();
  //   try {
  //     await auth
  //         .createUserWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((result) {
  //       String _userId = result.user.uid;
  //       _addUserToFirestore(_userId);
  //       _initializeUserModel(_userId);
  //       _clearControllers();
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     Get.snackbar("Sign Up Failed", "Try again");
  //   }
  // }

  // void signOut() async {
  //   userModel.value = UserModel();
  //   auth.signOut();
  // }

  _addUserToFirestore(String userId) {
    firebaseFirestore.collection(masjidCollection).doc(userId).set({
      "nama": nama.text.trim(),
      "id": userId,
      "alamat": alamat.text.trim(),
      "photo_url": ""
    });
  }

  // _addUserGoogleToFirestore(String uid) {
  //   User user;
  //   firebaseFirestore.collection(usersCollection).doc(uid).set({
  //     "name": user.displayName,
  //     "id": uid,
  //     "email": user.email,
  //     "role": "user"
  //   });
  // }

  _initializeKeMasjidModel(String userId) async {
    try {
      keMasjidModel.value = await firebaseFirestore
          .collection(masjidCollection)
          .doc(userId)
          .get()
          .then((doc) => KeMasjidModel.fromSnapshot(doc));
    } on Exception catch (e) {
      keMasjidModel.value = KeMasjidModel();
    }
  }

  _clearControllers() {
    nama.clear();
    alamat.clear();
    photo_url.clear();
  }
}
