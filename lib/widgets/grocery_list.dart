import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(groceryItems[index].name),
          subtitle: Text(groceryItems[index].category.title),
          leading: Container(
            color: groceryItems[index].category.color,
            width: 30,
            height: 30,
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
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
