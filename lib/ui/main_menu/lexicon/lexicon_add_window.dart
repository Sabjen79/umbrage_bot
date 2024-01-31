import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';


// TO-DO: Re-do all of this better!
class LexiconAddWindow extends MainWindow {
  LexiconAddWindow({super.key}) : super(route: "create_variable", name: "Create Variable", sideBarIcon: Symbols.add_circle);

  @override
  State<LexiconAddWindow> createState() => _LexiconAddWindowState();
}

class _LexiconAddWindowState extends State<LexiconAddWindow> {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        ElevatedButton(
          onPressed: () {
            MainMenuRouter().block(() async {
              MainMenuRouter().unblock();
            }, () async {
              await Future.delayed(const Duration(seconds: 1));
                
              MainMenuRouter().unblock();
            });
          }, child: Text("dab"))
      ]
    );
  }
}