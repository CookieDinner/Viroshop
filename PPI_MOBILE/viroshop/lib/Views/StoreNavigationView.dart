import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/NavigationViews/Cart.dart';
import 'package:viroshop/Views/NavigationViews/Categories.dart';
import 'package:viroshop/Views/NavigationViews/EnterStore.dart';
import 'package:viroshop/Views/NavigationViews/NavigationViewTemplate.dart';
import 'package:viroshop/Views/NavigationViews/Products.dart';
import 'package:viroshop/Views/NavigationViews/StoreMap.dart';

class StoreNavigationView extends StatefulWidget {
  int chosenTab;
  StoreNavigationView(this.chosenTab);
  @override
  _StoreNavigationViewState createState() => _StoreNavigationViewState();
}

class _StoreNavigationViewState extends State<StoreNavigationView> {
  int currentTab;
  bool updating = false;
  List<NavigationViewTemplate> navigationViews = [];

  @override
  void initState() {

    currentTab = widget.chosenTab;
    navigationViews.add(Products(widget));
    navigationViews.add(Categories(widget));
    navigationViews.add(Cart(widget));
    navigationViews.add(EnterStore(widget));
    navigationViews.add(StoreMap(widget));
    navigationViews[currentTab].update();
    super.initState();
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
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.av_timer_sharp,
              //       color: CustomTheme().accent),
              //   activeIcon: Icon(Icons.timer_sharp,
              //       color: CustomTheme().accentPlus),
              //   label: "Wejdź",
              // ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.map_outlined,
              //       color: CustomTheme().accent),
              //   activeIcon: Icon(Icons.map_sharp,
              //       color: CustomTheme().accentPlus),
              //   label: "Mapa",
              // ),
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
