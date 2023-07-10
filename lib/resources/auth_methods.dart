import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // Signup user
  Future<String> signupUser({
    required String name,
    required String mail,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String result = 'success';

    try {
      if (name.isNotEmpty ||
          mail.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // Now we Regisster the User
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: mail,
          password: password,
        );
        print(credential.user!.uid);

        String photoUrl =
            await StorageMethods().uploadImage('profilePics', file, false);

        // Add user to our databse

        model.User users = model.User(
          name: name,
          uid: credential.user!.uid,
          mail: mail,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        await _firestore
            .collection('user')
            .doc(credential.user!.uid)
            .set(users.toJson())
            .then((value) {
          result = 'success';
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        result = 'The Email is badly Formatted';
      } else if (error.code == 'weak-password') {
        result = 'The Password should be at least 6 charcters';
      } else if (error.code == 'email-already-in-use') {
        result = 'The email address is already in use by another account.';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  // Login User

  Future<String> loginUser({
    required String mail,
    required String password,
  }) async {
    String result = 'success';
    try {
      if (mail.isNotEmpty || password.isNotEmpty) {
        await _auth
            .signInWithEmailAndPassword(email: mail, password: password)
            .then((value) {
          result = 'success';
        }).onError((error, stackTrace) {
          result = 'Somethoing went wrong!';
        });
      } else {
        result = 'Please Enter All The Fields';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        result = 'User has not been Registered';
      } else if (error.code == 'invalid-email') {
        result = 'The Email is badly Formatted';
      } else if (error.code == 'email-already-in-use') {
        result = 'The email address is already in use by another account.';
      } else if (error.code == 'wrong-password') {
        result = 'Wrong Password';
      } else if (error.code == 'weak-password') {
        result = 'The Password should be at least 6 charcters';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}