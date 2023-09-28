// create stateFull widget คือ widget ที่สามารถเปลี่ยนแปรงค่าได้หรือทำงานได้หลาย state โดย state คือตัวแปรควบคุมการทำงานของแอพให้โต้ตอบกับผู้ใช้ได้
import 'package:flutter/material.dart';
import 'package:flutter_app/component/UniversityTemplate.dart';
import 'package:flutter_app/script/University.dart';
import 'package:flutter_app/services/universities.dart';
import 'component/UniversityDetails.dart';

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

  @override
  Widget build(BuildContext context) {
    print("call build");

    return Scaffold(
        appBar: AppBar(
            title: SearchBar(
          onSearch: _handleSearch,

          // handle function onClear เมื่อเคลียให้ทำการดึงข้อมูลมาใหม่
          onClear: () {
            setState(() {
              universities = [];
              filteredUniversities = [];
            });
            UniversityService().fetchUniversities().then((unis) {
              setState(() {
                universities = unis;
                filteredUniversities = universities;
              });
            });
          },
        )),
        body: Center(
          child: FutureBuilder(
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
                          GestureDetector(
                            onTap: () {
                              // Navigate to the details page and pass the selected university
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UniversityDetailsPage(
                                      university: filteredUniversities[index]),
                                ),
                              );
                            },
                            child: UniversityTemplate(
                                filteredUniversities[index].name.toString(),
                                filteredUniversities[index].country.toString(),
                                Colors.teal,
                                80),
                          ),
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
        ));
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String query) onSearch;
  final void Function() onClear;

  const SearchBar({Key? key, required this.onSearch, required this.onClear})
      : super(key: key);

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
                                  widget.onClear();
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
