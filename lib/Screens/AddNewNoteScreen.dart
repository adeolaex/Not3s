import 'dart:io';

import 'package:Not3s/UnderTheHood/Colors.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Not3s/UnderTheHood/text_field.dart' as customTextField;
import 'package:uuid/uuid.dart';

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
  bool showing = false;
  String notesFromUser;
  String titleOfNotesFromUser;
  String dateOfNoteCreated;
  String imagePath;
  bool isEditing;
  _updateNotesFromUser(List<String> notesFromUseR) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('notesFromUser', notesFromUseR);
  }

  _updatetitleOfNotesFromUser(List<String> titleOfNotesFromUseR) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('titleOfNotesFromUser', titleOfNotesFromUseR);
  }

  _updatedateOfNoteCreation(List<String> dateOfNoteCreation) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('dateOfNoteCreation', dateOfNoteCreation);
  }

  updateimagePathOfEachNote(List<String> imagePathOfEachNote) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('imagePathOfEachNote', imagePathOfEachNote);
  }

  submit() async {}
  removeFlushbar(Flushbar flushbar) {
    flushbar.dismiss();
  }

  @override
  void initState() {
    isEditing = true;
    _scrollController = ScrollController();
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    canTap = true;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var andriod = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    InitializationSettings initializationSettings =
        InitializationSettings(andriod, ios);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    var time = DateTime.now().add(
      Duration(seconds: 2),
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // flutterLocalNotificationsPlugin.schedule(
    //     0, 'To-do', 'Also test', time, notificationDetails);

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
              EvaIcons.arrowIosDownwardOutline,
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
              onPressed: () async {
                final File image = await ImagePickerSaver.pickImage(
                    source: ImageSource.gallery);
                if (image == null) {
                  imagePath = null;
                } else {
                  Directory path = await getApplicationDocumentsDirectory();
                  final String pathToDeviceFolder = path.path;
                  String uid = Uuid().v4();
                  final File imageToCopy =
                      await image.copy('$pathToDeviceFolder/$uid.png');
                  imagePath = imageToCopy.path;
                }
              },
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: isEditing
                  ? Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            EvaIcons.doneAllOutline,
                            color: secondaryColor,
                          ),
                          onPressed: () async {
                            setState(() {
                              canTap = true;
                            });
                            if (canTap == true) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                            if (notesFromUser != null &&
                                titleOfNotesFromUser != null) {
                              Provider.of<UserData>(context, listen: false)
                                  .notesFromUser
                                  .add(notesFromUser);
                              Provider.of<UserData>(context, listen: false)
                                  .titleOfNotesFromUser
                                  .add(titleOfNotesFromUser);
                              Provider.of<UserData>(context, listen: false)
                                  .dateOfNoteCreation
                                  .add(
                                    DateTime.now()
                                        .toString()
                                        .substring(0, 10)
                                        .replaceAll('-', '. '),
                                  );
                              print(
                                  Provider.of<UserData>(context, listen: false)
                                      .titleOfNotesFromUser);
                              print(
                                  Provider.of<UserData>(context, listen: false)
                                      .notesFromUser);
                              // Provider.of<UserData>(context, listen: false).imagePathOfEachNote.add(imagePath);
                              await _updateNotesFromUser(
                                  Provider.of<UserData>(context, listen: false)
                                      .notesFromUser);
                              await _updatetitleOfNotesFromUser(
                                  Provider.of<UserData>(context, listen: false)
                                      .titleOfNotesFromUser);
                              await _updatedateOfNoteCreation(
                                  Provider.of<UserData>(context, listen: false)
                                      .dateOfNoteCreation);
                              // await _updateimagePathOfEachNote(Provider.of<UserData>(context, listen: false).imagePathOfEachNote);
                              setState(() {
                                isEditing = false;
                              });
                            } else {
                              Flushbar _flushBar = Flushbar(
                                margin: EdgeInsets.all(1),
                                borderRadius: 4,
                                isDismissible: true,
                                onTap: (flushbar) {
                                  removeFlushbar(flushbar);
                                },
                                flushbarPosition: FlushbarPosition.TOP,
                                message: "A title and to-do is required.",
                                maxWidth: 250.0,
                                duration: Duration(seconds: 3),
                              );
                              _flushBar
                                ..onStatusChanged = (FlushbarStatus status) {
                                  switch (status) {
                                    case FlushbarStatus.SHOWING:
                                      {
                                        setState(() {
                                          showing = true;
                                        });

                                        break;
                                      }
                                    case FlushbarStatus.IS_APPEARING:
                                      {
                                        setState(() {
                                          showing = true;
                                        });

                                        break;
                                      }
                                    case FlushbarStatus.IS_HIDING:
                                      {
                                        setState(() {
                                          showing = false;
                                        });
                                        break;
                                      }
                                    case FlushbarStatus.DISMISSED:
                                      {
                                        setState(() {
                                          showing = false;
                                        });
                                        break;
                                      }
                                  }
                                };
                              if (showing == false) {
                                _flushBar..show(context);
                              }
                            }
                          },
                        ),
                      ],
                    )
                  : Container(
                      height: 50,
                      width: 44,
                      child: FlareActor(
                        'assets/flare/success.flr',
                        animation: 'Untitled',
                      ),
                    ),
            )
          ],
          title: Hero(
            tag: 'title',
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Not3s ',
                    style: TextStyle(
                        color: liltextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
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
                      isEditing = true;
                    });
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_focusNode2);
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
                  enableSuggestions: true,
                  focusNode: _focusNode1,
                  textCapitalization:
                      customTextField.TextCapitalization.sentences,
                  style: TextStyle(fontSize: 16, color: textColor),
                  textInputAction: customTextField.TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 13, color: liltextColor),
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
              SizedBox(
                height: 70,
                child: Divider(
                  indent: 70,
                  endIndent: 70,
                  color: liltextColor,
                  thickness: 0.2,
                  height: 0.0,
                ),
              ),
              customTextField.TextField(
                onChanged: (String value) {
                  setState(
                    () {
                      notesFromUser = value;
                    },
                  );
                },
                onTap: () {
                  setState(() {
                    canTap = false;
                    isEditing = true;
                  });
                },
                autocorrect: true,
                //autofocus: true,
                maxLength: 300,
                maxLines: 5,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                textCapitalization:
                    customTextField.TextCapitalization.sentences,
                focusNode: _focusNode2,
                style: TextStyle(fontSize: 16, color: liltextColor),
                textInputAction: customTextField.TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: 'To-do',
                  labelStyle: TextStyle(fontSize: 13, color: liltextColor),
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
