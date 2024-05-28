import 'package:flutter/material.dart';
import 'package:shopping_list_app/widgets/new_grocery_item.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final url = Uri.https('flutter-shopping-list-48a40-default-rtdb.europe-west1.firebasedatabase.app', 'shopping-list.json');

    final response = await http.get(url);

    // {"-Nyy8LKyhHkxOz9ryFDO":{"category":"Meat","name":"test","quantity":1},"-Nyy8gI-qpk9IZYZZF3b":{"category":"Carbs","name":"ouais","quantity":3},"-Nyy9J3FRo1pgpXFpu7y":{"category":"Hygiene","name":"troisieme","quantity":3},"-Nyy9NttxguI21RePd0b":{"category":"Hygiene","name":"troisieme","quantity":3},"-Nyy9e_KOhLAQvowl3zC":{"category":"Dairy","name":"Super","quantity":1},"-Nyy9zXsuJcWToSmOFPB":{"category":"Meat","name":"Test","quantity":1},"-NyyA11zsApjPRGtH0xB":{"category":"Dairy","name":"ca met du temps","quantity":5},"-NyyAXRN2RUelz4Sq83d":{"category":"Meat","name":"test","quantity":1}}

    final Map<String, dynamic> fetchedItems = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in fetchedItems.entries) {
      final category = categories.values.firstWhere((catItem) => catItem.title == item.value['category']);

      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() => _groceryItems = loadedItems);
  }

  void _addNewItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewGroceryItem(),
      ),
    );

    _fetchItems();
  }

  void _removeItem(String id) {
    setState(() {
      _groceryItems.removeWhere((item) => item.id == id);
    });
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
              itemBuilder: (ctx, index) {
                final item = _groceryItems[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _removeItem(item.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.category.title),
                    leading: Container(
                      color: item.category.color,
                      width: 30,
                      height: 30,
                    ),
                    trailing: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
