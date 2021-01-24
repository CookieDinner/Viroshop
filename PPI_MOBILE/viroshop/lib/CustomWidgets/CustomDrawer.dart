import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ChangePassword.dart';

import 'CustomPageTransition.dart';

class CustomDrawer{
  Function stateSet;
  bool withCities;
  bool withPassword;
  CustomDrawer(this.stateSet, {this.withCities = true, this.withPassword = true});

  Widget loginDrawer(BuildContext context, {bool isOnLoginScreen = false}) {
    var mediaSize = Util.getDimensions(context);
    bool theme = !CustomTheme().isDark;
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: CustomTheme().standardText, width: 0.2),
            left: BorderSide(color: CustomTheme().standardText, width: 0.2),
            bottom: BorderSide(color: CustomTheme().standardText, width: 0.2),
          ),
          color: CustomTheme().background
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: CustomTheme().standardText, width: 0.2)
                )
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: mediaSize.width * 0.15,
                      width: mediaSize.width * 0.15,
                      child: Image.asset('assets/images/viroshop_logo.png')
                    ),
                    SizedBox(width: mediaSize.width * 0.02,),
                    Text("Opcje",
                      style: TextStyle(
                        color: CustomTheme().standardText,
                        fontWeight: FontWeight.w600,
                        fontSize: mediaSize.width * Constants.appBarFontSize
                    ),),
                  ],
                ),
              ),
            ),
            Container(
              height: mediaSize.height * 0.1,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: CustomTheme().standardText, width: 0.6)
                )
              ),
              child: Center(
                child: SwitchListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: mediaSize.width * 0.02,),
                      Text("Ciemny motyw",
                          style: TextStyle(
                            color: CustomTheme().standardText,
                            fontWeight: FontWeight.w400
                          )
                      ),
                    ],
                  ),
                  value: theme,
                  onChanged: (bool value) => changeTheme(theme),
                ),
              ),
            ),
            withPassword ? Container(
              height: mediaSize.height * 0.1,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: CustomTheme().standardText, width: 0.6)
                  )
              ),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                      CustomPageTransition(
                        ChangePassword(),
                        x: 0.0,
                        y: 0.1,
                      )
                  ),
                  child: Container(
                    height: mediaSize.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: mediaSize.width * 0.06,),
                        Text("Zmień hasło",
                            style: TextStyle(
                                color: CustomTheme().standardText,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ) : Container(),
            withCities ? Container(
              height: mediaSize.height * 0.1,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: CustomTheme().standardText, width: 0.3)
                )
              ),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: mediaSize.width * 0.02,),
                          Text("Miasto",
                            style: TextStyle(
                              color: CustomTheme().standardText,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: mediaSize.width * 0.02,),
                          Text(Data().city,
                              style: TextStyle(
                                  color: CustomTheme().standardText.withOpacity(0.5)
                              )
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: mediaSize.width * 0.64,
                        height: mediaSize.height * 0.1,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: CustomTheme().background,
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            iconSize: 0,
                            underline: Container(),
                            items: Constants.cities.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: CustomTheme().standardText),),
                              );
                            }).toList(),
                            onChanged: (value) => changeCity(value, context, isOnLoginScreen),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ) : Container(),
            Container(
              child: ListTile(),
            )
          ],
        ),
      ),
    );
  }

  void changeTheme(bool theme) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    theme = !(prefs.getBool('theme'));
    await prefs.setBool('theme', theme);
    CustomTheme().setTheme(theme);
    stateSet();
  }

  void changeCity(String city, BuildContext context, bool isOnLoginScreen) async{
    if (isOnLoginScreen){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Data().city = city;
      await prefs.setString('city', city);
      stateSet();
    }else{
      CustomAlerts.showLoading(context, () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Data().city = city;
        await prefs.setString('city', city);
        await Requests.GetShopsInCity(city).then((String value) async{
          switch(Constants.requestErrors.containsKey(value)){
            case true:
              Navigator.pop(context);
              CustomAlerts.showAlertDialog(context, "Błąd", Constants.requestErrors[value]);
              break;
            case false:
              await DbHandler.insertToShops(value);
              Navigator.pop(context);
              break;
          }
        });
        stateSet();
      });
    }
  }
}