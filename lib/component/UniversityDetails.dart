import 'package:flutter/material.dart';
import 'package:flutter_app/script/University.dart';
import 'package:flutter_app/services/universities.dart';

class UniversityDetailsPage extends StatelessWidget {
  final University university;

  const UniversityDetailsPage({required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'University Name: ${university.name}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Country: ${university.country}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
