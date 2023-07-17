import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  //
  //
  //
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();

  bool loading = false;

  void postImage(
    String uid,
    String name,
    String profImage,
  ) async {
    setState(() {
      loading = true;
    });
    try {
      String result = await FirestoreMethods().uploadPost(
        uid,
        name,
        _descriptionController.text,
        _file!,
        profImage,
      );
      if (result == 'success') {
        showSnackBar('Posted', context);
        clearImage();
        setState(() {
          loading = false;
        });
      } else {
        showSnackBar(result, context);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Create a Post',
          ),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Take a Photo',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Choose From Gallery',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectImage(context);
              },
              icon: const Icon(
                Icons.image,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Post to'),
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    postImage(
                      user.uid,
                      user.name,
                      user.photoUrl,
                    );
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                loading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // backgroundImage: AssetImage(
                      //   'assets/images/naxir.jpg',
                      // ),
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
