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
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    isLoading = true;

    final url = Uri.https('flutter-shopping-list-48a40-default-rtdb.europe-west1.firebasedatabase.app', 'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) return setState(() => error = 'Failed to load items, please try again later.');

      final Map<String, dynamic>? fetchedItems = json.decode(response.body);

      if (fetchedItems == null || fetchedItems.isEmpty) return setState(() => isLoading = false);

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

      isLoading = false;
      setState(() => _groceryItems = loadedItems);
    } catch (err) {
      error = 'Failed to load items, please try again later.';
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewGroceryItem(),
      ),
    );

    if (newItem == null) return;

    setState(() => _groceryItems.add(newItem));
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    final url = Uri.https('flutter-shopping-list-48a40-default-rtdb.europe-west1.firebasedatabase.app', 'shopping-list/${item.id}.json');

    setState(() => _groceryItems.remove(item));

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      return setState(() {
        _groceryItems.insert(index, item);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete item. Restoring the item.'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No items added yet!'),
    );

    if (isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!isLoading && _groceryItems.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          final item = _groceryItems[index];
          return Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _removeItem(item),
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
      );
    }

    if (error != null) {
      setState(() {
        mainContent = Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
      });
    }

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
      body: mainContent,
    );
  }
}
