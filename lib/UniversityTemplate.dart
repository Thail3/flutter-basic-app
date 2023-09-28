import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class UniversityTemplate extends StatelessWidget {
  String university;
  String country;
  Color color;
  double size;

  UniversityTemplate(this.university, this.country, this.color, this.size,
      {super.key});

  @override
  Widget build(BuildContext context) {
    // const SizedBox(
    //   height: 8,
    // );
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: color),
      height: size,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // verticalDirection: VerticalDirection.down,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                const Text(
                  "university: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          university,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        )))
              ])),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // verticalDirection: VerticalDirection.up,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                const Text(
                  "Country: ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          country,
                          style: const TextStyle(color: Colors.white),
                        )))
              ]))
        ],
      ),
    );
  }
}
