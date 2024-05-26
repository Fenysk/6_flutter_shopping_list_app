import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';

final groceryItems = [
  GroceryItem(
    name: '1L Milk',
    quantity: 1,
    category: categories[Categories.dairy]!,
  ),
  GroceryItem(
    name: 'Banana',
    quantity: 5,
    category: categories[Categories.fruit]!,
  ),
  GroceryItem(
    name: 'Beef Steak',
    quantity: 1,
    category: categories[Categories.meat]!,
  ),
];
