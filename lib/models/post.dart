import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String name;
  final String description;
  final String postId;
  final String uid;
  final datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  Post({
    required this.name,
    required this.description,
    required this.datePublished,
    required this.postId,
    required this.uid,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'datePublished': datePublished,
        'postId': postId,
        'uid': uid,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      name: snapshot['name'],
      description: snapshot['description'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
