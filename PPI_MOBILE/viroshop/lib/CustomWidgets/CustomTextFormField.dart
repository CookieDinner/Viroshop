import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function confirmAction;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final bool shouldObfuscate;

  CustomTextFormField(this.controller, this.label, this.textInputAction,
      this.confirmAction, this.focusNode, {this.shouldObfuscate = false});

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField>{
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Container(
      height: mediaSize.height * 0.06,
      width: mediaSize.width * 0.8,
      child: TextFormField(
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        cursorColor: Constants.accentPlus,
        obscureText: widget.shouldObfuscate,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(
              mediaSize.width * 0.03,
              0,
              mediaSize.width * 0.03,
              mediaSize.height * 0.06 * 0.3),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          labelText: widget.label, hintText: widget.label,
          hintStyle: TextStyle(
            color: Constants.labelText,
            fontSize: mediaSize.width * Constants.labelFontSize,
          ),
          labelStyle: TextStyle(
            color: Constants.labelText,
            fontSize: mediaSize.width * Constants.labelFontSize,
            fontWeight: FontWeight.w400
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Constants.accent,
                width: 2,
              )
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Constants.accentPlus,
                width: 2,
              )
          )
        ),
        style: TextStyle(
            color: Constants.standardText,
            fontSize: mediaSize.height * 0.022,
            fontWeight: FontWeight.w400,
        ),
        onFieldSubmitted: widget.confirmAction
      ),
    );
  }
}