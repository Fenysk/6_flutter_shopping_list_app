import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewGroceryItem extends StatefulWidget {
  const NewGroceryItem({super.key});

  @override
  State<NewGroceryItem> createState() => _NewGroceryItemState();
}

class _NewGroceryItemState extends State<NewGroceryItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories.values.first;

  void _submitNewItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https('flutter-shopping-list-48a40-default-rtdb.europe-west1.firebasedatabase.app', 'shopping-list.json');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title,
        }),
      );

      if (response.statusCode != 200) throw Exception('Failed to add item');

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) return 'Please enter a name';
    if (name.length < 2 || name.length > 25) return 'Name must be between 2 and 25 characters';
    return null;
  }

  String? _validateQuantity(String? quantity) {
    if (quantity == null || quantity.isEmpty) return 'Please enter a quantity';
    if (int.tryParse(quantity) == null) return 'Please enter a valid number';
    return null;
  }

  String? _validateCategory(Category? category) {
    if (category == null) return 'Please select a category';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      keyboardAppearance: Brightness.light,
                      decoration: const InputDecoration(
                        hintText: 'Enter the name of the item',
                      ),
                      onSaved: (String? newName) => _enteredName = newName!,
                      validator: _validateName,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      keyboardAppearance: Brightness.light,
                      decoration: const InputDecoration(
                        hintText: 'Quantity',
                      ),
                      initialValue: _enteredQuantity.toString(),
                      onSaved: (String? newQuantity) => _enteredQuantity = int.parse(newQuantity!),
                      validator: _validateQuantity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Category>(
                hint: const Text('Select a category'),
                items: categories.values
                    .map((Category category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                color: category.color,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(category.title),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (Category? newCategory) => _selectedCategory = newCategory!,
                validator: _validateCategory,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _formKey.currentState!.reset(),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitNewItem,
                    child: const Text('Add to list'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
