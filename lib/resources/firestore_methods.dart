import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

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
      _firebase.collection('posts').doc(postId).set(
            post.toJson(),
          );
      result = 'success';
    } catch (error) {
      error.toString();
    }
    return result;
  }
}
