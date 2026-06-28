import 'dart:io';

import 'package:flutter/material.dart';

class PhotoPreviewScreen extends StatefulWidget {
  final String imagePath;

  const PhotoPreviewScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<PhotoPreviewScreen> createState() =>
      _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState
    extends State<PhotoPreviewScreen> {
  final TextEditingController captionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.contain,
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 25,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: captionController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Add a caption...",
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 28,
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        {
                          'type': 'image',
                          'path': widget.imagePath,
                          'caption':
                              captionController.text,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}