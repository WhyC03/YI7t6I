import 'package:assignment_flutter/firebase_options.dart';
import 'package:assignment_flutter/home_screen.dart';
import 'package:assignment_flutter/home_screen_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  assert(() {
    debugDisablePointerBindingAssertions();
    return true;
  }());
  runApp(const MyApp());
}

void debugDisablePointerBindingAssertions() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ValueNotifier<bool> isImageSelected = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isTextSelected = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isButtonSelected =
      ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          primarySwatch: Colors.blue),
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return HomeScreenWeb();
          } else {
            return HomeScreen();
          }
        },
      ),
    );
  }
}
