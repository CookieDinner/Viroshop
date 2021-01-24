import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/BackgroundAnimation.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomAppBar.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/Utilities/Util.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with TickerProviderStateMixin{
  var oldController = TextEditingController();
  var newController = TextEditingController();
  var repeatController = TextEditingController();
  var oldFocusNode = FocusNode();
  var newFocusNode = FocusNode();
  var repeatFocusNode = FocusNode();
  bool oldVisibility = false;
  bool passwordAlertVisibility = false;

  bool passButton = false;

  @override
  void initState() {
    newController.addListener(passwordCheck);
    repeatController.addListener(passwordCheck);
    oldController.addListener(oldPassCheck);
    super.initState();
  }

  void passwordCheck(){
    if(newController.text != repeatController.text ||
        newController.text.isEmpty ||
        repeatController.text.isEmpty) {
      //flag = true;
      passwordAlertVisibility = true;
    }
    else
      passwordAlertVisibility = false;
    setState(() {});
  }

  void oldPassCheck(){
    if(oldController.text.isEmpty){
      oldVisibility = true;
    }else{
      oldVisibility = false;
    }
    setState((){});
  }

  void updateButton(){
    FocusScope.of(context).unfocus();
    setState(() {
      passButton = !passButton;
    });
  }

  Future<void> sendRequest() async{
    bool flag = false;
    if(oldController.text.isEmpty) {
      flag = true;
      oldVisibility = true;
    }
    else
      oldVisibility = false;

    if(newController.text != repeatController.text ||
        newController.text.isEmpty ||
        repeatController.text.isEmpty) {
      flag = true;
      passwordAlertVisibility = true;
    }
    else
      passwordAlertVisibility = false;

    if(!flag) {
      await Requests.PostChangePassword(oldController.text, repeatController.text).then(
              (String message) {
            switch (message) {
              case "unknown":
                CustomAlerts.showAlertDialog(
                    context, "Błąd", "Wystąpił nieoczekiwany błąd");
                break;
              case "connfailed":
                CustomAlerts.showAlertDialog(
                    context, "Błąd", "Połączenie nieudane");
                break;
              case "conntimeout":
                CustomAlerts.showAlertDialog(
                    context, "Błąd", "Przekroczono limit czasu połączenia");
                break;
              case "httpexception":
                CustomAlerts.showAlertDialog(
                    context, "Błąd", "Wystąpił błąd kontaktu z serwerem");
                break;
              case "Error while changing password":
                CustomAlerts.showAlertDialog(
                    context, "Błąd", "Podano błędne stare hasło");
                break;
              case "Password was changed":
                CustomAlerts.showAlertDialog(
                    context, "Informacja", "Hasło zostało zmienione", dismissible: false, customFunction: (){Navigator.popUntil(context, ModalRoute.withName('/loginView'));});
                break;
              default:
                break;
            }
          });
    }
    setState(() {});
    updateButton();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Util.getDimensions(context);
    return SafeArea(
        child: Scaffold(
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
                          child: Image.asset('assets/images/passLock.png'),
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
                                    oldController,
                                    'Stare hasło',
                                    TextInputAction.next,
                                        (_) => newFocusNode.requestFocus(),
                                    oldFocusNode,
                                  shouldObfuscate: true,
                                ),
                                SizedBox(height: mediaSize.height * 0.01,),
                                Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: oldVisibility,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Stare hasło nie może być puste",
                                        style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: mediaSize.height * 0.01,),
                                CustomTextFormField(
                                    newController,
                                    'Nowe hasło',
                                    TextInputAction.next,
                                        (_) => repeatFocusNode.requestFocus(),
                                    newFocusNode,
                                  shouldObfuscate: true,
                                ),
                                SizedBox(height: mediaSize.height * 0.035,),
                                CustomTextFormField(
                                    repeatController,
                                    'Powtórz hasło',
                                    TextInputAction.done,
                                        (_) => repeatFocusNode.unfocus(),
                                    repeatFocusNode,
                                  shouldObfuscate: true,
                                ),
                                SizedBox(height: mediaSize.height * 0.01,),
                                Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: passwordAlertVisibility,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Hasła muszą być identyczne",
                                        style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: mediaSize.height * 0.01,),
                                passButton ? Spinner(mediaSize.height, this, sendRequest) : Button("Zmień hasło", updateButton),
                                SizedBox(height: mediaSize.height * 0.02,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomAppBar("Zmień hasło",),
                  ]
              ),
            ),
          ),
        )
    );
  }
}
