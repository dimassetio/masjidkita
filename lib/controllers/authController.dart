// @dart=2.9
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mosq/helpers/showLoading.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/models/user.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mosq/screens/utils/MKImages.dart';
import 'package:mosq/screens/widgets/CustomAlert.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:mosq/screens/inventaris/inventaris_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  Rx<User> firebaseUser;
  Rx<UserModel> userModel = UserModel().obs;

  UserModel get user => userModel.value;
  set user(UserModel value) => this.userModel.value = value;
  RxBool isLoggedIn = false.obs;

  // final googleSignIn = GoogleSignIn();

  var _lastVerif = 0.obs;
  int get lastVerif => _lastVerif.value;
  set lastVerif(int value) => this._lastVerif.value = value;
  Timer timer;

  setTimer() {
    lastVerif = 30;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (lastVerif == 0) {
          timer.cancel();
        } else {
          lastVerif = lastVerif - 1;
        }
      },
    );
  }

  sendVerif(User user) async {
    if (lastVerif == 0) {
      try {
        await user.sendEmailVerification();
        Get.snackbar('Verifikasi telah dikirimkan', 'Silahkan cek Email anda');
        setTimer();
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar("Verifikasi Gagal",
          "Tunggu selama $lastVerif detik untuk mengirim ulang verifikasi");
    }
  }

  final box = GetStorage();
  var isFirstLaunch = false.obs;

  @override
  void onReady() async {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _setLogStatus);
    ever(firebaseUser, _setUserModel);

    // isFirstLaunch.value = box.read('first_launch');
    box.listenKey('first_launch', (value) {
      isFirstLaunch.value = value;
      print("p $value");
    });
    if (box.read('first_launch') == null) {
      await box.write('first_launch', true);
    } else {
      await box.write('first_launch', false);
    }
    print("${box.read('first_launch')} fl box");
  }

  _setLogStatus(User user) {
    if (user == null) {
      isLoggedIn.value = false;
    } else {
      isLoggedIn.value = true;
    }
  }

  _setUserModel(User user) {
    try {
      _initializeUserModel(firebaseUser.value.uid);
    } catch (e) {
      userModel.value = UserModel();
      // print(e);
    }
  }

  signIn(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        if (result.user.emailVerified == true) {
          String _userId = result.user.uid;
          _initializeUserModel(_userId);

          print(firebaseUser);
          Get.offAllNamed(RouteName.home);
          toast("Sign In Success");
        } else {
          await Get.defaultDialog(
              barrierDismissible: false,
              textCancel: 'Tutup',
              textConfirm: 'OK',
              title: "Email Belum Terverifikasi",
              middleText:
                  "Untuk melanjutkan login, email anda harus diverifikasi terlebih dahulu. silahkan klik 'OK' untuk mendapatkan email verifikasi",
              onConfirm: () async {
                try {
                  // await result.user.sendEmailVerification();
                  Get.back();
                  await sendVerif(result.user);
                  Get.toNamed(
                    RouteName.verification,
                    arguments: [email, password],
                  );
                } catch (e) {
                  Get.back();
                  Get.snackbar('Error Sending Verification', e.toString());
                }
              });

          // await result.user.sendEmailVerification();
          // Get.toNamed(RouteName.verification, arguments: [email, password]);
        }
      });
    } on FirebaseAuthException catch (e) {
      String error;
      switch (e.code) {
        case 'wrong-password':
          error = 'Wrong password.';
          break;
        case 'user-not-found':
          error = 'Wrong username or password,';
          break;
        case 'user-disabled':
          error = 'User is disabled, please contact administrator.';
          break;
        case 'invalid-email':
          error = 'Invalid email';
          break;
        case 'network-request-failed':
          error = 'Connection error';
          break;

        default:
          error = e.message;
      }
      return Get.snackbar('Sign In Failed', error);
    } catch (e) {
      return Get.snackbar("Sign In Failed", e.toString());
    }
  }

  signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        await sendVerif(result.user);
        // await result.user.sendEmailVerification();
        // Get.dialog(Container());
        Get.toNamed(RouteName.verification, arguments: [email, password]);

        // auth.signOut();

        String _userId = result.user.email;

        // result.user.

        _addUserToFirestore(name: name, user: result.user);
        _initializeUserModel(_userId);
        // Get.offAllNamed(RouteName.home);
        // toast("Sign Up Success");
      } else {
        Get.snackbar('Sign Up Failed', 'Unknown Error');
      }
    } on FirebaseAuthException catch (e) {
      String error = "";
      switch (e.code) {
        case 'weak-password':
          error = 'Please use stronger password';
          break;
        case 'email-already-in-use':
          error = 'Email already in use';
          break;
        case 'invalid-email':
          error = 'Invalid email';
          break;
        case 'operation-not-allowed':
          error = 'Operation not allowed';
          break;
        case 'network-request-failed':
          error = 'Connection error';
          break;
        default:
          error = 'Try Again';
          print(e.code);
      }
      Get.snackbar('Sign Up Failed', error);
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign Up Failed", "Try again");
    }
  }

  void signInGoogle() async {
    showLoading();

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    User user;

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        // _addUserGoogleToFirestore(user.uid);
        _initializeUserModel(user.uid);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content:
          //         'The account already exists with a different credential.',
          //   ),
          // );
          debugPrint(e.toString());
          Get.snackbar("Login failed",
              "The account already exists with a different credential");
        } else if (e.code == 'invalid-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Get.snackbar("Error occurred while accessing credentials", "Try again");
          // );
          debugPrint(e.toString());
          Get.snackbar(
              "Error occurred while accessing credentials", "Try again");
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   Authentication.customSnackBar(
        //     content: 'Error occurred using Google Sign-In. Try again.',
        //   ),
        // );
        debugPrint(e.toString());
        Get.snackbar("Error occurred using Google Sign-In", "Try again");
      }
    }
  }

  void signOut() async {
    userModel.value = UserModel();
    await auth.signOut();
    toast("Sign Out Success");
  }

  _addUserToFirestore({String name, User user}) {
    firebaseFirestore.collection(usersCollection).doc(user.email).set({
      "name": name ?? user.displayName,
      "id": user.uid,
      "email": user.email,
      "email_verified": user.emailVerified,
      'created_at': DateTime.now(),
      "role": "user",
      "masjid": ""
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

  _initializeUserModel(String userId) async {
    userModel.bindStream(firebaseFirestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromSnapshot(event)));

    // .get()
    // .then((doc) => UserModel.fromSnapshot(doc));
  }

  // _clearControllers() {
  //   name.clear();
  //   email.clear();
  //   password.clear();
  //   confirmPassword.clear();
  // }
}
