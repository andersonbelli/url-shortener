import 'package:flutter/material.dart';
import 'package:teststudy/di/core.di.dart';
import 'package:teststudy/di/di.dart';
import 'package:teststudy/presenter/home/home.bloc.dart';
import 'package:teststudy/presenter/home/home.page.dart';

void main() {
  CoreDI().registerAll();
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HomeBloc bloc = Injector().di.get<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purple Shortener',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: InheritedDataProvider(
        bloc,
        const HomePage(),
      ),
    );
  }
}
