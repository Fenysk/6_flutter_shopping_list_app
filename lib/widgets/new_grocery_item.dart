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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetForm() {
    _nameController.clear();
    _quantityController.clear();

    setState(() => _selectedCategory = null);
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
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      keyboardAppearance: Brightness.light,
                      decoration: const InputDecoration(
                        hintText: 'Enter the name of the item',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a name';
                        if (value.length < 2 || value.length > 25) return 'Name must be between 2 and 25 characters';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      keyboardAppearance: Brightness.light,
                      decoration: const InputDecoration(
                        hintText: 'Quantity',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a quantity';
                        if (int.tryParse(value) == null) return 'Please enter a valid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
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
                onChanged: (Category? newCategory) => setState(() => _selectedCategory = newCategory),
                validator: (value) {
                  if (value == null) return 'Please select a category';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Color.fromARGB(184, 35, 194, 223)),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newItem = GroceryItem(
                          name: _nameController.text,
                          quantity: int.tryParse(_quantityController.text)!,
                          category: _selectedCategory!,
                        );

                        widget.onSubmitNewItem(newItem, context);
                      }
                    },
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
