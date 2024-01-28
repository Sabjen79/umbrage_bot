import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window_list.dart';
import 'package:umbrage_bot/ui/main_menu/secondary_side_bar/secondary_side_bar.dart';
import 'package:umbrage_bot/ui/main_menu/side_bar/side_bar.dart';

abstract class MainWindow extends StatefulWidget {
  final String _name;
  final IconData? _icon;
  final MainSubWindowList windows = MainSubWindowList();

  MainWindow(this._name, this._icon, {required super.key});

  String getName() {
    return _name;
  }

  IconData? getIcon() {
    return _icon;
  }

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  int _activeButtonIndex = 0;

  void _onListener() {
    setState(() {});
  }

  @override
  void initState() {
    widget.windows.addListener(_onListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.windows.removeListener(_onListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var windows = widget.windows.getList();

    return SizedBox(
      width: MediaQuery.of(context).size.width - SideBar.size,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          () {
            if(windows.length < 2) return Container();

            return Positioned(
              left: 0,
              child: SecondarySideBar(
                name: widget.getName(),
                windows: windows,
                activeButtonIndex: _activeButtonIndex,
                onButtonTapped: (index) {
                  setState(() {
                    _activeButtonIndex = index;
                  });
                },
              ),
            );
          }(),
          () {
            if(windows.isEmpty) return Container();
            return windows[_activeButtonIndex].widget;
          }()
        ],
      )
    );
  }
}