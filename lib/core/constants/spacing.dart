// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Spacing {
  static const EdgeInsetsGeometry a4 = EdgeInsets.all(4);
  static const EdgeInsetsGeometry t4 = EdgeInsets.only(top: 4);
  static const EdgeInsetsGeometry b4 = EdgeInsets.only(bottom: 4);
  static const EdgeInsetsGeometry l4 = EdgeInsets.only(left: 4);
  static const EdgeInsetsGeometry r4 = EdgeInsets.only(right: 4);
  static const EdgeInsetsGeometry v4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsetsGeometry h4 = EdgeInsets.symmetric(horizontal: 4);

  static const EdgeInsetsGeometry a8 = EdgeInsets.all(8);
  static const EdgeInsetsGeometry t8 = EdgeInsets.only(top: 8);
  static const EdgeInsetsGeometry b8 = EdgeInsets.only(bottom: 8);
  static const EdgeInsetsGeometry l8 = EdgeInsets.only(left: 8);
  static const EdgeInsetsGeometry r8 = EdgeInsets.only(right: 8);
  static const EdgeInsetsGeometry v8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsetsGeometry h8 = EdgeInsets.symmetric(horizontal: 8);

  static const EdgeInsetsGeometry a12 = EdgeInsets.all(12);
  static const EdgeInsetsGeometry t12 = EdgeInsets.only(top: 12);
  static const EdgeInsetsGeometry b12 = EdgeInsets.only(bottom: 12);
  static const EdgeInsetsGeometry l12 = EdgeInsets.only(left: 12);
  static const EdgeInsetsGeometry r12 = EdgeInsets.only(right: 12);
  static const EdgeInsetsGeometry v12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsetsGeometry h12 = EdgeInsets.symmetric(horizontal: 12);

  static const EdgeInsetsGeometry a16 = EdgeInsets.all(16);
  static const EdgeInsetsGeometry t16 = EdgeInsets.only(top: 16);
  static const EdgeInsetsGeometry b16 = EdgeInsets.only(bottom: 16);
  static const EdgeInsetsGeometry l16 = EdgeInsets.only(left: 16);
  static const EdgeInsetsGeometry r16 = EdgeInsets.only(right: 16);
  static const EdgeInsetsGeometry v16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsetsGeometry h16 = EdgeInsets.symmetric(horizontal: 16);

  static const EdgeInsetsGeometry a20 = EdgeInsets.all(20);
  static const EdgeInsetsGeometry t20 = EdgeInsets.only(top: 20);
  static const EdgeInsetsGeometry b20 = EdgeInsets.only(bottom: 20);
  static const EdgeInsetsGeometry l20 = EdgeInsets.only(left: 20);
  static const EdgeInsetsGeometry r20 = EdgeInsets.only(right: 20);
  static const EdgeInsetsGeometry v20 = EdgeInsets.symmetric(vertical: 20);
  static const EdgeInsetsGeometry h20 = EdgeInsets.symmetric(horizontal: 20);

  static const EdgeInsetsGeometry a28 = EdgeInsets.all(28);
  static const EdgeInsetsGeometry t28 = EdgeInsets.only(top: 28);
  static const EdgeInsetsGeometry b28 = EdgeInsets.only(bottom: 28);
  static const EdgeInsetsGeometry l28 = EdgeInsets.only(left: 28);
  static const EdgeInsetsGeometry r28 = EdgeInsets.only(right: 28);
  static const EdgeInsetsGeometry v28 = EdgeInsets.symmetric(vertical: 28);
  static const EdgeInsetsGeometry h28 = EdgeInsets.symmetric(horizontal: 28);

  static const EdgeInsetsGeometry a32 = EdgeInsets.all(32);
  static const EdgeInsetsGeometry t32 = EdgeInsets.only(top: 32);
  static const EdgeInsetsGeometry b32 = EdgeInsets.only(bottom: 32);
  static const EdgeInsetsGeometry l32 = EdgeInsets.only(left: 32);
  static const EdgeInsetsGeometry r32 = EdgeInsets.only(right: 32);
  static const EdgeInsetsGeometry v32 = EdgeInsets.symmetric(vertical: 32);
  static const EdgeInsetsGeometry h32 = EdgeInsets.symmetric(horizontal: 32);
}

const double sp0 = 0;
const double sp2 = 2;
const double sp4 = 4;
const double sp6 = 6;
const double sp8 = 8;
const double sp12 = 12;
const double sp16 = 16;
const double sp20 = 20;
const double sp24 = 24;
const double sp28 = 28;
const double sp32 = 32;
const double sp40 = 40;
const double sp48 = 48;
const double sp54 = 54;
const double sp56 = 56;
const double sp60 = 60;
const double sp64 = 64;
const double sp80 = 80;
const double sp124 = 124;

Widget gapWidth(double value) {
  return SizedBox(width: value);
}

Widget gapHeight(double value) {
  return SizedBox(height: value);
}

Widget gap(double width, double height) {
  return SizedBox(height: height, width: width);
}
