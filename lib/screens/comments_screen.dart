import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              return CommentCard(
                snap: (snapshot.data! as dynamic).docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kTextTabBarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  // 'https://images.unsplash.com/photo-1689235966281-1831404bd11c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=500&q=60',
                  user.photoUrl,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.name}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.name,
                    user.photoUrl,
                  );
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram/models/user.dart';
// import 'package:instagram/providers/user_provider.dart';
// import 'package:instagram/resources/firestore_methods.dart';
// import 'package:instagram/utils/colors.dart';
// import 'package:instagram/utils/utils.dart';
// import 'package:instagram/widgets/comment_card.dart';
// import 'package:provider/provider.dart';

// class CommentsScreen extends StatefulWidget {
//   final postId;
//   const CommentsScreen({Key? key, required this.postId}) : super(key: key);

//   @override
//   _CommentsScreenState createState() => _CommentsScreenState();
// }

// class _CommentsScreenState extends State<CommentsScreen> {
//   final TextEditingController commentEditingController =
//       TextEditingController();

  // void postComment(String uid, String name, String profilePic) async {
  //   try {
  //     String res = await FirestoreMethods().postComment(
  //       widget.postId,
  //       commentEditingController.text,
  //       uid,
  //       name,
  //       profilePic,
  //     );

  //     if (res != 'success') {
  //       if (context.mounted) showSnackBar(res, context);
  //     }
  //     setState(() {
  //       commentEditingController.text = "";
  //     });
  //   } catch (err) {
  //     showSnackBar(
  //       err.toString(),
  //       context,
  //     );
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: const Text(
//           'Comments',
//         ),
//         centerTitle: false,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.postId)
//             .collection('comments')
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (ctx, index) => CommentCard(
//               snap: snapshot.data!.docs[index],
//             ),
//           );
//         },
//       ),
//       // text input
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           height: kToolbarHeight,
//           margin:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           padding: const EdgeInsets.only(left: 16, right: 8),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(user.photoUrl),
//                 radius: 18,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16, right: 8),
//                   child: TextField(
//                     controller: commentEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Comment as ${user.name}',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () => postComment(
//                   user.uid,
//                   user.name,
//                   user.photoUrl,
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8,
//                     horizontal: 8,
//                   ),
//                   child: const Text(
//                     'Post',
//                     style: TextStyle(
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
