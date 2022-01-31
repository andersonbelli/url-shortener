import 'package:flutter/material.dart';
import 'package:nubanktest/di/core.di.dart';
import 'package:nubanktest/presenter/home/home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purple Shortener',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }

  @override
  void initState() {
    super.initState();
    CoreDI().registerAll();
  }
}
