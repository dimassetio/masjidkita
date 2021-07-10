// @dart=2.9
import 'package:masjidkita/helpers/showLoading.dart';
import 'package:masjidkita/models/user.dart';
import 'package:masjidkita/routes/route_name.dart';
import 'package:masjidkita/screens/MKDashboard.dart';
import 'package:masjidkita/screens/MKSignIn.dart';
import 'package:masjidkita/screens/authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjidkita/integrations/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:masjidkita/screens/inventaris/inventaris_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Rx<User> firebaseUser;
  RxBool isLoggedIn = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String usersCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;

  UserModel get user => userModel.value;
  set user(UserModel value) => this.userModel.value = value;

  final googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User user) {
    if (user == null) {
      Get.offAll(() => T5SignIn());
    } else {
      Get.offAll(() => MKDashboard());
    }
  }

  void signIn() async {
    // final userRef = firebaseFirestore.collection(usersCollection).doc(userId);
    // final userRef = _db.collection("users").doc(user.uid);
    // if ((await userRef.get()).exists) {
    //   await userRef.update({
    //     "last_login":
    //         auth.currentUser.metadata.lastSignInTime.millisecondsSinceEpoch,
    //   });
    // }
    try {
      // showLoading();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user.uid;
        _initializeUserModel(_userId);
        // userRef.set({
        //   "last_login": auth.currentUser.metadata.lastSignInTime,
        // });
        _clearControllers();
        print(userModel.value.name);
        Get.snackbar("Sign Success", "");
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  void signUp() async {
    showLoading();
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user.uid;
        _addUserToFirestore(_userId);
        _initializeUserModel(_userId);
        _clearControllers();
      });
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

  // Future googleLogin() async {
  //   final googleUser = await googleSignIn.signIn();
  //   if (googleUser == null) return;
  //   _user = googleUser;

  //   final googleAuth = await googleUser.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   await FirebaseAuth.instance.signInWithCredential(credential);

  //   notifyListeners();
  // }

  // static Future<User> signInWithGoogle({BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User user;

  //   final GoogleSignIn googleSignIn = GoogleSignIn();

  //   final GoogleSignInAccount googleSignInAccount =
  //       await googleSignIn.signIn(); //////////////////////////////////////////

  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithCredential(credential);

  //       user = userCredential.user;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   Authentication.customSnackBar(
  //         //     content:
  //         //         'The account already exists with a different credential.',
  //         //   ),
  //         // );
  //         debugPrint(e.toString());
  //         Get.snackbar("Login failed",
  //             "The account already exists with a different credential");
  //       } else if (e.code == 'invalid-credential') {
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   Get.snackbar("Error occurred while accessing credentials", "Try again");
  //         // );
  //         debugPrint(e.toString());
  //         Get.snackbar(
  //             "Error occurred while accessing credentials", "Try again");
  //       }
  //     } catch (e) {
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   Authentication.customSnackBar(
  //       //     content: 'Error occurred using Google Sign-In. Try again.',
  //       //   ),
  //       // );
  //       debugPrint(e.toString());
  //       Get.snackbar("Error occurred using Google Sign-In", "Try again");
  //     }
  //   }

  //   return user;
  // }

  void signOut() async {
    auth.signOut();
  }

  _addUserToFirestore(String userId) {
    firebaseFirestore.collection(usersCollection).doc(userId).set({
      "name": name.text.trim(),
      "id": userId,
      "email": email.text.trim(),
      "role": "user"
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
    userModel.value = await firebaseFirestore
        .collection(usersCollection)
        .doc(userId)
        .get()
        .then((doc) => UserModel.fromSnapshot(doc));
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }
}
