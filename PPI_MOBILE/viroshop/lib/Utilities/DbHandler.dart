import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/World/CartItem.dart';
import 'package:viroshop/World/Product.dart';
import 'package:viroshop/World/Shop.dart';

class DbHandler {
  DbHandler();

  static Future<void> buildDatabase() async{
    Database db;
    try{
      db = await openDatabase(Data().dbPath, version: 1,
          onCreate: (Database db, int version) async{
            await createLocalDatabase(db);
          });
    } on Exception catch (e){
      debugPrint("Error building the database: \n${e.toString()}");
    } finally {
      if (db != null)
        await db.close();
    }
  }

  static Future<void> createLocalDatabase(Database db) async{
    await db.transaction((txn) async{
      await txn.execute("""
        CREATE TABLE shops(
          id INTEGER PRIMARY KEY NOT NULL,
          city TEXT NOT NULL,
          street TEXT NOT NULL,
          number INTEGER NOT NULL,
          name TEXT NOT NULL,
          maxReservationsPerQuarterOfHour INTEGER NOT NULL
        );
      """);
      await txn.execute("""
        CREATE TABLE products(
          id INTEGER PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          category TEXT NOT NULL,
          available INTEGER NOT NULL,
          price REAL NOT NULL,
          picture TEXT NOT NULL,
          unit TEXT NOT NULL
        );
      """);
      await txn.execute("""
        CREATE TABLE cart(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          username TEXT NOT NULL,
          shop_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL
        );
      """);
    });
  }

  static Future<void> insertToShops(String shopsJson) async{
    Database db;
    try {
      db = await openDatabase(Data().dbPath);
      List<dynamic> list = jsonDecode(shopsJson);
      await db.transaction((txn) async{
        Batch batch = txn.batch();
        batch.delete("shops");
        list.forEach((element) {
          Shop currentShop = Shop.fromJson(element);
          batch.insert("shops", {
            'id' : currentShop.id,
            'city' : currentShop.city,
            'street' : currentShop.street,
            'number' : currentShop.number,
            'name' : currentShop.name,
            'maxReservationsPerQuarterOfHour' : currentShop.maxReservationsPerQuarterOfHour
          });
        });
        await batch.commit(noResult: true);
      });
    } on Exception catch(e){
      debugPrint("Error adding shops:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
  }


  static Future<List<Shop>> getShops() async{
    Database db;
    List<Shop> shops = [];
    try{
      db = await openDatabase(Data().dbPath);
      var queryShops = await db.query('shops');
      for(Map<String, dynamic> singleShop in queryShops){
        shops.add(
          Shop(
            singleShop['id'],
            singleShop['city'],
            singleShop['street'],
            singleShop['number'],
            singleShop['name'],
            singleShop['maxReservationsPerQuarterOfHour'])
        );
      }
    } on Exception catch(e){
      debugPrint("Error reading shops:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
    return shops;
  }

  static Future<void> insertToProducts(String productsJson) async{
    Database db;
    try {
      db = await openDatabase(Data().dbPath);
      List<dynamic> list = jsonDecode(productsJson);
      await db.transaction((txn) async{
        Batch batch = txn.batch();
        batch.delete("products");
        list.forEach((element) {
          Product currentProduct = Product.fromJson(element);
          batch.insert("products", {
            'id' : currentProduct.id,
            'name' : currentProduct.name,
            'category' : currentProduct.category,
            'available' : currentProduct.available,
            'price' : currentProduct.price,
            'picture' : currentProduct.picture,
            'unit' : currentProduct.unit
          });
        });
        await batch.commit(noResult: true);
      });
    } on Exception catch(e){
      debugPrint("Error adding products:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
  }

  static Future<List<Product>> getProducts() async{
    Database db;
    List<Product> products = [];
    try{
      db = await openDatabase(Data().dbPath);
      var queryProducts = await db.query('products');
      for(Map<String, dynamic> singleProduct in queryProducts){
        products.add(
            Product(
                singleProduct['id'],
                singleProduct['name'],
                singleProduct['category'],
                singleProduct['available'],
                singleProduct['price'],
                singleProduct['picture'],
                singleProduct['unit'])
        );
      }
    } on Exception catch(e){
      debugPrint("Error reading products:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
    return products;
  }

  static Future<List<String>> getCategories() async{
    Database db;
    List<String> categories = [];
    try{
      db = await openDatabase(Data().dbPath);
      var queryCategories = await db.rawQuery("select distinct category from products");
      for(Map<String, dynamic> singleProduct in queryCategories){
        categories.add(singleProduct['category']);
      }
    } on Exception catch(e){
      debugPrint("Error reading categories:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
    return categories;
  }

  static Future<bool> insertToCart(Shop shop, Product product, int quantity) async{
    Database db;
    try{
      db = await openDatabase(Data().dbPath);
      var queryCheck = await db.rawQuery("""
        Select * from cart
        where username == '${Data().currentUsername}' and shop_id == ${shop.id} and product_id = ${product.id};  
      """);
      if (queryCheck.isEmpty) {
        await db.transaction((txn) async {
          await txn.insert("cart", {
            'username' : Data().currentUsername,
            'shop_id': shop.id,
            'product_id': product.id,
            'quantity': quantity,
          });
        });
      }else{
        int id = queryCheck.first['id'];
        int currentQuantity = queryCheck.first['quantity'];
        await db.transaction((txn) async{
          await txn.update('cart',
            {'quantity' : (currentQuantity + quantity)},
            where: 'id = ?',
            whereArgs: [id]
          );
        });
      }
    } on Exception catch(e){
      debugPrint("Error adding to cart:\n${e.toString()}");
    }finally{
      if(db != null)
        await db.close();
    }
    return false;
  }

  static Future<bool> editCart(Shop shop, Product product, int quantity) async{
    Database db;
    try{
      db = await openDatabase(Data().dbPath);
        await db.transaction((txn) async{
          await txn.update('cart',
              {'quantity' : quantity},
              where: 'username = ? and shop_id = ? and product_id = ?',
              whereArgs: [Data().currentUsername, shop.id, product.id]
          );
        });
    } on Exception catch(e){
      debugPrint("Error editing cart:\n${e.toString()}");
    }finally{
      if(db != null)
        await db.close();
    }
    return false;
  }

  static Future<bool> deleteFromCart(CartItem cartItem) async{
    Database db;
    try {
      db = await openDatabase(Data().dbPath);
        await db.transaction((txn) async {
          await txn.delete("cart", where: 'id = ?', whereArgs: [cartItem.id]);
        });
    } on Exception catch(e){
      debugPrint("Error deleting from cart:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
    return false;
  }

  static Future<bool> clearCart(bool mode, List<CartItem> cartItems) async{
    Database db;
    try {
      db = await openDatabase(Data().dbPath);
      await db.transaction((txn) async {
        if (!mode) {
          Batch batch = txn.batch();
          for (CartItem cartItem in cartItems) {
            String test = await Requests.getProductById(
                cartItem.cartProduct.id);
            Map<String, dynamic> map = jsonDecode(test);
            if (map['canBePurchaseToParcelLocker'])
              batch.delete("cart", where: 'username = ? and shop_id = ? and id = ?', whereArgs: [Data().currentUsername, Data().currentShop.id, cartItem.id]);
          }
          await batch.commit(noResult: true);
        }else
          txn.delete("cart", where: 'username = ? and shop_id = ?', whereArgs: [Data().currentUsername, Data().currentShop.id]);
      });
    } on Exception catch(e){
      debugPrint("Error deleting from cart:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
    return false;
  }

  static Future<List<CartItem>> getCart(Shop shop) async{
    Database db;
    List<CartItem> cartItems = [];
    try{
      db = await openDatabase(Data().dbPath);
      var queryCartItems = await db.rawQuery("""
        Select cart.id            as cartId, 
               products.id        as productId, 
               products.name      as productName, 
               products.category  as productCategory, 
               products.available as productAvailable, 
               products.price     as productPrice, 
               products.picture   as productPicture,
               products.unit      as productUnit,
               cart.quantity      as cartQuantity
        from cart inner join products on (cart.product_id == products.id)
        where cart.shop_id == ${shop.id} and cart.username == '${Data().currentUsername}' order by cart.id;  
      """);
      for(Map<String, dynamic> singleCartItem in queryCartItems){
        cartItems.add(
          CartItem(singleCartItem['cartId'],
            Product(
              singleCartItem['productId'],
              singleCartItem['productName'],
              singleCartItem['productCategory'],
              singleCartItem['productAvailable'],
              singleCartItem['productPrice'],
              singleCartItem['productPicture'],
              singleCartItem['productUnit']
            ),
            singleCartItem['cartQuantity']
          )
        );
      }
    } on Exception catch(e){
      debugPrint("Error reading cart:\n${e.toString()}");
    } finally{
      if(db != null)
        await db.close();
    }
    return cartItems;
  }
}