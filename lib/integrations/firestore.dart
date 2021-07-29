import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

final Future<FirebaseApp> initialization = Firebase.initializeApp();
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
// final FirebaseStorage feedStorage = FirebaseStorage.instanceFor();
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

FirebaseAuth auth = FirebaseAuth.instance;
// FirebaseMessaging fcm = FirebaseMessaging.instance;
const usersCollection = "users";
const masjidCollection = "masjid";
