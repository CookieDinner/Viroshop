import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomDrawer.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Data.dart';
import 'package:viroshop/Utilities/DbHandler.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';
import 'package:viroshop/Views/ForgotPasswordView.dart';
import 'package:viroshop/Views/RegistrationView.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viroshop/Views/ShopListNavigationView.dart';

class LoginView extends StatefulWidget {
  @override
  LoginState createState() => LoginState();

}

class LoginState extends State<LoginView> with TickerProviderStateMixin{
  String login, password;
  var loginController = TextEditingController();
  var loginFocusNode = FocusNode();
  var passwordController = TextEditingController();
  var passwordFocusNode = FocusNode();
  bool theme = false;

  bool loginButton = false;

  void updateButton(){
    FocusScope.of(context).unfocus();
    setState(() {
      loginButton = !loginButton;
    });
  }
  Future<void> sendRequest() async{
    await Requests.PostLogin(loginController.text, passwordController.text).then((String message) async{
      switch(Constants.requestErrors.containsKey(message)){
        case true:
          CustomAlerts.showAlertDialog(context, "Błąd", Constants.requestErrors[message]);
          break;
        case false:
          await Requests.GetShopsInCity(Data().city).then((String value) async{
            switch(Constants.requestErrors.containsKey(value)) {
              case true:
                CustomAlerts.showAlertDialog(context, "Błąd", Constants.requestErrors[value]);
                break;
              case false:
                await DbHandler.insertToShops(value);
                Data().currentUsername = loginController.text;
                Data().loginKey = passwordController.text;
                Navigator.of(context).push(
                    CustomPageTransition(
                      ShopListNavigationView(),
                      x: 0.0,
                      y: 0.4,
                    )
                );
            }
          });
      }
    });
    updateButton();
  }

  @override
  void initState() {
    loginController.text = "test";
    passwordController.text = "123";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      theme = (await SharedPreferences.getInstance()).getBool('theme');
      await DbHandler.buildDatabase();
      setState((){});
    });
    super.initState();
  }

  @override
  void dispose() {
    loginController?.dispose();
    passwordController?.dispose();
    loginFocusNode?.dispose();
    passwordFocusNode?.dispose();
    super.dispose();
  }

  void stateSet() {
    setState(() {});
  }

  void openDrawer(){
    drawerKey.currentState.openEndDrawer();
  }

  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
        child: Scaffold(
          key: drawerKey,
          endDrawer: CustomDrawer(stateSet, withPassword: false).loginDrawer(context, isOnLoginScreen: true),
          backgroundColor: CustomTheme().background,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: mediaSize.height,
              width: mediaSize.width,
              child: Stack(
                children : <Widget> [
                  BackgroundAnimation(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            mediaSize.width * 0.24,
                            0,
                            mediaSize.width * 0.24,
                            mediaSize.height * 0.03,
                        ),
                        child: Image.asset('assets/images/viroshop_logo.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaSize.width * 0.14,
                        ),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              //Login
                              CustomTextFormField(
                                loginController,
                                'Nazwa użytkownika',
                                TextInputAction.next,
                                      (_) => passwordFocusNode.requestFocus(),
                                loginFocusNode
                              ),
                              SizedBox(height: mediaSize.height * 0.03,),
                              //Password
                              CustomTextFormField(
                                passwordController,
                                'Hasło',
                                TextInputAction.done,
                                      (_) => passwordFocusNode.unfocus(),
                                passwordFocusNode,
                                shouldObfuscate: true,
                              ),
                              SizedBox(height: mediaSize.height * 0.035,),
                              loginButton ? Spinner(mediaSize.height, this, sendRequest) : Button("Zaloguj", updateButton),
                              SizedBox(height: mediaSize.height * 0.02,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).push(
                                        CustomPageTransition(
                                          ForgotPasswordView(),
                                          x: 0.4,
                                          y: 0.55,
                                        )
                                      );
                                    },
                                    child: Text("Nie pamiętasz hasła?",
                                      style: TextStyle(
                                        fontSize: mediaSize.width * Constants.accentFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: CustomTheme().accentText
                                      ),
                                    ),
                                    padding: EdgeInsets.all(0),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                  ),
                                ],
                              ),
                              SizedBox(height: mediaSize.height * 0.01,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).push(
                                          CustomPageTransition(
                                            RegistrationView(),
                                            x: 0.1,
                                            y: 0.77,
                                          )
                                      );
                                    },
                                    child: Text("Nie masz jeszcze konta? Zarejestruj się",
                                      style: TextStyle(
                                          fontSize: mediaSize.width * Constants.accentFontSize,
                                          fontWeight: FontWeight.w400,
                                          color: CustomTheme().accentText
                                      ),
                                    ),
                                    padding: EdgeInsets.all(0),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  ),
                  CustomAppBar("",
                    withBackButton: false,
                    withOptionButton: true,
                    optionButtonAction: openDrawer,
                    optionButtonWidget: Icon(
                      Icons.settings,
                      size: mediaSize.width * 0.07,
                      color: CustomTheme().accentPlus,
                    ),
                  ),
              ]
            ),
          ),
        ),
      )
    );
  }
}