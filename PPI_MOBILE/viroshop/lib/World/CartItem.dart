import 'package:viroshop/World/Product.dart';

class CartItem {
  final int id;
  final Product cartProduct;
  final int quantity;
  CartItem(this.id, this.cartProduct, this.quantity);
}
