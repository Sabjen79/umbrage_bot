import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/ui/components/simple_discord_dialog.dart';
import 'package:umbrage_bot/ui/discord_theme.dart';
import 'package:umbrage_bot/ui/main_menu/lexicon/lexicon_variable_window_field.dart';
import 'package:umbrage_bot/ui/main_menu/main_menu.dart';
import 'package:umbrage_bot/ui/main_menu/main_window.dart';
import 'package:umbrage_bot/ui/main_menu/router/main_menu_router.dart';

class LexiconVariableWindow extends MainWindow {
  final LexiconCustomVariable? variable;

  LexiconVariableWindow(this.variable, {super.key}) : super(
    sideBarIcon: variable == null ? Symbols.add_circle : Symbols.tag, 
    route: variable == null ? "add_variable" : variable.keyword,
    name: variable == null ? "Create Variable" : variable.name,
    category: variable == null ? "" : "CUSTOM VARIABLES"
  );

  @override
  State<LexiconVariableWindow> createState() => _LexiconVariableWindowState();
}

class _LexiconVariableWindowState extends State<LexiconVariableWindow> {
  late String _name;
  late String _description;
  late String _keyword;
  late int _color;
  late List<String> _words;

  final List<int> _colorList = [
    0xFF95a5a6,
    0xFF1abc9c,
    0xFF2ecc71,
    0xFF3498db,
    0xFF9b59b6,
    0xFFe91e63,
    0xFFf1c40f,
    0xFFe67e22,
    0xFFe74c3c,
  ];
  int _selectedColor = -1;

  void init() {
    var variable = widget.variable;

    if(variable == null) { // Create Page
      _name = "";
      _description = "";
      _color = 0xFF95a5a6;
      _keyword = "";
      _words = [];
    } else { // Update Page
      _name = variable.name;
      _description = variable.description;
      _color = variable.color;
      _keyword = variable.keyword;
      _words = variable.words;
    }

    _selectedColor = -1;
    for(int i = 0; i < _colorList.length; i++) {
      if(_colorList[i] == _color) _selectedColor = i;
    }
  }

  void _showSaveChanges() {
    MainMenuRouter().block(() async {
      init();

      setState(() {});

      MainMenuRouter().unblock();
    }, () async {
      var lexicon = Bot().lexicon;
      var result = widget.variable == null ?
       lexicon.createCustomVariable(_keyword, _name, _description, _color, _words) :
       lexicon.updateCustomVariable(widget.variable!, _keyword, _name, _description, _color, _words);

      if(!result.isSuccess) {
        showDialog(
          context: context, 
          builder: (context) => SimpleDiscordDialog(
            cancelText: "",
            submitText: "OKAY, SORRY!",
            onSubmit: () async => {
              Navigator.pop(context, false)
            },
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              width: 300,
              child: Text(
                "ERROR: ${result.error}",
                textAlign: TextAlign.center,
              )
            ),
          )
        );
        return;
      }

      MainMenuRouter().unblock();
      MainMenuRouter().subRouteTo(_keyword);
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void didUpdateWidget(covariant LexiconVariableWindow oldWidget) {
    super.didUpdateWidget(oldWidget);

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top colored bar
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Color(_color),
            boxShadow: const [
              BoxShadow(
                color: Color(0x77000000),
                blurRadius: 10,
                spreadRadius: 2
              )
            ]
          ),
        ),

        // Color Selector
        Positioned(
          top: 20,
          left: 20,
          child: Row(
            children: () {
              var list = <Widget>[];

              for(int i = 0; i < _colorList.length; i++) {
                list.add(
                  InkWell(
                    onTap: () {
                      if(_selectedColor == i) return;

                      setState(() { 
                        _selectedColor = i;
                        _color = _colorList[i];
                      });

                      _showSaveChanges();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        boxShadow: const [BoxShadow(color: Color(0x33000000),blurRadius: 10, spreadRadius: 3)],
                        color: Color(_colorList[i]),
                        borderRadius: const BorderRadius.all(Radius.circular(3))
                      ),
                      child: i != _selectedColor ? null : const Center(
                        child: Icon(
                          Symbols.check,
                          color: Colors.black,
                          size: 15,
                        ),
                      )
                    ),
                  )
                );
              }

              return list;
            }()
          ),
        ),

        // Delete Button
        () {
          return widget.variable == null ? const SizedBox() : Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (context) => SimpleDiscordDialog(
                    cancelText: "No!",
                    submitText: "Yea, delete it",
                    onCancel: () async => Navigator.pop(context, false),
                    onSubmit: () async {
                      Bot().lexicon.deleteCustomVariable(widget.variable!);

                      MainMenuRouter().subRouteTo("add_variable");

                      Navigator.pop(context, false);
                    },
                    content: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      width: 300,
                      child: const Text(
                        "Are you sure you want to delete this custom variable? You will permanently lose it!",
                        textAlign: TextAlign.center,
                      )
                    ),
                  )
                );
              },
              child: const Icon(
                Symbols.delete,
                shadows: [
                  Shadow(
                    color: Color(0xFF000000),
                    blurRadius: 7
                  )
                ],
                size: 30,
                color: Colors.red,
              ),
            ),
          );
        }(),

        Container(
          padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              // Name input
              SizedBox(
                width: MainMenu.getMainWindowWidth(context),
                child: LexiconVariableWindowField(
                  onChanged: (value) {
                    _name = value;

                    _showSaveChanges();
                  },
                  initialText: _name,
                  maxLength: 30,
                  fontSize: 28,
                  color: DiscordTheme.white,
                  hintText: "Untitled",
                  hasShadow: true,
                )
              ),

              // Description input
              Container(
                margin: const EdgeInsets.only(top: 15),
                width: MainMenu.getMainWindowWidth(context),
                child: LexiconVariableWindowField(
                  onChanged: (value) {
                    _description = value;

                    _showSaveChanges();
                  },
                  initialText: _description,
                  maxLength: 70,
                  fontSize: 14,
                  color: DiscordTheme.lightGray,
                  hintText: "Description",
                )
              ),

              // Keyword input
              SizedBox(
                width: MainMenu.getMainWindowWidth(context),
                child: LexiconVariableWindowField(
                  onChanged: (value) {
                    _keyword = value;

                    _showSaveChanges();
                  },
                  initialText: _keyword,
                  maxLength: 15,
                  fontSize: 12,
                  color: Color(_color),
                  hintText: "keyword ",
                  isKeyword: true,
                ),
              )
            ]
          )
        ),
      ],
    );
  }
}