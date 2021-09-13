import 'package:flutter/material.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour});

  final String name;
  final int ratePerHour;

  Map<String, dynamic> toMap() => {'name': name, 'ratePerHour': ratePerHour};
}
