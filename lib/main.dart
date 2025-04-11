import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_storage_solutions/home/home_screen.dart';
import 'package:local_storage_solutions/home/route_manager.dart';
import 'package:local_storage_solutions/home/sqflite/sqflite_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.5)),
          isCollapsed: true,
          prefixIconColor: Colors.blue,
          labelStyle: GoogleFonts.outfit(
              fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
          suffixIconColor: Colors.blue,
          contentPadding: EdgeInsets.fromLTRB(18, 15, 18, 15),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.grey)),
        ),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white, size: 20),
            titleTextStyle:
                GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
            backgroundColor: Colors.blue),
        textTheme: GoogleFonts.outfitTextTheme(TextTheme()).apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        Routes.sqfLite: (_) => SqfliteScreen(),
      },
    );
  }
}
