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

  bool passButton = false;

  void updateButton(){
    FocusScope.of(context).unfocus();
    setState(() {
      passButton = !passButton;
    });
  }
  Future<void> sendRequest() async{
    await Requests.PostForgotPassword(repeatController.text).then((String message) async{
      switch(Constants.requestErrors.containsKey(message)){
        case true:
          CustomAlerts.showAlertDialog(context, "Błąd", Constants.requestErrors[message]);
          break;
        case false:
          CustomAlerts.showAlertDialog(context, "Informacja", "Hasło zostało zmienione", customTime: 6);
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
                                    oldController,
                                    'Stare hasło',
                                    TextInputAction.next,
                                        (_) => newFocusNode.requestFocus(),
                                    oldFocusNode
                                ),
                                SizedBox(height: mediaSize.height * 0.03,),
                                CustomTextFormField(
                                    newController,
                                    'Nowe hasło',
                                    TextInputAction.next,
                                        (_) => repeatFocusNode.requestFocus(),
                                    newFocusNode
                                ),
                                SizedBox(height: mediaSize.height * 0.03,),
                                CustomTextFormField(
                                    repeatController,
                                    'Powtórz hasło',
                                    TextInputAction.done,
                                        (_) => repeatFocusNode.unfocus(),
                                    repeatFocusNode
                                ),
                                SizedBox(height: mediaSize.height * 0.035,),
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
