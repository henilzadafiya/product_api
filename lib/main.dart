import 'package:flutter/material.dart';
import 'package:product_api/details.dart';
import 'package:product_api/first.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {"first": (context) => first(), "details": (context) => details()},
    initialRoute: "first",
  ));
}
