import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({super.key})
      : super(
          backgroundColor: const Color.fromARGB(234, 1, 92, 86),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 76.0),
                child: Image.asset(
                  'images/logo-removebg-preview.png',
                  fit: BoxFit.fitHeight,
                  height: 72,
                ),
              ),
            ],
          ),
        );
}
