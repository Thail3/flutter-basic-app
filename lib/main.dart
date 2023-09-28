import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/universities.dart';

import 'component/UniversityTemplate.dart';
import 'UniversityListHome.dart';
import 'package:flutter_app/script/University.dart';

void main() {
  runApp(const MyApp());
}

// create stateLess widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MYAPP',
      home: MyHomepage(),
      theme: ThemeData(primarySwatch: Colors.blueGrey),
    );
  }
}
