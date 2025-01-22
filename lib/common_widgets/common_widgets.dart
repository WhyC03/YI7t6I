import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green.shade200,
      content: Text(
        content,
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green.shade300,
              border: Border.all(),
              borderRadius: BorderRadius.circular(50)),
          height: 50,
          width: 200,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
