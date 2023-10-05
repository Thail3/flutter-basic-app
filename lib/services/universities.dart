import '../script/University.dart';
import 'package:http/http.dart' as http;

class UniversityService {
  final int _pageSize = 10;
  bool _isLoading = false;
  int get pageSize => _pageSize;

  Future<List<University>> fetchUniversities(int currentPage) async {
    if (_isLoading) {
      return [];
    }

    _isLoading = true;

    try {
      var url = Uri.parse(
          'http://universities.hipolabs.com/search?country=United+States&page=$currentPage&limit=$_pageSize');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final universities = universityFromJson(response.body);
        _isLoading = false;
        return universities;
      }
      throw Exception('Failed to fetch data');
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }
}
