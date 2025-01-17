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
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class EditAndViewNotes extends StatefulWidget {
  final int index;
  EditAndViewNotes({this.index});
  @override
  _EditAndViewNotesState createState() => _EditAndViewNotesState();
}

class _EditAndViewNotesState extends State<EditAndViewNotes> with AfterLayoutMixin {
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
  bool whichTextField;

  submit() async {}

  @override
  void initState() {
    isEditing = false;
    _scrollController = ScrollController();
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    canTap = true;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var andriod = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    InitializationSettings initializationSettings = InitializationSettings(andriod, ios);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
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
    titleOfNotesFromUser = Provider.of<UserData>(context, listen: false).titleOfNotesFromUser[widget.index];
    notesFromUser = Provider.of<UserData>(context, listen: false).notesFromUser[widget.index];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: CupertinoColors.white,
        elevation: 0.0,
        leading: Padding(
          padding: EdgeInsets.only(right: 10, bottom: 5.0),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              EvaIcons.closeCircleOutline,
              color: buttonColor,
              size: 23,
            ),
            onPressed: () async {
              setState(() {
                whichTextField = null;
              });
              if (canTap == true) {
                FocusScope.of(context).requestFocus(FocusNode());
              }
              if (whichTextField != null) {
                await Future.delayed(Duration(milliseconds: 900), () async {
                  await Navigator.maybePop(context);
                });
              } else if (whichTextField == null) {
                await Navigator.maybePop(context);
              }
            },
          ),
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
                        size: 23,
                      ),
                      onPressed: () async {
                        setState(() {
                          canTap = true;
                        });
                        if (canTap == true) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                        if (notesFromUser != null && titleOfNotesFromUser != null) {
                          Provider.of<UserData>(context, listen: false).notesFromUser[widget.index] = notesFromUser;
                          Provider.of<UserData>(context, listen: false).titleOfNotesFromUser[widget.index] = titleOfNotesFromUser;
                          Provider.of<UserData>(context, listen: false).dateOfNoteCreation[widget.index] = DateTime.now().toString().substring(0, 10).replaceAll('-', '. ');
                          // Provider.of<UserData>(context, listen: false).imagePathOfEachNote.add(imagePath);
                          await SharedPreferencesClass().updateNotesFromUser(Provider.of<UserData>(context, listen: false).notesFromUser);
                          await SharedPreferencesClass().updatetitleOfNotesFromUser(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                          await SharedPreferencesClass().updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                          setState(
                            () {
                              isEditing = false;
                            },
                          );
                          // await _updateimagePathOfEachNote(Provider.of<UserData>(context, listen: false).imagePathOfEachNote);
                        } else {
                          /**
                         * Need to use the default Snackbar
                         */
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
          initialValue: Provider.of<UserData>(context).titleOfNotesFromUser[widget.index],
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
          style: TextStyle(fontSize: 18, color: liltextColor),
          textInputAction: TextInputAction.next,
          keyboardAppearance: Brightness.light,
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(fontSize: 18, color: liltextColor),
            contentPadding: EdgeInsets.only(left: 1, top: 1, bottom: 5),
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
                    color: liltextColor,
                    width: 0.2,
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
                      color: Color.fromRGBO(170, 184, 194, 1.0),
                    ),
                    onPressed: () {},
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      EvaIcons.flagOutline,
                      color: Color.fromRGBO(170, 184, 194, 1.0),
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
                    onPressed: () {},
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
                      }
                      if (whichTextField == null) {
                      } else if (whichTextField == false) {
                        FocusScope.of(context).requestFocus(_focusNode1);
                      } else if (whichTextField == true) {
                        FocusScope.of(context).requestFocus(_focusNode2);
                      }
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
              SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: Provider.of<UserData>(context).notesFromUser[widget.index],
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
                //autofocus: true,
                maxLength: null,
                maxLines: null,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                cursorColor: CupertinoColors.systemBlue,
                textCapitalization: TextCapitalization.sentences,
                focusNode: _focusNode2,
                style: TextStyle(fontSize: 18, color: liltextColor),
                textInputAction: TextInputAction.newline,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'To-do',
                  hintStyle: TextStyle(fontSize: 18, color: liltextColor.withOpacity(0.7)),
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

  @override
  void afterFirstLayout(BuildContext context) {}
}
