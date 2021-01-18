import 'package:flutter/cupertino.dart';
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

class ForgotPasswordView extends StatefulWidget{
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> with TickerProviderStateMixin{
  var loginController = TextEditingController();
  var loginFocusNode = FocusNode();

  bool loginButton = false;

  void updateButton(){
    FocusScope.of(context).unfocus();
    setState(() {
      loginButton = !loginButton;
    });
  }
  Future<void> sendRequest() async{
    await Requests.PostForgotPassword(loginController.text).then((String message) async{
      switch(Constants.requestErrors.containsKey(message)){
        case true:
          CustomAlerts.showAlertDialog(context, "Błąd", Constants.requestErrors[message]);
          break;
        case false:
          CustomAlerts.showAlertDialog(context, "Informacja", "Na twój adres e-mail zostało wysłane nowo wygenerowane hasło. Użyj go do zalogowania się a następnie zmień hasło na wygodne dla Ciebie.", customTime: 6);
          break;
      }
    });
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
                                    loginController,
                                    'Nazwa użytkownika',
                                    TextInputAction.next,
                                        (_) => loginFocusNode.unfocus(),
                                    loginFocusNode
                                ),
                                SizedBox(height: mediaSize.height * 0.035,),
                                loginButton ? Spinner(mediaSize.height, this, sendRequest) : Button("Zresetuj hasło", updateButton),
                                SizedBox(height: mediaSize.height * 0.02,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomAppBar("Zresetuj hasło",),
                  ]
              ),
            ),
          ),
        )
    );
  }
}
