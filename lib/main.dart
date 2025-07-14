import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, String>> _items = [];

  void _addItem() {
    final item = _itemController.text.trim();
    final quantity = _quantityController.text.trim();

    // if its not empty add it to the _items list, and clear the textfield.
    if (item.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        _items.add({'item': item, 'quantity': quantity});
      });
      _itemController.clear();
      _quantityController.clear();
    }
  }

  //Prompt the alertDialog, if click "yes"  setState to delete, if click "no"
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Delete Item'),
            content: const Text('Do you want to delete this item?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // No
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                  Navigator.of(context).pop(); // Yes
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
    super.dispose(); // free the memory of what was typed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child:
                  TextField(controller: _itemController, // item textfield
                    decoration: const InputDecoration(
                      hintText: "Type the item here",
                      border: OutlineInputBorder(),
                    ),),),
                const SizedBox(width: 2),
                Expanded(
                  child:
                  TextField(controller: _quantityController, // quantityfield
                    decoration: const InputDecoration(
                      hintText: "Type the quantity here",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),),
                const SizedBox(width: 10),

                //Add item when click " Click here"
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("Click here"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _items.isEmpty //Display messages when its empty in the list
                  ? const Center(child: Text("There are no items in the list"))
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return GestureDetector( // for the onlongpress
                    onLongPress: () => _confirmDelete(index),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text("${index + 1}. "), // index +1 ,number start from 1
                        Text(item['item']!), // item name
                        Text("   Qty: ${item['quantity']}"),

                  ]
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

