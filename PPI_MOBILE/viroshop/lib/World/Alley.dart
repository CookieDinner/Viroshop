import 'dart:convert';
import 'package:viroshop/Utilities/Requests.dart';
import 'Product.dart';

enum BlockTypes {
  red,
  gray,
  green,
  yellow,
  transparent
}

class Alley {
  final int id;
  final int xposition;
  final int yposition;
  final String type;
  final List<Product> products;
  final int shopId;
  BlockTypes blockType;

  Alley(this.id, this.xposition, this.yposition, this.type, this.products, this.shopId, {this.blockType = BlockTypes.gray});

  Alley.empty() : id = 0, xposition = 0, yposition = 0, type = "", products = [], shopId = 0, blockType = BlockTypes.gray;

  Future<List<Product>> makeProductsList() async{
    List<Product> alleyProducts = [];
    String alleysJson = await Requests.GetAlleys(1);
    for(Map<String, dynamic> product in jsonDecode(alleysJson)[14]["products"])
      alleyProducts.add(Product(product["id"], product["name"], product["category"], 1, 0, "", ""));
    return alleyProducts;
  }
}