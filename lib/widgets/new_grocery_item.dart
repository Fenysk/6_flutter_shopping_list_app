import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/data/categories.dart';

class NewGroceryItem extends StatefulWidget {
  const NewGroceryItem({super.key, required this.onSubmitNewItem});

  final Function(GroceryItem, BuildContext) onSubmitNewItem;

  @override
  State<NewGroceryItem> createState() => _NewGroceryItemState();
}

class _NewGroceryItemState extends State<NewGroceryItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    keyboardAppearance: Brightness.light,
                    decoration: const InputDecoration(
                      hintText: 'Enter the name of the item',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    keyboardAppearance: Brightness.light,
                    decoration: const InputDecoration(
                      hintText: 'Quantity',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<Category>(
              value: _selectedCategory,
              hint: const Text('Select a category'),
              items: categories.values.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.title),
                );
              }).toList(),
              onChanged: (Category? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty || _quantityController.text.isEmpty || _selectedCategory == null) return;

                final newItem = GroceryItem(
                  name: _nameController.text,
                  quantity: int.tryParse(_quantityController.text) ?? 1,
                  category: _selectedCategory!,
                );

                widget.onSubmitNewItem(newItem, context);
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
