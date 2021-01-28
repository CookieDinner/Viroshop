import 'package:viroshop/World/Shop.dart';
import 'Product.dart';

class Order implements Comparable{
  final int id;
  final DateTime orderDate;
  final Shop shop;
  final List<Product> products;
  int quarterOfDay;

  Order(this.id, this.products, this.orderDate, this.shop, this.quarterOfDay);

  @override
  int compareTo(other) {
    if (this.orderDate == null && other.orderDate != null) {
      return -1;
    }else if (this.orderDate != null && other.orderDate == null){
      return 1;
    }else if (this.orderDate == null && other.orderDate == null){
      return 0;
    }else {
      int x1 = this.orderDate.millisecondsSinceEpoch + this.quarterOfDay;
      int x2 = other.orderDate.millisecondsSinceEpoch + other.quarterOfDay;
      if (x1 < x2)
        return -1;
      else
        return 1;
    }
  }
}
