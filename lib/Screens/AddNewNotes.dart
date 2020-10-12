import 'dart:io';

import 'package:Not3s/Colors/Colors.dart';
import 'package:Not3s/Data/Provider.dart';
import 'package:Not3s/Data/SharedPreferencesClass.dart';
import 'package:after_layout/after_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

class AddNewNotes extends StatefulWidget {
  @override
  _AddNewNotesState createState() => _AddNewNotesState();
}

class _AddNewNotesState extends State<AddNewNotes> with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  bool isEditing;
  FocusNode _focusNode1;
  FocusNode _focusNode2;
  bool canTap;
  List a;
  bool showing = false;
  String notesFromUser;
  String titleOfNotesFromUser;
  String dateOfNoteCreated;
  String imagePath;
  String hasAlarm;
  bool whichTextField;
  var bytes;

  submit() async {}

  @override
  void initState() {
    isEditing = false;
    hasAlarm = 'false';
    _scrollController = ScrollController();
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    canTap = true;

    // ignore: unused_local_variable
    var time = DateTime.now().add(
      Duration(seconds: 2),
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('your other channel id', 'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    // ignore: unused_local_variable
    NotificationDetails notificationDetails = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // flutterLocalNotificationsPlugin.schedule(0, 'To-do', 'Also test', time, notificationDetails)
    //   ..whenComplete(
    //     () {
    //       FlutterAppBadger.updateBadgeCount(2);
    //     },
    //   );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: CupertinoColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: CupertinoColors.white,
        elevation: 0.0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            EvaIcons.closeCircleOutline,
            color: buttonColor,
            size: 22,
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              whichTextField = null;
            });
            if (canTap == true) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
            if (whichTextField != null) {
              await Future.delayed(Duration(milliseconds: 900), () async {
                Navigator.pop(context, 0);
              });
            } else if (whichTextField == null) {
              Navigator.pop(context, 0);
            }
          },
        ),
        actions: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: isEditing
                ? Padding(
                    key: ValueKey(1),
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        EvaIcons.checkmarkCircleOutline,
                        color: buttonColor,
                        size: 22,
                      ),
                      onPressed: () async {
                        setState(() {
                          canTap = true;
                        });
                        if (canTap == true) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                        if (notesFromUser != null && titleOfNotesFromUser != null) {
                          Provider.of<UserData>(context, listen: false).notesFromUser.add(notesFromUser);
                          Provider.of<UserData>(context, listen: false).titleOfNotesFromUser.add(titleOfNotesFromUser);
                          Provider.of<UserData>(context, listen: false).hasAlarm.add(hasAlarm);
                          Provider.of<UserData>(context, listen: false).dateOfNoteCreation.add(
                                DateTime.now().toString().substring(0, 10).replaceAll('-', '. '),
                              );
                          print(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                          print(Provider.of<UserData>(context, listen: false).notesFromUser);
                          // Provider.of<UserData>(context, listen: false).imagePathOfEachNote.add(imagePath);
                          await SharedPreferencesClass().updateFirstRun(false);
                          await SharedPreferencesClass().updateNotesFromUser(Provider.of<UserData>(context, listen: false).notesFromUser);
                          await SharedPreferencesClass().updatetitleOfNotesFromUser(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                          await SharedPreferencesClass().updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                          await SharedPreferencesClass().updateHasAlarm(Provider.of<UserData>(context, listen: false).hasAlarm);
                          // await _updateimagePathOfEachNote(Provider.of<UserData>(context, listen: false).imagePathOfEachNote);
                          setState(() {
                            isEditing = false;
                          });
                        } else {
                          print('yes');
                          showSnackBars();
                        }
                      },
                    ),
                  )
                : Padding(
                    key: ValueKey(2),
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Container(
                      height: 50,
                      width: 44,
                      child: FlareActor(
                        'assets/flare/success.flr',
                        animation: 'Untitled',
                      ),
                    ),
                  ),
          )
        ],
        title: TextFormField(
          onTap: () {
            setState(() {
              whichTextField = false;
              canTap = false;
              isEditing = true;
            });
          },
          autocorrect: true,
          autofocus: false,
          onChanged: (value) {
            setState(
              () {
                titleOfNotesFromUser = value;
              },
            );
          },
          enableInteractiveSelection: true,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_focusNode2);
          },
          enableSuggestions: true,
          cursorColor: CupertinoColors.systemBlue,
          focusNode: _focusNode1,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(fontSize: 17, color: liltextColor),
          textInputAction: TextInputAction.next,
          keyboardAppearance: Brightness.light,
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(fontSize: 17, color: liltextColor.withOpacity(0.8)),
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
      body: FooterLayout(
        footer: KeyboardAttachable(
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE1E8ED),
                    width: 0.7,
                  ),
                ),
              ),
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      EvaIcons.eyeOff2Outline,
                      color: liltextColor.withOpacity(0.6),
                    ),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      EvaIcons.flagOutline,
                      color: liltextColor.withOpacity(0.6),
                    ),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      EvaIcons.micOutline,
                      color: buttonColor,
                    ),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      EvaIcons.clockOutline,
                      color: buttonColor,
                    ),
                    onPressed: () {
                      //OPEN CLOCK..TODO
                      if (hasAlarm == 'false') {
                        setState(() {
                          hasAlarm = 'true';
                        });
                      } else if (hasAlarm == 'true') {
                        setState(() {
                          hasAlarm = 'false';
                        });
                      }
                    },
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      EvaIcons.imageOutline,
                      color: buttonColor,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final File image = await ImagePickerSaver.pickImage(source: ImageSource.gallery);
                      if (image == null) {
                        imagePath = null;
                      } else {
                        Directory path = await getApplicationDocumentsDirectory();
                        final String pathToDeviceFolder = path.path;
                        String uid = Uuid().v4();
                        final File imageToCopy = await image.copy('$pathToDeviceFolder/$uid.png');
                        imagePath = imageToCopy.path;
                        setState(() {
                          bytes = image.readAsBytesSync();
                        });
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      print(bytes);
                      // if (whichTextField == null) {
                      // } else if (whichTextField == false) {
                      //   FocusScope.of(context).requestFocus(_focusNode1);
                      // } else if (whichTextField == true) {
                      //   FocusScope.of(context).requestFocus(_focusNode2);
                      // }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Scrollbar(
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              TextFormField(
                onChanged: (String value) {
                  setState(
                    () {
                      notesFromUser = value;
                    },
                  );
                },
                onTap: () {
                  setState(() {
                    whichTextField = true;
                    canTap = false;
                    isEditing = true;
                  });
                },
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                //autofocus: true,
                maxLength: null,
                maxLines: null,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                cursorColor: CupertinoColors.systemBlue,
                textCapitalization: TextCapitalization.sentences,
                focusNode: _focusNode2,
                style: TextStyle(fontSize: 17, color: liltextColor),
                textInputAction: TextInputAction.done,
                keyboardAppearance: Brightness.light,
                decoration: InputDecoration(
                  hintText: 'To-do',
                  hintStyle: TextStyle(fontSize: 17, color: liltextColor.withOpacity(0.8)),
                  contentPadding: EdgeInsets.only(left: 50, top: 1, right: 15, bottom: 0.0),
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
              // Image.memory(bytes),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 15, top: 0.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(child: child, opacity: animation);
                  },
                  child: bytes == null
                      ? SizedBox()
                      : ClipRRect(
                          key: ValueKey(bytes),
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            bytes,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBars() {
    final snackBarContent = SnackBar(
      content: Text("sagar"),
      // action: SnackBarAction(label: 'UNDO', onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}
