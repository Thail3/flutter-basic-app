import '../University.dart';
import 'package:http/http.dart' as http;

class UniversityService {
  // fetch data from API
  Future<List<University>> fetchUniversities() async {
    try {
      var url = Uri.parse(
          'http://universities.hipolabs.com/search?country=United+States');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return universityFromJson(response.body);
      }
      throw Exception('Failed to fetch data');
    } catch (e) {
      rethrow; // Rethrow the error to handle it in the FutureBuilder.
    }
  }
}
