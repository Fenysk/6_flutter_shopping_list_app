import 'package:flutter/material.dart';
import 'package:shopping_list_app/widgets/new_grocery_item.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewGroceryItem(),
      ),
    );

    if (newItem == null) return;

    setState(() => _groceryItems.add(newItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _addNewItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _groceryItems.isEmpty
          ? const Center(
              child: Text(
                'No items added yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(_groceryItems[index].name),
                subtitle: Text(_groceryItems[index].category.title),
                leading: Container(
                  color: _groceryItems[index].category.color,
                  width: 30,
                  height: 30,
                ),
                trailing: Text(
                  _groceryItems[index].quantity.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}
