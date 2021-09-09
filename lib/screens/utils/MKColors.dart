import 'package:flutter/material.dart';

const mkColorPrimary = Color(0XFF4EBFB4);
const mkColorSecondary = Color(0XFF52E3E1);
const mkColorThird = Color(0XFF00C9C6);
const mkColorPrimaryLight = Color(0XFFB4D9D5);
const mkColorPrimaryDark = Color(0XFF025951);

// const mkColorPrimaryDark = Color(0XFF325BF0);
const mkColorAccent = Color(0XFFD81B60);
const mkTextColorPrimary = Color(0XFF130925);
const mkTextColorSecondary = Color(0XFF888888);
const mkTextColorThird = Color(0XFFBABFB6);
const mkTextColorGrey = Color(0XFFB4BBC2);
const mkWhite = Color(0XFFFFFFFF);
const mkBlack = Color(0XFF000000);
const mkGreen = Colors.green;
const mkWhite2 = Color(0XFFFCFCFC);
const mkLayoutBackgroundWhite = Color(0XFFF6F7FA);
const mkViewColor = Color(0XFFB4BBC2);
const mkSkyBlue = Color(0XFF1fc9cd);
const mkDarkNavy = Color(0XFF130925);
const mkCat1 = Color(0XFF45c7db);
const mkCat2 = Color(0XFFFFCB88);
const mkCat3 = Color(0XFFF2D335);
const mkCat4 = Color(0XFF92E8BA);
const mkCat5 = Color(0XFFE8BADB);
const mkCat6 = Color(0XFF7E92FF);
const mkShadowColor = Color(0X95E9EBF0);
const mkRed = Colors.red;
const mkYellow = Color(0XFFF2D335);
const mkColorPrimary50 = Color(0X8096B753);
const mk_view_color = Color(0xFFB4BBC2);

const mkColorScheme = ColorScheme(
    primary: mkColorPrimary,
    primaryVariant: mkColorPrimaryDark,
    secondary: mkColorSecondary,
    secondaryVariant: mkColorThird,
    surface: mkWhite,
    background: mkWhite,
    error: mkRed,
    onPrimary: mkWhite,
    onSecondary: mkBlack,
    onSurface: mkTextColorPrimary,
    onBackground: mkWhite,
    onError: mkRed,
    brightness: Brightness.light);

ThemeData mosq = ThemeData.from(colorScheme: mkColorScheme);
