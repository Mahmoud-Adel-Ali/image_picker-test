// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'package:img_packer/snackBar.dart';
import 'package:path/path.dart' show basename;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? imgPath;
  late String imgName;

  uploadImage(ImageSource imageSource) async {
    final pickedImg = await ImagePicker().pickImage(source: imageSource);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      showSnackBar(context, "Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "photo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await uploadImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.camera_alt)),
                          // ignore: prefer_const_constructors
                          Text("Camera",style: TextStyle(fontSize: 20),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                await uploadImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.file_open)),
                          const Text("Files"),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: (imgPath == null)
                ? const Text("No img selected")
                : Column(
                    children: [
                      Image.file(imgPath!),
                      const SizedBox(height: 20),
                      Text(imgName),
                    ],
                  )),
      ),
    );
  }
}
