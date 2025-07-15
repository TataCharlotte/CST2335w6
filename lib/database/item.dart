import 'package:floor/floor.dart';

@Entity(tableName: 'items')
class Item {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final int quantity;

  Item({this.id, required this.name, required this.quantity});
}