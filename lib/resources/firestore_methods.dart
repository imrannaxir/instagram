import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Post

  Future<String> uploadPost(
    String uid,
    String name,
    String description,
    Uint8List file,
    String profImage,
  ) async {
    String result = 'Some Error Occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        name: name,
        description: description,
        datePublished: DateTime.now(),
        postId: postId,
        uid: uid,
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      result = 'success';
    } catch (error) {
      error.toString();
    }
    return result;
  }

  // Like Post

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  // Post Comment

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc()
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is Empty');
      }
    } catch (error) {
      error.toString();
    }
  }

  // Deleting Post

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('user').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
