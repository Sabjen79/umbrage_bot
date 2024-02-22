import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/configuration/bot_configuration.dart';
import 'package:umbrage_bot/ui/components/simple_chance_field.dart';
import 'package:umbrage_bot/ui/components/simple_switch.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';
import 'package:umbrage_bot/ui/main_menu/settings/settings_row.dart';

class MusicSettingsWindow extends MainWindow {
  const MusicSettingsWindow({super.key}) : super(
    route: "music",
    name: "Music & Voice",
    sideBarIcon: Symbols.music_note
  );


  @override
  State<MusicSettingsWindow> createState() => _MusicSettingsWindowState();
}

class _MusicSettingsWindowState extends State<MusicSettingsWindow> with SettingsRow {
  final BotConfiguration config = Bot().config;
  late TextEditingController _ytApiKeyController;
  late TextEditingController _ytNotFoundMessageController;
  late bool _restrictMusicChannel;
  late TextEditingController _restrictMusicChannelTextController;
  late bool _autoConnectVoice;
  late bool _autoConnectVoicePersist;
  late TextEditingController _invalidMusicCommandChannelMessageController;
  late TextEditingController _errorLoadingTrackMessageController;
  late TextEditingController _duplicateTrackMessageController;
  late TextEditingController _emptyQueueMessageController;
  late TextEditingController _noVoiceChannelMessageController;
  late TextEditingController _noLoopMessageController;
  late TextEditingController _noClearMessageController;
  late TextEditingController _clearMessageController;
  late TextEditingController _clearPartialMessageController;
  late bool _unskippableSongs;
  late double _userUnskippableChance;
  late double _botUnskippableChance;
  late TextEditingController _unskippableMessageController;
  late int _unskippableMinDuration;
  late int _unskippableMaxDuration;
  late bool _unskippableClearImmunity;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    _ytApiKeyController = TextEditingController(text: config.ytApiKey);
    _ytNotFoundMessageController = TextEditingController(text: config.ytNotFoundMessage);
    _restrictMusicChannel = config.restrictMusicChannel;
    _restrictMusicChannelTextController = TextEditingController(text: config.restrictMusicChannelMessage);
    _autoConnectVoice = config.autoConnectVoice;
    _autoConnectVoicePersist = config.autoConnectVoicePersist;
    _invalidMusicCommandChannelMessageController = TextEditingController(text: config.invalidMusicCommandChannelMessage);
    _errorLoadingTrackMessageController = TextEditingController(text: config.errorLoadingTrackMessage);
    _duplicateTrackMessageController = TextEditingController(text: config.duplicateTrackMessage);
    _emptyQueueMessageController = TextEditingController(text: config.emptyQueueMessage);
    _noVoiceChannelMessageController = TextEditingController(text: config.noVoiceChannelMessage);
    _noLoopMessageController = TextEditingController(text: config.noLoopMessage);
    _noClearMessageController = TextEditingController(text: config.noClearMessage);
    _clearMessageController = TextEditingController(text: config.clearMessage);
    _clearPartialMessageController = TextEditingController(text: config.clearPartialMessage);
    _unskippableSongs = config.unskippableSongs;
    _userUnskippableChance = config.userUnskippableChance;
    _botUnskippableChance = config.botUnskippableChance;
    _unskippableMessageController = TextEditingController(text: config.unskippableMessage);
    _unskippableMinDuration = config.unskippableMinDuration;
    _unskippableMaxDuration = config.unskippableMaxDuration;
    _unskippableClearImmunity = config.unskippableClearImmunity;
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      setState(() {
        reset();
      });

      MainMenuRouter().unblock();
    }, () async {
      config
        ..ytApiKey = _ytApiKeyController.text
        ..ytNotFoundMessage = _ytNotFoundMessageController.text
        ..restrictMusicChannel = _restrictMusicChannel
        ..restrictMusicChannelMessage = _restrictMusicChannelTextController.text
        ..autoConnectVoice = _autoConnectVoice
        ..autoConnectVoicePersist = _autoConnectVoicePersist
        ..invalidMusicCommandChannelMessage = _invalidMusicCommandChannelMessageController.text
        ..errorLoadingTrackMessage = _errorLoadingTrackMessageController.text
        ..duplicateTrackMessage = _duplicateTrackMessageController.text
        ..emptyQueueMessage = _emptyQueueMessageController.text
        ..noLoopMessage = _noLoopMessageController.text
        ..noClearMessage = _noClearMessageController.text
        ..clearMessage = _clearMessageController.text
        ..clearPartialMessage = _clearPartialMessageController.text
        ..noVoiceChannelMessage = _noVoiceChannelMessageController.text
        ..unskippableSongs = _unskippableSongs
        ..userUnskippableChance = _userUnskippableChance
        ..botUnskippableChance = _botUnskippableChance
        ..unskippableMessage = _unskippableMessageController.text
        ..unskippableMinDuration = _unskippableMinDuration
        ..unskippableMaxDuration = _unskippableMaxDuration
        ..unskippableClearImmunity = _unskippableClearImmunity;

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

        // YOUTUBE
        list.add(titleRow("Youtube Search", false));

        list.addAll(
          settingsRow(
            first: true,
            name: "Youtube API Key",
            description: "Your youtube api key to enable the play command to search for songs on yt.\nDirect links will work otherwise. Leave empty to disable the feature",
            child: TextField(
              controller: _ytApiKeyController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Youtube Search Not Found Message",
            description: "The message that the bot will send when it cannot find a youtube video",
            child: TextField(
              controller: _ytNotFoundMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        // AUTO-CONNECT
        list.add(titleRow("Auto-Connect"));

        list.addAll(
          settingsRow(
            first: true,
            name: "Auto Connect to Voice Channels",
            description: "If enabled, the bot will automatically join or leave voice channels as he pleases.",
            child: SimpleSwitch(
              size: 45,
              value: _autoConnectVoice,
              onChanged: (b) {
                setState(() {
                  _autoConnectVoice = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        if(_autoConnectVoice) {
          list.addAll(
            settingsRow(
              name: "Solitude in Voice Channels",
              description: "If enabled, the bot will not leave voice channels when left alone and will mute himself to not talk by his own.",
              child: SimpleSwitch(
                size: 45,
                value: _autoConnectVoicePersist,
                onChanged: (b) {
                  setState(() {
                    _autoConnectVoicePersist = b;
                  });

                  _showSaveChanges();
                }
              )
            )
          );
        }

        // UNSKIPPABLE SONGS
        list.add(titleRow("Unskippable Songs"));

        list.addAll(
          settingsRow(
            first: true,
            name: "Unskippable Songs",
            description: "If enabled, some queued songs will be unskippable by any user (except the bot, of course)",
            child: SimpleSwitch(
              size: 45,
              value: _unskippableSongs,
              onChanged: (b) {
                setState(() {
                  _unskippableSongs = b;
                });

                _showSaveChanges();
              }
            )
          )
        );

        if(_unskippableSongs) {
          list.addAll(
            settingsRow(
              name: "User Unskippable Chance",
              description: "The chance that a song queued by an user will be unskippable",
              child: SimpleChanceField(
                chance: _userUnskippableChance,
                onChanged: (v) {
                  setState(() {
                    _userUnskippableChance = v;
                  });

                  _showSaveChanges();
                }
              )
            )
          );

          list.addAll(
            settingsRow(
              name: "Bot Unskippable Chance",
              description: "The chance that a song queued by the bot will be unskippable",
              child: SimpleChanceField(
                chance: _botUnskippableChance,
                onChanged: (v) {
                  setState(() {
                    _botUnskippableChance = v;
                  });

                  _showSaveChanges();
                }
              )
            )
          );

          list.addAll(
            settingsRow(
              name: "Max Unskippable Duration",
              description: "If a song has been playing for too long, the bot will secretly remove its unskippable behaviour after a random set time.",
              child: RangeSlider(
                divisions: 60,
                min: 0,
                max: 3600000,
                labels: RangeLabels(
                  "${(_unskippableMinDuration/60000).toStringAsFixed(0)} minutes", 
                  "${(_unskippableMaxDuration/60000).toStringAsFixed(0)} minutes"
                ),
                values: RangeValues(_unskippableMinDuration.toDouble(), _unskippableMaxDuration.toDouble()),
                onChanged: (v) {
                  setState(() {
                    _unskippableMinDuration = v.start.toInt();
                    _unskippableMaxDuration = v.end.toInt();
                  });

                  _showSaveChanges();
                }
              )
            )
          );

          list.addAll(
            settingsRow(
              name: "Unskippable Message",
              description: "The message that the bot will send when a user fails to skip a song.",
              child: TextField(
                controller: _unskippableMessageController,
                onChanged: (v) {
                  _showSaveChanges();
                },
              )
            )
          );

          list.addAll(
            settingsRow(
              name: "Unskippable Songs Clear Immunity",
              description: "If enabled, unskippable songs will not be cleared by the clear command.",
              child: SimpleSwitch(
                size: 45,
                value: _unskippableClearImmunity,
                onChanged: (b) {
                  setState(() {
                    _unskippableClearImmunity = b;
                  });

                  _showSaveChanges();
                }
              )
            )
          );
        }

        // MUSIC TEXT CHANNEL
        list.add(titleRow("Music Text Channel"));

        list.addAll(
          settingsRow(
            first: true,
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

        list.addAll(
          settingsRow(
            name: "Invalid Music Command Channel Message",
            description: "The message that the bot will send when a user tries to queue a music command in a non-music channel.\nThe string '\$channel\$' is replaced by the mention of the music channel.",
            child: TextField(
              controller: _invalidMusicCommandChannelMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Error Loading Track Message",
            description: "The message that the bot will send when a track that a user queued is invalid.",
            child: TextField(
              controller: _errorLoadingTrackMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Duplicate Track Error Message",
            description: "The message that the bot will send when a user fails to queue a song because it is already in the queue.",
            child: TextField(
              controller: _duplicateTrackMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Empty Queue Skip Message",
            description: "The message that the bot will send when a user fails to skip a song because the queue is empty.",
            child: TextField(
              controller: _emptyQueueMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "No Loop Channel Message",
            description: "The message that the bot will send when a user tries to loop music while the queue is empty",
            child: TextField(
              controller: _noLoopMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "No Clear Channel Message",
            description: "The message that the bot will send when a user tries to clear the music queue while it is empty.",
            child: TextField(
              controller: _noClearMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Clear Messsage",
            description: "The message that the bot will send when a user clears the queue. '\$' will be replaced with the user's name.",
            child: TextField(
              controller: _clearMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "Partial Clear Message",
            description: "Same as above, but when the queue is not fully cleared",
            child: TextField(
              controller: _clearPartialMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        list.addAll(
          settingsRow(
            name: "No Voice Channel Message",
            description: "The message that the bot will send when a user tries to queue a music command while not in a voice channel.",
            child: TextField(
              controller: _noVoiceChannelMessageController,
              onChanged: (v) {
                _showSaveChanges();
              },
            )
          )
        );

        return list;
      }(),
    );
  }
}