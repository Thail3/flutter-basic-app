import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/services/universities.dart';

// import 'FoodMenu.dart';
import 'UniversityTemplate.dart';
import 'package:flutter_app/University.dart';

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

// create stateFull widget คือ widget ที่สามารถเปลี่ยนแปรงค่าได้หรือทำงานได้หลาย state โดย state คือตัวแปรควบคุมการทำงานของแอพให้โต้ตอบกับผู้ใช้ได้
class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  // int number = 0;
  get university => null;
  List<University> universities = [];
  List<University> filteredUniversities = [];

  // query university list by name
  List<University> filterUniversities(String query) {
    return universities.where((university) {
      final name = university.name?.toLowerCase() ?? '';
      // return name.contains(query.toLowerCase());
      return name.startsWith(query.toLowerCase());
    }).toList();
  }

  // สร้าง function
  void _handleSearch(String query) {
    setState(() {
      filteredUniversities = filterUniversities(query);
    });
  }

  @override
  // จะถูกเรียกใช้งานก่อนที่จะเริ่มทํางาน
  void initState() {
    super.initState();
    print("call initState");
    UniversityService().fetchUniversities().then((unis) {
      setState(() {
        universities = unis;
        filteredUniversities = universities;
      });
    });
  }

  // // fetch data from API
  // Future<List<University>> getCurrentUniversity() async {
  //   try {
  //     var url = Uri.parse(
  //         'http://universities.hipolabs.com/search?country=United+States');
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       universities = universityFromJson(response.body);
  //       filteredUniversities = List.from(universities);
  //       print(
  //           "filteredUniversities:  ${filteredUniversities.map((u) => u.name)}");
  //       return universities;
  //     } else {
  //       throw Exception('Failed to fetch data');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     rethrow; // Rethrow the error to handle it in the FutureBuilder.
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("call build");

    return Scaffold(
      appBar: AppBar(title: SearchBar(onSearch: _handleSearch)),
      body: FutureBuilder(
          future: UniversityService().fetchUniversities(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.done) {
              // sort university by name a to z
              filteredUniversities
                  .sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));

              return ListView.builder(
                itemCount: filteredUniversities.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(children: [
                      UniversityTemplate(
                          filteredUniversities[index].name.toString(),
                          filteredUniversities[index].country.toString(),
                          Colors.teal,
                          80)
                    ]),
                  );
                },
              );
            }

            return const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
              strokeWidth: 5,
            );
          }),
    );

    // Padding(
    //   padding: const EdgeInsets.all(4.0),
    //   child: Column(
    //     children: [
    //       MoneyBox("ยอดคงเหลือ", 10000, Colors.lightBlue, 120),
    //       const SizedBox(
    //         height: 8,
    //       ),
    //       MoneyBox("รายรับ", 10000, Colors.green, 120)
    //     ],
    //   ),
    // ),
    // ListView.builder(
    //     itemCount: menu.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       FoodMenu food = menu[index];
    //       return ListTile(
    //         leading: Image.asset(food.img),
    //         title: Text(
    //           'เมนูที่ ${index + 1} ${food.name}',
    //           style: TextStyle(fontSize: 35, color: Colors.orange),
    //         ),
    //         subtitle: Text('ราคา ${food.price} บาท',
    //             style: TextStyle(fontSize: 25, color: Colors.lightGreen)),
    //         onTap: () {
    //           print('คุณเลือกเมนูอาหารชื่อว่า' + food.name);
    //         },
    //       );
    //     }),
    // body: Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: data,
    //   ),
    // ),
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () => addNumber(),
    //   child: Icon(Icons.add),
    // ),
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String query) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isActive)
          Text("Universities of United States",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: _isActive
                  ? Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextField(
                        onSubmitted: (query) {
                          widget.onSearch(query);
                        },
                        decoration: InputDecoration(
                            hintText: 'Search for something',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isActive = false;
                                  });
                                },
                                icon: const Icon(Icons.close))),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _isActive = true;
                        });
                      },
                      icon: const Icon(Icons.search)),
            ),
          ),
        ),
      ],
    );
  }
}
