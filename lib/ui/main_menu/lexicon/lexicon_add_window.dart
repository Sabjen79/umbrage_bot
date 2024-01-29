import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/components/lexicon/variables/lexicon_custom_variable.dart';
import 'package:umbrage_bot/ui/components/simple_form_field.dart';
import 'package:umbrage_bot/ui/main_menu/main_sub_window.dart';


// TO-DO: Re-do all of this better!
class LexiconAddWindow extends MainSubWindow {
  LexiconAddWindow({super.key}) : super(name: "Create Variable", sideBarIcon: Symbols.add_circle);

  @override
  State<LexiconAddWindow> createState() => _LexiconAddWindowState();
}

class _LexiconAddWindowState extends State<LexiconAddWindow> {
  FormState? _form;
  String _keyword = "";
  String _name = "";
  String _description = "";

  void _onSubmit() {
    if(!_form!.validate()) return;

    _form!.save();
    
    Bot().lexicon.addCustomVariable(
      LexiconCustomVariable(_keyword, _name, _description, "FFFFFF", [])
    );

    //_form!.reset();
  }

  Widget _buildForm(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent> {
        SingleActivator(LogicalKeyboardKey.enter) : NextFocusIntent()
      },
      child: FocusTraversalGroup(
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          onChanged: () {
            setState(() {
              _form = Form.of(primaryFocus!.context!);
            });
          },
          child: Column(
            children: [
              Center(
                child: SimpleFormField(
                  "Keyword",
                  tooltip: "Every '\$keyword\$' in a phrase will be replaced with a random word from the words list",
                  field: TextFormField(
                    maxLength: 20,
                    cursorWidth: 1,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      counterText: ""
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) return "Keywords cannot be empty";
                      if(RegExp(r'[^1-9A-Za-z_]').hasMatch(value)) return "Keywords can only contain letters and underscores.";

                      for(var c in Bot().lexicon.getCustomVariables()) {
                        if(c.keyword == value) return "There already exists another variable with this keyword.";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      if(value != null) _keyword = value;
                    },
                  )
                )
              ),
              Center(
                child: SimpleFormField(
                  "Name",
                  field: TextFormField(
                    maxLength: 30,
                    cursorWidth: 1,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      counterText: ""
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) return "Name cannot be empty";

                      for(var c in Bot().lexicon.getCustomVariables()) {
                        if(c.name == value) return "There already exists another variable with this keyword.";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      if(value != null) _name = value;
                    },
                  )
                )
              ),
              Center(
                child: SimpleFormField(
                  "Description",
                  field: TextFormField(
                    maxLength: 100,
                    minLines: 3,
                    maxLines: 5,
                    cursorWidth: 1,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      counterText: ""
                    ),
                    onSaved: (value) {
                      if(value != null) _description = value;
                    },
                  )
                )
              ),
              Center(
                child: Container(
                  height: 35,
                  width: 280,
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: (_form == null) ? null : _onSubmit, 
                    child: const Text("Create")
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            _buildForm(context),
          ],
        ),
      ],
    );
  }
}