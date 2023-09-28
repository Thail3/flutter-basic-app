// To parse this JSON data, do
//
//     final university = universityFromJson(jsonString);

import 'dart:convert';

List<University> universityFromJson(String str) =>
    List<University>.from(json.decode(str).map((x) => University.fromJson(x)));

String universityToJson(List<University> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class University {
  String? stateProvince;
  String? name;
  List<String>? domains;
  List<String>? webPages;
  Country? country;
  AlphaTwoCode? alphaTwoCode;

  University({
    this.stateProvince,
    this.name,
    this.domains,
    this.webPages,
    this.country,
    this.alphaTwoCode,
  });

  factory University.fromJson(Map<String, dynamic> json) => University(
        stateProvince: json["state-province"],
        name: json["name"],
        domains: json["domains"] == null
            ? []
            : List<String>.from(json["domains"]!.map((x) => x)),
        webPages: json["web_pages"] == null
            ? []
            : List<String>.from(json["web_pages"]!.map((x) => x)),
        country: countryValues.map[json["country"]]!,
        alphaTwoCode: alphaTwoCodeValues.map[json["alpha_two_code"]]!,
      );

  Map<String, dynamic> toJson() => {
        "state-province": stateProvince,
        "name": name,
        "domains":
            domains == null ? [] : List<dynamic>.from(domains!.map((x) => x)),
        "web_pages":
            webPages == null ? [] : List<dynamic>.from(webPages!.map((x) => x)),
        "country": countryValues.reverse[country],
        "alpha_two_code": alphaTwoCodeValues.reverse[alphaTwoCode],
      };
}

enum AlphaTwoCode { US }

final alphaTwoCodeValues = EnumValues({"US": AlphaTwoCode.US});

enum Country { UNITED_STATES }

final countryValues = EnumValues({"United States": Country.UNITED_STATES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
