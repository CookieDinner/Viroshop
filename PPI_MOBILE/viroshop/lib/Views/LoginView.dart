import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:viroshop/Utilities/Requests.dart';


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
      setState(() {
        loginButton = !loginButton;
      });
  }
  Future<void> sendRequest() async{
    await Requests.PostLogin(loginController.text, passwordController.text);
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
                        mediaSize.width * 0.15,
                        mediaSize.width * 0.26,
                        mediaSize.width * 0.13,
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
                            passwordFocusNode
                          ),
                          SizedBox(height: mediaSize.height * 0.035,),
                          loginButton ? Spinner(mediaSize.height, this, sendRequest) : Button(updateButton),
                          SizedBox(height: mediaSize.height * 0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                onPressed: (){},
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
                          FlatButton(
                            onPressed: (){},
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

class Button extends StatelessWidget{
  final Function fun;
  Button(this.fun);
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: mediaSize.height * 0.06,
      color: Constants.accent,
      child: FlatButton(
          onPressed: () => fun(),
          child: Text("Zaloguj",style: TextStyle(fontSize: mediaSize.height * 0.026, color: Colors.white, fontWeight: FontWeight.w400),),
      ),
    );
  }
}

class Spinner extends StatelessWidget{
  final TickerProvider provider;
  final size;
  final Function fun;
  Spinner(this.size, this.provider, this.fun);
  @override
  Widget build(BuildContext context) {
    Future(()=>fun());
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      child: SpinKitFadingCube(
        color: Constants.accent,
        size: MediaQuery.of(context).size.height * 0.04,
        controller: AnimationController(
          vsync: provider, duration: const Duration(milliseconds: 1500)
        ),
      ),
    );
  }
}