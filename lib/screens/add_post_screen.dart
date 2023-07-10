import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post to'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/naxir.jpg',
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.45,
                child: const TextField(
                  decoration: InputDecoration(
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/imran.jpg',
                        ),
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