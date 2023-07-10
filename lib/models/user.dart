import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String mail;
  final String photoUrl;
  final String bio;
  final String uid;
  final List followers;
  final List following;

  User({
    required this.name,
    required this.mail,
    required this.photoUrl,
    required this.bio,
    required this.uid,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'mail': mail,
        'photoUrl': photoUrl,
        'bio': bio,
        'uid': uid,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      name: snapshot['name'],
      mail: snapshot['mail'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      uid: snapshot['uid'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}