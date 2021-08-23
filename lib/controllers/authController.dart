// @dart=2.9
import 'package:get_storage/get_storage.dart';
import 'package:mosq/helpers/showLoading.dart';
import 'package:mosq/models/user.dart';
import 'package:mosq/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mosq/integrations/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
          .then((result) {
        String _userId = result.user.uid;
        _initializeUserModel(_userId);

        print(firebaseUser);
        Get.offAllNamed(RouteName.home);
        toast("Sign In Success");
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

          print(e.code + 'iki error cok');
          break;
        default:
          error = e.code;
      }
      return Get.snackbar('Sign In Failed', error);
    } catch (e) {
      return Get.snackbar("Sign In Failed", "Try again");
    }
  }

  signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        String _userId = result.user.uid;
        _addUserToFirestore(
          _userId,
          name,
          email,
        );
        _initializeUserModel(_userId);
        Get.offAllNamed(RouteName.home);
        toast("Sign Up Success");
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

  _addUserToFirestore(String userId, String name, String email) {
    firebaseFirestore.collection(usersCollection).doc(userId).set({
      "name": name,
      "id": userId,
      "email": email,
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
