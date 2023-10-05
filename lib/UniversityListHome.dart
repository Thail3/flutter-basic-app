// create stateFull widget คือ widget ที่สามารถเปลี่ยนแปรงค่าได้หรือทำงานได้หลาย state โดย state คือตัวแปรควบคุมการทำงานของแอพให้โต้ตอบกับผู้ใช้ได้
import 'package:flutter/material.dart';
import 'package:flutter_app/component/UniversityTemplate.dart';
import 'package:flutter_app/script/University.dart';
import 'package:flutter_app/services/universities.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'component/UniversityDetails.dart';
import 'package:flutter_app/component/UniversityNavSearch.dart' as MyAppSearch;

class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  List<University> universities = [];
  List<University> filteredUniversities = [];

  bool isLoadingFirstTime = true;

  UniversityService universityService = UniversityService();

  PagingController<int, University> pagingController =
      PagingController(firstPageKey: 0);

  // // query university list by name
  // List<University> filterUniversities(String query) {
  //   return universities.where((university) {
  //     final name = university.name?.toLowerCase() ?? '';
  //     // return name.contains(query.toLowerCase());
  //     return name.startsWith(query.toLowerCase());
  //   }).toList();
  // }

  // // สร้าง function
  // void _handleSearch(String query) {
  //   setState(() {
  //     filteredUniversities = filterUniversities(query);
  //   });
  //   pagingController.refresh();
  // }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await universityService.fetchUniversities(pageKey);

      newItems.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));

      if (newItems.isEmpty) {
        // If there are no more items, consider it as the last page
        pagingController.appendLastPage([]);
        return;
      }

      // Append the new items to the existing list
      setState(() {
        universities.addAll(newItems);
        isLoadingFirstTime = false;
      });

      // Append the page data to the controller
      final nextPageKey = pageKey + 1;
      pagingController.appendPage(newItems, nextPageKey);
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  // จะถูกเรียกใช้งานก่อนที่จะเริ่มทํางาน
  void initState() {
    super.initState();

    fetchPage(pagingController.firstPageKey);
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("call build");

    return Scaffold(
      // appBar: AppBar(
      //     title: MyAppSearch.SearchBar(
      //   onSearch: _handleSearch,

      //   // handle function onClear เมื่อเคลียให้ทำการดึงข้อมูลมาใหม่
      //   onClear: () {
      //     setState(() {
      //       universities = [];
      //       filteredUniversities = [];
      //     });
      //     pagingController.refresh();
      //   },
      // )),
      body: Center(
        child: isLoadingFirstTime
            ? const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                strokeWidth: 5,
              )
            : PagedListView<int, University>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<University>(
                  itemBuilder: (context, university, index) {
                    final item = pagingController.itemList?[index];

                    if (item != null) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UniversityDetailsPage(
                                      university: item,
                                    ),
                                  ),
                                );
                              },
                              child: UniversityTemplate(
                                item.name.toString(),
                                item.country.toString(),
                                Colors.teal,
                                80,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Handle the case where 'item' is null, e.g., display a loading indicator or an error message.
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepOrangeAccent),
                        strokeWidth: 5,
                      );
                    }
                  },
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
