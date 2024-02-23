import 'package:flutter/material.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/windows/extensions/extension_cooldown_widget.dart';

mixin ExtensionCover {
  Widget extensionCover({
    required String name, 
    required String description, 
    required bool switchValue, 
    required Function(bool) onSwitchChanged, 
    ExtensionCooldownWidget? cooldownWidget,
    double height = 130,
    List<Widget>? children
  }) {
    return Stack(
      children: [
        cooldownWidget == null ? const SizedBox.shrink() : Positioned(
          top: 125,
          left: 30,
          child: Container(
            width: cooldownWidget.canTimerRunEarly ? 190 : 170,
            height: 20,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x77000000),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, 10)
                )
              ]
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: height,
          decoration: const BoxDecoration(
            color: DiscordTheme.darkGray,
            boxShadow: [
              BoxShadow(
                color: Color(0x77000000),
                blurRadius: 10,
                spreadRadius: 2
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Enabled: ",
                      style: TextStyle(
                        color: switchValue ? Colors.green : DiscordTheme.lightGray,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SimpleSwitch(
                      size: 45,
                      value: switchValue,
                      onChanged: onSwitchChanged
                    ),
                  ],
                )
              ),
              
              // Name
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  name,
                  style: const TextStyle(
                    shadows: [
                      Shadow(
                        color: Color(0xCC000000),
                        blurRadius: 3,
                        offset: Offset(0, 1)
                      )
                    ],
                    color: DiscordTheme.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 25),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: DiscordTheme.lightGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 125,
          left: 25,
          child: cooldownWidget ?? const SizedBox.shrink(),
        ),

        Padding(
          padding: EdgeInsets.only(top: cooldownWidget == null ? 130 : 145),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: children ?? [],
          )
        )
      ],
    );
  }
}