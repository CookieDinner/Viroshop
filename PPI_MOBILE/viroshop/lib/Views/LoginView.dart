import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Views/ForgotPasswordView.dart';
import 'package:viroshop/Views/RegistrationView.dart';
import 'package:viroshop/Views/SyncView.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';


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

  bool loginButton = false;

  void updateButton(){
    FocusScope.of(context).unfocus();
    setState(() {
      loginButton = !loginButton;
    });
  }
  Future<void> sendRequest() async{
    await Requests.PostLogin(loginController.text, passwordController.text).then(
            (String message) {
              switch(message){
                case "usernotfound":
                  CustomAlerts.showAlertDialog(context, "Błąd", "Podany użytkownik nie istnieje");
                  break;
                case "cannotlogin":
                  CustomAlerts.showAlertDialog(context, "Błąd", "Błędne hasło");
                  break;
                case "unknown":
                  CustomAlerts.showAlertDialog(context, "Błąd", "Wystąpił nieoczekiwany błąd");
                  break;
                case "connfailed":
                  CustomAlerts.showAlertDialog(context, "Błąd", "Połączenie nieudane");
                  break;
                case "conntimeout":
                  CustomAlerts.showAlertDialog(context, "Błąd", "Przekroczono limit czasu połączenia");
                  break;
                case "httpexception":
                  CustomAlerts.showAlertDialog(context, "Błąd", "Wystąpił błąd kontaktu z serwerem");
                  break;
                default:
                  //TODO: Wrzucanie klucza autoryzacji do singletona
                  Navigator.of(context).push(
                      CustomPageTransition(
                        SyncView(),
                        x: 0.0,
                        y: 0.4,
                      )
                  );
                  break;
              }
    });
    //await Future.delayed(Duration(seconds: 1));
    updateButton();
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ViroShop", style: TextStyle(fontWeight: FontWeight.w400),),
            titleSpacing: mediaSize.width * 0.04,
            backgroundColor: Constants.appBarTheme,
          ),
          backgroundColor: Constants.background,
          body: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/tempbg.png"),
                fit: BoxFit.cover
              )
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Logo
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        mediaSize.width * 0.26,
                        mediaSize.height * 0.05,
                        mediaSize.width * 0.26,
                        mediaSize.height * 0.05,
                    ),
                    child: Image.asset('assets/images/logo.png'),
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
                          SizedBox(height: mediaSize.height * 0.01,),
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
                                    color: Constants.accentText
                                  ),
                                ),
                                padding: EdgeInsets.all(0),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                            ],
                          ),
                          SizedBox(height: mediaSize.height * 0.05,),
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
                                      color: Constants.accentText
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
            ),
          ),
        )
    );
  }
}