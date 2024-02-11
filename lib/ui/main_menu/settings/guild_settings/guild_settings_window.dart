import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_guild_configuration.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';

class GuildSettingsWindow extends MainWindow {
  final Guild guild;

  GuildSettingsWindow(this.guild, {super.key}) : super(
    route: guild.id.toString(),
    name: guild.name,
    sideBarIcon: Symbols.groups,
    category: "GUILDS"
  );
  
  @override
  State<GuildSettingsWindow> createState() => _GuildSettingsWindowState();
}

class _MusicChannel {
  final String name;
  final int id;

  _MusicChannel(this.name, this.id);
}

class _GuildSettingsWindowState extends State<GuildSettingsWindow> with SettingsRow {
  late final BotGuildConfiguration config;
  final List<_MusicChannel> _musicChannels = [];
  late _MusicChannel? _musicChannel;
  late bool _restrictMusicChannel;
  late TextEditingController _restrictMusicChannelTextController;

  @override
  void initState() {
    super.initState();

    config = Bot().config[widget.guild.id];

    reset();
  }

  void reset() {
    _musicChannels..clear()..add(_MusicChannel("No Music Channel", 0));
    _musicChannel = null;

    widget.guild.fetchChannels().then((v) {
      for(var channel in v) {
        if(channel is TextChannel && channel is! VoiceChannel) {
          var mc = _MusicChannel(channel.name, channel.id.value);
          _musicChannels.add(mc);
          if(config.musicChannelId == mc.id) _musicChannel = mc;
        }
      }

      _musicChannel ??= _musicChannels[0];

      setState(() {});
    });

    _restrictMusicChannel = config.restrictMusicChannel;
    _restrictMusicChannelTextController = TextEditingController(text: config.restrictMusicChannelMessage);
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config.musicChannelId = _musicChannel!.id;
      config.restrictMusicChannel = _restrictMusicChannel;
      config.restrictMusicChannelMessage = _restrictMusicChannelTextController.text;

      config.saveToJson();

      MainMenuRouter().unblock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: () {
        var list = <Widget>[];

        list.addAll(
          settingsRow(
            first: true,
            name: "Music Channel",
            description: "The text channel where users can queue music\nIf set to 'No Music Channel', music will be disabled for that guild",
            child: Container(
              width: 200,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: DiscordTheme.black,
                borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButton<_MusicChannel>(
                items: _musicChannels.map<DropdownMenuItem<_MusicChannel>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.name, textAlign: TextAlign.center),
                  );
                }).toList(),
                value: _musicChannel,
                underline: Container(),
                dropdownColor: DiscordTheme.black,
                isExpanded: true,
                onChanged: (v) {
                  if(v != _musicChannel) _showSaveChanges();

                  setState(() {
                    if(v != null) _musicChannel = v;
                  });
                },
              ),
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Restrict Music Channel",
            description: "If enabled, users can't write messages in the music channel, they can only queue music commands",
            child: SimpleSwitch(
              size: 45,
              value: _restrictMusicChannel,
              onChanged: (b) {
                setState(() {
                  _restrictMusicChannel = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        if(_restrictMusicChannel) {
          list.addAll(
            settingsRow(
              name: "Restrict Music Channel Message",
              description: "The message that the bot will send when a user tries to write in a music channel",
              child: TextField(
                controller: _restrictMusicChannelTextController,
                onChanged: (v) {
                  _showSaveChanges();
                },
              )
            )
          );
        }

        return list;
      }(),
    );
  }
}

