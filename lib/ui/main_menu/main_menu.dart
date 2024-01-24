import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/util/window_close_handler.dart';

class MainMenu extends StatefulWidget {

  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();

    WindowCloseHandler.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("dab"),
        elevation: 5,
      ),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _navIndex,
              groupAlignment: -1,
              elevation: 5,
              onDestinationSelected: (int index) {
                setState(() {
                  _navIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Test'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Test'),
                ),
              ]
            )
          ],
        )
      ),
    );
  }
}