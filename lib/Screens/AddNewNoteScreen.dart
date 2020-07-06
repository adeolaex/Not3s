import 'package:Not3s/UnderTheHood/Colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Not3s/UnderTheHood/text_field.dart' as customTextField;

class AddNewNote extends StatefulWidget {
  @override
  _AddNewNoteState createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  ScrollController _scrollController;
  bool viewing;
  FocusNode _focusNode1;
  FocusNode _focusNode2;
  bool canTap;
  @override
  void initState() {
    viewing = false;
    _scrollController = ScrollController();
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    canTap = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          canTap = true;
        });
        if (canTap == true) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: Scaffold(
        backgroundColor: CupertinoColors.white,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: CupertinoColors.white,
          elevation: 0.0,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              EvaIcons.arrowIosBackOutline,
              color: secondaryColor,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                EvaIcons.attachOutline,
                color: secondaryColor,
              ),
              onPressed: () {},
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 800),
              child: viewing == false
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        EvaIcons.doneAllOutline,
                        color: secondaryColor,
                      ),
                      onPressed: () async {},
                    )
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        EvaIcons.doneAllOutline,
                        color: CupertinoColors.white,
                      ),
                      onPressed: () => null,
                    ),
            )
          ],
          title: Hero(
            tag: 'her0',
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Not',
                    style: TextStyle(color: liltextColor, fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '3s',
                    style: TextStyle(color: liltextColor, fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Scrollbar(
          controller: _scrollController,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 100.0),
                child: customTextField.TextField(
                  onTap: () {
                    setState(() {
                      canTap = false;
                    });
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_focusNode2);
                  },
                  autocorrect: true,
                  autofocus: true,
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  focusNode: _focusNode1,
                  style: TextStyle(fontSize: 16, color: liltextColor),
                  textInputAction: customTextField.TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 16, color: liltextColor),
                    contentPadding: EdgeInsets.only(left: 1, top: 1),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.4),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.4),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.4),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              customTextField.TextField(
                onTap: () {
                  setState(() {
                    canTap = false;
                  });
                },
                autocorrect: true,
                autofocus: true,
                maxLength: 300,
                maxLines: 5,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                focusNode: _focusNode2,
                style: TextStyle(fontSize: 16, color: textColor),
                textInputAction: customTextField.TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '',
                  labelStyle: TextStyle(fontSize: 13, color: textColor),
                  contentPadding: EdgeInsets.only(left: 30, top: 1, right: 30),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.3),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.3),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.3),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
