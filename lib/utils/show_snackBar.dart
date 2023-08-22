import 'package:flutter/material.dart';

showSnack(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    title,
    style: TextStyle(fontWeight: FontWeight.bold),
  )));
}
