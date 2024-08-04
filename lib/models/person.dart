import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(2)
  final String email;

  Person({
    required this.name,
    required this.email,
  });
}
