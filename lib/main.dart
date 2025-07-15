import 'package:flutter/material.dart';
import 'package:week6/database/app_db.dart';
import 'package:week6/database/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp(this.database, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List with Database',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor:Colors.deepPurple),),
      home: ShoppingListPage(database: database),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  final AppDatabase database;

  const ShoppingListPage({Key? key, required this.database}) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItemsFromDb();
  }

  Future<void> _loadItemsFromDb() async {
    final items = await widget.database.itemDao.findAllItems();
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem() async {
    final name = _itemController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    // if its not empty add it to the _items list, and clear the textfield.
    if (name.isNotEmpty && quantity > 0) {
      final newItem = Item(name: name, quantity: quantity);
      await widget.database.itemDao.insertItem(newItem);
      _itemController.clear();
      _quantityController.clear();
      await _loadItemsFromDb();
    }
  }

  Future<void> _deleteItem(Item item) async {
    await widget.database.itemDao.deleteItem(item);
    await _loadItemsFromDb();
  }

//Prompt the alertDialog, if click "yes"  setState to delete, if click "no"
  void _confirmDelete(Item item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () async {
              await _deleteItem(item);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Shopping List with DB')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                        hintText: 'Type the item here', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                        hintText: 'Type the quantity here',border:OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Click here')),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('There are no items in the list'))
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return GestureDetector(
                    onLongPress: () => _confirmDelete(item),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text("${index + 1}. "),
                        Text(item.name),
                        Text(" Qty: ${item.quantity}"),
                      ]
                    )
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
