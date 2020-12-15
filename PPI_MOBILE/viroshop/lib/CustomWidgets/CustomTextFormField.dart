import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';
import 'package:viroshop/Utilities/CustomTheme.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function confirmAction;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final bool shouldObfuscate;
  final Icon trailingIcon;
  final Function onChangeAction;

  CustomTextFormField(this.controller, this.label, this.textInputAction,
      this.confirmAction, this.focusNode, {this.shouldObfuscate = false, this.trailingIcon, this.onChangeAction});

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
        cursorColor: CustomTheme().accentPlus,
        obscureText: widget.shouldObfuscate,
        onChanged: widget.onChangeAction != null ?
            (String text) => widget.onChangeAction(text) :
            (String text){},
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))
          ),
          prefixIcon: widget.trailingIcon,
          filled: true,
          fillColor: CustomTheme().textBackground,
          contentPadding: EdgeInsets.fromLTRB(
              mediaSize.width * 0.03,
              0,
              mediaSize.width * 0.03,
              mediaSize.height * 0.06 * 0.3),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          labelText: widget.label, hintText: widget.label,
          hintStyle: TextStyle(
            color: CustomTheme().labelText,
            fontSize: mediaSize.width * Constants.labelFontSize,
          ),
          labelStyle: TextStyle(
            color: CustomTheme().labelText,
            fontSize: mediaSize.width * Constants.labelFontSize,
            fontWeight: FontWeight.w400
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomTheme().accent,
                width: 2,
              )
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: CustomTheme().accentPlus,
                width: 2,
              )
          )
        ),
        style: TextStyle(
            color: CustomTheme().standardText,
            fontSize: mediaSize.height * 0.022,
            fontWeight: FontWeight.w400,
        ),
        onFieldSubmitted: widget.confirmAction
      ),
    );
  }
}