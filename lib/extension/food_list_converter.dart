import 'package:drift/drift.dart';
import 'dart:convert';

// Create a converter to handle List<String> conversion to/from JSON
class ListConverter extends TypeConverter<List<String>, String> {
  const ListConverter();

  @override
  List<String> fromSql(String fromDb) {
    // Convert the JSON string back to a List<String>
    final list = json.decode(fromDb) as List;
    return list.map((e) => e as String).toList();
  }

  @override
  String toSql(List<String> value) {
    // Convert the List<String> to a JSON string for storage
    return json.encode(value);
  }
}
