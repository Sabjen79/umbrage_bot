import 'package:flutter/material.dart';
import 'package:umbrage_bot/bot/profile/bot_profile.dart';
import 'package:umbrage_bot/bot/profile/bot_profile_list.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';

class AddProfile extends StatefulWidget {
  final Function(BotProfile) _addProfileFunction;

  const AddProfile(this._addProfileFunction, {super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  late TextEditingController _textController;
  bool _disableAdding = true;
  String? _tokenError;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {
        _disableAdding = (_textController.text.characters.length <= 60);
        _tokenError = null;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitToken() async {
    var result = await BotProfileList().createProfile(_textController.text);

    if(!result.isSuccess) {
      setState(() {
        _disableAdding = false;
        _tokenError = result.error;
      });
      return;
    }

    await widget._addProfileFunction(result.value!);

    setState(() {
      _disableAdding = false;
    });

    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDiscordDialog(
      submitText: "Add Bot",
      disableSubmit: _disableAdding,
      enableLoadingAnimation: true,
      onSubmit: _submitToken,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: SizedBox(
              width: 250,
              child: Text(
                "Go to Discord Developer Portal and create a new Application. In the 'Bot' panel, copy your bot token and insert it below.",
                textAlign: TextAlign.center,
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
              width: 250,
              child: TextField(
                controller: _textController,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: "Bot Token",
                  errorText: _tokenError
                ),
              )
            )
          ),
        ],
      )
    );
  }
}