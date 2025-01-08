// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:assignment_flutter/add_widgets_screen.dart';
import 'package:assignment_flutter/common_widgets/common_widgets.dart';
import 'package:assignment_flutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DataModel {
  final String id;
  final String text;
  final String imageUrl;

  DataModel(this.imageUrl, {required this.id, required this.text});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
    };
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();
  final String id = "";
  File? _selectedImage;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveDatatoToFirebase() async {
    log("Saving Data");
    String text = textController.text;

    if (text.isNotEmpty || _selectedImage != null) {
      try {
        String imageUrl = _selectedImage.toString();
        String id = db.collection('textEntries').doc().id;
        DataModel data = DataModel(imageUrl, id: id, text: text);
        await db.collection('textEntries').doc(id).set(data.toJson());
        showSnackBar(context: context, content: "Data saved successfully!");
        textController.clear();
        setState(() {
          _selectedImage = null;
        });
      } catch (e) {
        showSnackBar(context: context, content: 'Failed to save data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Assignment App",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.shade100,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: MyApp.isButtonSelected,
                            builder: (context, isButtonSelected, child) {
                              return ValueListenableBuilder(
                                  valueListenable: MyApp.isTextSelected,
                                  builder: (context, isTextSelected, child) {
                                    return ValueListenableBuilder(
                                        valueListenable: MyApp.isImageSelected,
                                        builder:
                                            (context, isImageSelected, child) {
                                          if (!isTextSelected &&
                                              !isImageSelected &&
                                              !isButtonSelected) {
                                            return SizedBox(
                                              height: 500,
                                              child: Center(
                                                child: Text(
                                                  "No widget is selected",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          }

                                          return Column(
                                            children: [
                                              isTextSelected
                                                  ? TextFormField(
                                                      controller:
                                                          textController,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        hintText: "Enter Text",
                                                        fillColor: Colors
                                                            .grey.shade300,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(height: 50),
                                              SizedBox(height: 20),
                                              isImageSelected
                                                  ? InkWell(
                                                      onTap: _pickImage,
                                                      child: SizedBox(
                                                        child: Container(
                                                          color: Colors
                                                              .grey.shade300,
                                                          height: 200,
                                                          child: Center(
                                                            child: Text(
                                                              "Upload Image",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(height: 200),
                                              SizedBox(height: 80),
                                              isButtonSelected
                                                  ? CustomButton(
                                                      text: "Save",
                                                      onTap: () {
                                                        if (!isImageSelected &&
                                                            !isTextSelected) {
                                                          showSnackBar(
                                                              context: context,
                                                              content:
                                                                  "Please Select Any of the fields");
                                                        }

                                                        if (textController.text.isEmpty) {
                                                          showSnackBar(context: context, content: "Enter Something");
                                                        }

                                                        if (textController
                                                            .text.isNotEmpty) {
                                                          _saveDatatoToFirebase();
                                                        }
                                                      },
                                                    )
                                                  : SizedBox(height: 50),
                                              SizedBox(height: 100),
                                            ],
                                          );
                                        });
                                  });
                            })
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Add Widgets",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddWidgetsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
