// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:assignment_flutter/add_widgets_screen.dart';
import 'package:assignment_flutter/common_widgets/common_widgets.dart';
import 'package:assignment_flutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  final TextEditingController textController = TextEditingController();
  String base64String = '';
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool tapped = false;

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        // Check if the app is running on web
        if (result.files.single.bytes != null) {
          Uint8List fileBytes = result.files.single.bytes!;
          base64String = base64Encode(fileBytes);
          log('Base64 String: $base64String');
        } else {
          String? filePath = result.files.single.path;
          if (filePath != null) {
            Uint8List fileBytes = await File(filePath).readAsBytes();
            base64String = base64Encode(fileBytes);
            log('Base64 String: $base64String');
          }
        }
      } else {
        log('User canceled the picker');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _saveDatatoToFirebase() async {
    log("Saving Data");
    String text = textController.text;

    if (text.isNotEmpty || base64String != "") {
      try {
        String id = db.collection('textEntries').doc().id;
        DataModel data = DataModel(base64String, id: id, text: text);
        await db.collection('textEntries').doc(id).set(data.toJson());
        showSnackBar(context: context, content: "Data saved successfully!");
        textController.clear();
        setState(() {
          base64String = "";
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
                                                      onTap: pickImage,
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

                                                        if (textController
                                                            .text.isEmpty) {
                                                          showSnackBar(
                                                              context: context,
                                                              content:
                                                                  "Enter Something");
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
                            }),

                        // To test whether the image is being displayed or not
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       tapped = true;
                        //     });
                        //   },
                        //   child: Text('data'),
                        // ),
                        // if (tapped == true)
                        //   Container(
                        //     child: displayImageFromBase64(),
                        //   ),
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayImageFromBase64() {
    Uint8List imageBytes = base64Decode(base64String);
    return Image.memory(imageBytes);
  }
}
