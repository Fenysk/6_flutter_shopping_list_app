import 'package:shopping_list_app/models/category.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

String get generatedId => 'grcr_${uuid.v4().trim().replaceAll('-', '').substring(0, 8)}';

class GroceryItem {
  GroceryItem({
    required this.name,
    required this.quantity,
    required this.category,
  }) : id = generatedId;

  final String id;
  final String name;
  final int quantity;
  final Category category;
}
