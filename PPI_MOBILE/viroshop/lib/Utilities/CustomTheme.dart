import 'package:flutter/material.dart';
import 'package:viroshop/Utilities/Constants.dart';

class CustomTheme{
  static final CustomTheme data = CustomTheme._internal();
  factory CustomTheme(){
    return data;
  }
  CustomTheme._internal();

  bool isDark = false;

  Color background;
  Color backgroundWave1;
  Color backgroundWave2;
  Color backgroundWave3;
  Color waveBottom;
  Color appBarTheme;
  Color accent;
  Color accentPlus;
  Color standardText;
  Color accentText;
  Color labelText;
  Color textBackground;
  Color popupBackground;
  Color buttonColor;
  Color cardColor;

  void setTheme(bool theme){
    this.isDark = !theme;
    this.background = theme ? Constants.background : Constants.darkBackground;
    this.backgroundWave1 = theme ? Constants.backgroundWave1 : Constants.darkBackgroundWave1;
    this.backgroundWave2 = theme ? Constants.backgroundWave2 : Constants.darkBackgroundWave2;
    this.backgroundWave3 = theme ? Constants.backgroundWave3 : Constants.darkBackgroundWave3;
    this.waveBottom = theme ? Constants.waveBottom : Constants.darkWaveBottom;
    this.appBarTheme = theme ? Constants.appBarTheme : Constants.darkAppBarTheme;
    this.accent = theme ? Constants.accent : Constants.darkAccent;
    this.accentPlus = theme ? Constants.accentPlus : Constants.darkAccentPlus;
    this.standardText = theme ? Constants.standardText : Constants.darkStandardText;
    this.accentText = theme ? Constants.accentText : Constants.darkAccentText;
    this.labelText = theme ? Constants.labelText : Constants.darkLabelText;
    this.textBackground = theme ? Constants.textBackground : Constants.darkTextBackground;
    this.popupBackground = theme ? Constants.popupBackground : Constants.darkPopupBackground;
    this.buttonColor = theme ? Constants.buttonColor : Constants.darkButtonColor;
    this.cardColor = theme ? Constants.cardColor : Constants.darkCardColor;
  }

}