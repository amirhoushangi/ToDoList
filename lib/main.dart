import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/home/home.dart';
import 'package:flutter_application_1/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: PrimaryVariantcolor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color PrimaryVariantcolor = Color(0xff5c0aff);
const secondryTextColor = Color(0xffafbed0);
const normalpriority = Color(0xfff09819);
const lowpriority = Color(0xff3be1f1);
const highpriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1d2830);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
            headlineSmall:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: TextStyle(color: secondryTextColor),
            border: InputBorder.none,
            iconColor: secondryTextColor),
        colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimaryFixedVariant: PrimaryVariantcolor,
            surface: Color(0xfff3f5f8),
            onSurface: primaryTextColor,
            onPrimary: Colors.white,
            secondary: primaryColor,
            onSecondary: Colors.white),
      ),
      home: HomeScreen(),
    );
  }
}

