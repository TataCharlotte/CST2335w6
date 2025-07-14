import 'package:floor/floor.dart';
import 'item.dart';

@dao
abstract class ItemDao {
  @Query('SELECT * FROM items')
  Future<List<Item>> findAllItems();

  @insert
  Future<void> insertItem(Item item);

  @delete
  Future<void> deleteItem(Item item);
}