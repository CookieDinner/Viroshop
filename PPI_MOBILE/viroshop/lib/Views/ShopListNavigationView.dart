import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/CustomDrawer.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ShopListNavigationViewTemplate.dart';
import 'package:viroshop/Views/ShopListNavigationViews/FavoriteShopList.dart';
import 'package:viroshop/Views/ShopListNavigationViews/Orders.dart';
import 'package:viroshop/Views/ShopListNavigationViews/ShopList.dart';

class ShopListNavigationView extends StatefulWidget {
  @override
  _ShopListNavigationViewState createState() => _ShopListNavigationViewState();
}

class _ShopListNavigationViewState extends State<ShopListNavigationView> {
  int currentTab;
  bool updating = false;
  List<ShopListNavigationViewTemplate> navigationViews = [];

  @override
  void initState() {
    currentTab = 0;
    navigationViews.add(ShopList(widget, openDrawer));
    navigationViews.add(FavoriteShopList(widget, openDrawer));
    navigationViews.add(Orders(widget, openDrawer));
    super.initState();
  }
  @override
  void dispose() {
    navigationViews.clear();
    super.dispose();
  }

  void openDrawer(){
    drawerKey.currentState.openEndDrawer();
  }
  void stateSet() {
    navigationViews.forEach((element) => element.update());
    setState(() {});
  }

  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
      child: Scaffold(
        key: drawerKey,
        endDrawer: CustomDrawer(stateSet).loginDrawer(context),
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
                icon: Icon(Icons.store_mall_directory_outlined,
                    color: CustomTheme().accent),
                activeIcon: Icon(Icons.store_mall_directory_sharp,
                    color: CustomTheme().accentPlus),
                label: "Sklepy",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_outline,
                    color: CustomTheme().accent),
                activeIcon: Icon(Icons.star,
                    color: CustomTheme().accentPlus),
                label: "Ulubione sklepy",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border_outlined,
                    color: CustomTheme().accent),
                activeIcon: Icon(Icons.bookmark,
                    color: CustomTheme().accentPlus),
                label: "Zamówienia",
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
