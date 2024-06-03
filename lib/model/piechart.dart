import 'dart:ui';

import 'package:hexcolor/hexcolor.dart';

class PieChartModel{
  String name;
  int totalNumber;
  double percent;
  HexColor color;
  PieChartModel({required this.name, required this.totalNumber, required this.percent, required this.color});
}
