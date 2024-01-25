import 'package:flutter/material.dart';

class LexiconMenu extends StatefulWidget {
  const LexiconMenu({super.key});

  @override
  State<LexiconMenu> createState() => _LexiconMenuState();
}

class _LexiconMenuState extends State<LexiconMenu> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Container(),
          ),
        ],
      ),
    );
  }
}