import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_guild_configuration.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/windows/settings/settings_row.dart';

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

class _Channel {
  final String name;
  final int id;

  _Channel(this.name, this.id);
}

class _GuildSettingsWindowState extends State<GuildSettingsWindow> with SettingsRow {
  late final BotGuildConfiguration config;
  final List<_Channel> _textChannels = [];
  late _Channel? _mainTextChannel;

  final List<_Channel> _musicChannels = [];
  late _Channel? _musicChannel;

  final List<_Channel> _voiceChannels = [];
  late _Channel? _voiceChannel;

  @override
  void initState() {
    super.initState();

    config = Bot().config[widget.guild.id];

    reset();
  }

  @override
  void didUpdateWidget(covariant GuildSettingsWindow oldWidget) {
    super.didUpdateWidget(oldWidget);

    reset();
  }

  void reset() {
    _musicChannels..clear()..add(_Channel("No Music Channel", 0));
    _musicChannel = null;

    _textChannels.clear();
    _mainTextChannel = null;

    _voiceChannels.clear();
    _voiceChannel = null;

    widget.guild.fetchChannels().then((v) {
      for(var channel in v) {
        var mc = _Channel(channel.name, channel.id.value);
        if(channel is TextChannel && channel is! VoiceChannel) {

          _musicChannels.add(mc);
          if(config.musicChannelId == mc.id) _musicChannel = mc;

          _textChannels.add(mc);
          if(config.mainMessageChannelId == mc.id) _mainTextChannel = mc;
        }
        if(channel is VoiceChannel) {
          _voiceChannels.add(mc);
          if(config.defaultVoiceChannelId == mc.id) _voiceChannel = mc;
        }
      }

      _musicChannel ??= _musicChannels.firstOrNull;
      _mainTextChannel ??= _textChannels.firstOrNull;
      _voiceChannel ??= _voiceChannels.firstOrNull;

      if(mounted) {
        setState(() {});
      }
    });
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config
        ..mainMessageChannelId = _mainTextChannel!.id
        ..musicChannelId = _musicChannel!.id
        ..defaultVoiceChannelId = _voiceChannel!.id;

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

        list.add(titleRow("Channels", false));

        list.addAll(
          settingsRow(
            first: true,
            name: "Main Text Channel",
            description: "The text channel where the bot will send messages when it doesn't have a text channel to respond to. For example, in Lexicon's Voice Join Event",
            child: Container(
              width: 200,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: DiscordTheme.black,
                borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButton<_Channel>(
                items: _textChannels.map<DropdownMenuItem<_Channel>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.name, textAlign: TextAlign.center),
                  );
                }).toList(),
                value: _mainTextChannel,
                underline: Container(),
                dropdownColor: DiscordTheme.black,
                isExpanded: true,
                onChanged: (v) {
                  if(v != _mainTextChannel) _showSaveChanges();

                  setState(() {
                    if(v != null) _mainTextChannel = v;
                  });
                },
              ),
            )
          )
        );

        list.addAll(
          settingsRow(
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
              child: DropdownButton<_Channel>(
                items: _musicChannels.map<DropdownMenuItem<_Channel>>((item) {
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
            name: "Default Voice Channel",
            description: "The voice channel that the bot will first connect to if 'Solitude in Voice Channels' is enabled",
            child: Container(
              width: 200,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: DiscordTheme.black,
                borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButton<_Channel>(
                items: _voiceChannels.map<DropdownMenuItem<_Channel>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.name, textAlign: TextAlign.center),
                  );
                }).toList(),
                value: _voiceChannel,
                underline: Container(),
                dropdownColor: DiscordTheme.black,
                isExpanded: true,
                onChanged: (v) {
                  if(v != _voiceChannel) _showSaveChanges();

                  setState(() {
                    if(v != null) _voiceChannel = v;
                  });
                },
              ),
            )
          )
        );

        return list;
      }(),
    );
  }
}

