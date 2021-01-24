import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/InsideShopNavigationViews/Cart.dart';
import 'package:viroshop/Views/InsideShopNavigationViews/Categories.dart';
import 'package:viroshop/Views/InsideShopNavigationViews/Products.dart';
import 'package:viroshop/Views/InsideShopNavigationViewTemplate.dart';

class InsideShopNavigationView extends StatefulWidget {
  int chosenTab;
  InsideShopNavigationView(this.chosenTab);
  @override
  _StoreNavigationViewState createState() => _StoreNavigationViewState();
}

class _StoreNavigationViewState extends State<InsideShopNavigationView> {
  int currentTab;
  bool updating = false;
  InsideShopNavigationViewTemplate currentCategory;
  List<InsideShopNavigationViewTemplate> navigationViews = [];

  @override
  void initState() {
    currentCategory = Categories(widget, changeCategoriesScreen);
    currentTab = widget.chosenTab;
    navigationViews.add(Products(widget));
    navigationViews.add(currentCategory);
    navigationViews.add(Cart(widget));
    navigationViews[currentTab].update();
    super.initState();
  }

  void changeCategoriesScreen(bool shouldChangeToProducts, String name){
    if (shouldChangeToProducts) {
      setState(() {
        navigationViews.removeAt(1);
        navigationViews.insert(1, Products(widget, function: changeCategoriesScreen, filteredBy: name));
      });
    }else{
      setState(() {
        navigationViews.removeAt(1);
        navigationViews.insert(1, Categories(widget, changeCategoriesScreen));
      });
    }
  }


  @override
  void dispose() {
    navigationViews.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          color: CustomTheme().background,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            onTap: (index) async {
              FocusScope.of(context).unfocus();
              if (!updating){
                updating = true;
                currentTab = index;
                setState(() {});
                await navigationViews[index].update();
                updating = false;
              }
            },
            backgroundColor: CustomTheme().cardColor,
            unselectedItemColor: CustomTheme().accentText,
            selectedItemColor: CustomTheme().accentPlus,
            selectedFontSize: 15,
            unselectedFontSize: 13,
            iconSize: 13*(mediaSize.height / mediaSize.width),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined,
                    color: CustomTheme().accent),
                activeIcon: Icon(Icons.shopping_bag_sharp,
                    color: CustomTheme().accentPlus),
                label: "Produkty",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_special_outlined,
                    color: CustomTheme().accent),
                activeIcon: Icon(Icons.folder_special_sharp,
                    color: CustomTheme().accentPlus),
                label: "Kategorie",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined,
                  color: CustomTheme().accent),
                activeIcon: Icon(Icons.shopping_cart_sharp,
                  color: CustomTheme().accentPlus,
                ),
                label: "Koszyk",
              ),
            ],
          ),
        ),
        body: Container(
          height: mediaSize.height,
          width: mediaSize.width,
          child: IndexedStack(
            index: currentTab,
            children: navigationViews,
          ),
        ),
      ),
    );
  }
}
