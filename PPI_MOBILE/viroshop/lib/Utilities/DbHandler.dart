import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:viroshop/Utilities/Data.dart';
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
          name TEXT NOT NULL
        );
      """);
      await txn.execute("""
        CREATE TABLE products(
          id INTEGER PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          category TEXT NOT NULL,
          available INTEGER NOT NULL,
          price REAL NOT NULL
        );
      """);
      await txn.execute("""
        CREATE TABLE cart(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          shop_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity REAL NOT NULL
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
            'name' : currentShop.name
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
                singleShop['name'])
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
            'price' : currentProduct.price
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
                singleProduct['price'])
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
}