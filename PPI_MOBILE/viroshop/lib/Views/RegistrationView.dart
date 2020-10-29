import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viroshop/CustomWidgets/CustomAlerts.dart';
import 'package:viroshop/CustomWidgets/CustomPageTransition.dart';
import 'package:viroshop/CustomWidgets/CustomTextFormField.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/Requests.dart';
import 'package:viroshop/CustomWidgets/SpinnerButton.dart';
import 'package:viroshop/Views/ForgotPasswordView.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> with TickerProviderStateMixin{
  String login, email, password, repeatPassword, birthDate;
  var loginController = TextEditingController(); var loginFocusNode = FocusNode();
  var emailController = TextEditingController(); var emailFocusNode = FocusNode();
  var passwordController = TextEditingController(); var passwordFocusNode = FocusNode();
  var repeatPasswordController = TextEditingController(); var repeatPasswordFocusNode = FocusNode();
  String dateString = "Data urodzenia";

  bool generalAlertVisibility = false;
  bool loginAlertVisibility = false;
  bool passwordAlertVisibility = false;
  bool emailAlertVisibility = false;
  bool dateAlertVisibility = false;
  bool registerButton = false;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loginController.addListener(loginCheck);
    passwordController.addListener(passwordCheck);
    repeatPasswordController.addListener(passwordCheck);
    emailController.addListener(emailCheck);
  }

  void loginCheck(){
    if(loginController.text.isEmpty) {
      //flag = true;
      loginAlertVisibility = true;
    }
    else
      loginAlertVisibility = false;
    setState(() {});
  }
  void emailCheck(){
    RegExp emailReg = RegExp(r'[a-zA-Z]+.*@[a-zA-z]+[a-zA-Z0-9]*\.[a-zA-z]+');
    if(emailReg.stringMatch(emailController.text) != emailController.text) {
      //flag = true;
      emailAlertVisibility = true;
    }
    else
      emailAlertVisibility = false;
    setState(() {});
  }
  void passwordCheck(){
    if(passwordController.text != repeatPasswordController.text ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      //flag = true;
      passwordAlertVisibility = true;
    }
    else
      passwordAlertVisibility = false;
    setState(() {});
  }
  void dateCheck(){
    if(dateString == "Data urodzenia") {
      //flag = true;
      dateAlertVisibility = true;
    }
    else
      dateAlertVisibility = false;
    setState(() {});
  }
  @override
  void dispose() {
    loginController?.dispose(); loginFocusNode?.dispose();
    emailController?.dispose(); emailFocusNode?.dispose();
    passwordController?.dispose(); passwordFocusNode?.dispose();
    repeatPasswordController?.dispose(); repeatPasswordFocusNode?.dispose();
    super.dispose();
  }

  void updateButton(){
    FocusScope.of(context).unfocus();
    setState(() {
      registerButton = !registerButton;
    });
  }

  Future<void> sendRequest() async{
    bool flag = false;
    if(loginController.text.isEmpty) {
      flag = true;
      loginAlertVisibility = true;
    }
    else
      loginAlertVisibility = false;
    RegExp emailReg = RegExp(r'[a-zA-Z]+.*@[a-zA-z]+[a-zA-Z0-9]*\.[a-zA-z]+');
    if(emailReg.stringMatch(emailController.text) != emailController.text) {
      flag = true;
      emailAlertVisibility = true;
    }
    else
      emailAlertVisibility = false;
    if(passwordController.text != repeatPasswordController.text ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      flag = true;
      passwordAlertVisibility = true;
    }
    else
      passwordAlertVisibility = false;
    if(dateString == "Data urodzenia") {
      flag = true;
      dateAlertVisibility = true;
    }
    else
      dateAlertVisibility = false;

    if(!flag) {
      generalAlertVisibility = false;
      await Requests.PostRegister(
        loginController.text, emailController.text, passwordController.text,
        dateString).then(
            (String message) {
          switch (message) {
            case "userexists":
              CustomAlerts.showAlertDialog(
                  context, "Błąd", "Podany użytkownik już istnieje");
              break;
            case "registered":
              CustomAlerts.showAlertDialog(
                  context, "Informacja", "Zarejestrowano pomyślnie");
              break;
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
            default:
              break;
          }
      });
    }else
      generalAlertVisibility = true;
    setState(() {});
    updateButton();
  }

  Future<void> selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2100, 12),
      locale: Locale('pl', 'PL'),
      helpText: '',
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState((){});
      dateCheck();
    }
  }



  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Rejestracja", style: TextStyle(fontWeight: FontWeight.w400),),
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
                    SizedBox(height: mediaSize.height * 0.13,),
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
                                (_) {
                                  emailFocusNode.requestFocus();
                                },
                                loginFocusNode
                            ),
                            SizedBox(height: mediaSize.height * 0.01,),
                            Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: loginAlertVisibility,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Nazwa użytkownika nie może być pusta",
                                    style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                ],
                              ),
                            ),
                            SizedBox(height: mediaSize.height * 0.01,),
                            //Email
                            CustomTextFormField(
                                emailController,
                                'Adres email',
                                TextInputAction.next,
                                    (_) => passwordFocusNode.requestFocus(),
                                emailFocusNode
                            ),
                            SizedBox(height: mediaSize.height * 0.01,),
                            Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: emailAlertVisibility,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Podaj właściwy adres email",
                                    style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                ],
                              ),
                            ),
                            SizedBox(height: mediaSize.height * 0.01,),
                            //Password
                            CustomTextFormField(
                              passwordController,
                              'Hasło',
                              TextInputAction.next,
                                  (_) => repeatPasswordFocusNode.requestFocus(),
                              passwordFocusNode,
                              shouldObfuscate: true,
                            ),
                            SizedBox(height: mediaSize.height * 0.03,),
                            //Repeat Password
                            CustomTextFormField(
                              repeatPasswordController,
                              'Powtórz hasło',
                              TextInputAction.done,
                                  (_) => repeatPasswordFocusNode.unfocus(),
                              repeatPasswordFocusNode,
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
                                  Text("Wpisz zgodne ze sobą hasła",
                                    style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                ],
                              ),
                            ),
                            SizedBox(height: mediaSize.height * 0.01,),
                            Theme(
                              data: ThemeData(
                                primaryColor: Constants.accentPlus,
                                colorScheme: ColorScheme.light(
                                  primary: Constants.appBarTheme
                                ),
                              ),
                              child: Builder(
                                builder: (context) =>
                                  FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => selectDate(context),
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            mediaSize.width * 0.03,
                                            0,
                                            mediaSize.width * 0.03,
                                            0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(dateString,
                                              style: dateString == "Data urodzenia" ? TextStyle(
                                                  color: Constants.labelText,
                                                  fontSize: mediaSize.width * Constants.labelFontSize,
                                                  fontWeight: FontWeight.w400
                                              ) : TextStyle(
                                                  color: Constants.standardText,
                                                  fontSize: mediaSize.height * 0.022,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                              color: Constants.accent,
                                              width: 2,
                                            )
                                        )
                                      ),
                                      height: mediaSize.height * 0.06,
                                      width: mediaSize.width * 0.8,
                                    )
                                  )
                              ),
                            ),
                            SizedBox(height: mediaSize.height * 0.01,),
                            Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: dateAlertVisibility,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Podaj datę urodzenia",
                                    style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                ],
                              ),
                            ),
                            SizedBox(height: mediaSize.height * 0.02,),
                            //Button
                            registerButton ? Spinner(mediaSize.height, this, sendRequest) : Button("Zarejestruj", updateButton),
                            SizedBox(height: mediaSize.height * 0.01,),
                            Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: generalAlertVisibility,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Przed rejestracją wypełnij poprawnie formularz",
                                    style: TextStyle(color: Colors.redAccent, fontSize: mediaSize.width * Constants.alertLabelFontSize),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}
