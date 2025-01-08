import 'package:assignment_flutter/common_widgets/common_widgets.dart';
import 'package:assignment_flutter/main.dart';
import 'package:flutter/material.dart';

class AddWidgetsScreen extends StatefulWidget {
  const AddWidgetsScreen({super.key});

  @override
  State<AddWidgetsScreen> createState() => _AddWidgetsScreenState();
}

class _AddWidgetsScreenState extends State<AddWidgetsScreen> {
  bool isimageSelected = false;
  bool istextSelected = false;
  bool isbuttonSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green.shade100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text Widget Selection
              InkWell(
                onTap: () {
                  setState(() {
                    MyApp.isTextSelected.value = !MyApp.isTextSelected.value;
                  });
                },
                child: Container(
                  width: 250,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: MyApp.isTextSelected.value
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Text Widget",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Image Widget Selection
              InkWell(
                onTap: () {
                  setState(() {
                    MyApp.isImageSelected.value = !MyApp.isImageSelected.value;
                  });
                },
                child: Container(
                  width: 250,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: MyApp.isImageSelected.value
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Image Widget",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Button Widget Selection
              InkWell(
                onTap: () {
                  setState(() {
                    MyApp.isButtonSelected.value =
                        !MyApp.isButtonSelected.value;
                  });
                },
                child: Container(
                  width: 250,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: MyApp.isButtonSelected.value
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Button Widget",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              CustomButton(
                text: "Import Widgets",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
