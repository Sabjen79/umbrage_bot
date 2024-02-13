import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';

class ConversationSettingsWindow extends MainWindow {
  const ConversationSettingsWindow({super.key}) : super(
    route: "conversation",
    name: "Conversation",
    sideBarIcon: Symbols.quick_phrases
  );


  @override
  State<ConversationSettingsWindow> createState() => _ConversationSettingsWindowState();
}

class _ConversationSettingsWindowState extends State<ConversationSettingsWindow> with SettingsRow {
  final BotConfiguration config = Bot().config;
  late double _typingSpeed;
  late double _reactionSpeedMin;
  late double _reactionSpeedMax;


  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _typingSpeed = config.typingSpeed.toDouble();
    _reactionSpeedMin = config.reactionSpeedMin.toDouble() / 1000;
    _reactionSpeedMax = config.reactionSpeedMax.toDouble() / 1000;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config.typingSpeed = _typingSpeed.toInt();
      config.reactionSpeedMin = (_reactionSpeedMin * 1000).toInt();
      config.reactionSpeedMax = (_reactionSpeedMax * 1000).toInt();

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: [
        titleRow("Conversation", false),

        ...settingsRow(
          first: true,
          name: "Typing Speed",
          description: "The CPS (characters per second) that the bot will simulate when writing messages from the lexicon",
          child: Slider(
            divisions: 12,
            min: 20,
            max: 80,
            label: _typingSpeed.toInt().toString(),
            value: _typingSpeed,
            onChanged: (v) {
              setState(() {
                _typingSpeed = v;
              });

              _showSaveChanges();
            }
          )
        ),
        ...settingsRow(
          name: "Event Reaction Time",
          description: "The time it will take the bot to respond to a message. The final value is random within the range",
          child: RangeSlider(
            divisions: 25,
            min: 0,
            max: 5,
            labels: RangeLabels(
              "${_reactionSpeedMin.toStringAsFixed(1)} seconds", 
              "${_reactionSpeedMax.toStringAsFixed(1)} seconds"
            ),
            values: RangeValues(_reactionSpeedMin, _reactionSpeedMax), 
            onChanged: (v) {
              setState(() {
                _reactionSpeedMin = v.start;
                _reactionSpeedMax = v.end;
              });

              _showSaveChanges();
            }
          )
        )
      ],
    );
  }
}