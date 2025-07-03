import 'package:hive/hive.dart';

part 'checklist_model.g.dart';

@HiveType(typeId: 0)
class Checklist extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<ChecklistItem> items;

  Checklist({required this.title, required this.date, required this.items});
}

@HiveType(typeId: 1)
class ChecklistItem {
  @HiveField(0)
  String description;

  @HiveField(1)
  bool isDone;

  ChecklistItem({required this.description, this.isDone = false});
}
