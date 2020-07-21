//The first page rendered to the phone. The main.dart runs functions that returns
//values needed for the Home screen.
//The values are then sent to the Provider classes so that other screens can get the returned values.

//
import 'dart:io';
import 'package:Not3s/Screens/AddNewNoteScreen.dart';
import 'package:Not3s/Screens/Bin.dart';
import 'package:Not3s/Screens/EditAndViewNotes.dart';
import 'package:Not3s/Screens/FlaggedNotes.dart';
import 'package:Not3s/Screens/HiddenNotes.dart';
import 'package:Not3s/UnderTheHood/Colors.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flui/flui.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:uuid/uuid.dart';
import 'package:Not3s/UnderTheHood/text_field.dart' as customTextField;

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  final String title;
  bool shwoing = false;
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  //Various keys are used in order for the animation switcher widget to transitions without errors.
  final GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> key2 = GlobalKey<ScaffoldState>();
  updateDeletePreference(bool value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('emptyAfter30Days', value);
  }

  bool animationComplete = false;
  ScrollController _controller;
  ScrollController _controller2;

  Image myImage;
  bool dummyBool;
  bool isSwitched;
  Color testColor = CupertinoColors.tertiarySystemGroupedBackground;
  Color testColor2 = liltextColor;
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

//This are functions that carry out the task of updating and deleting to-do's in the system(phone's)
//storage
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

  removeFlushbar(Flushbar flushbar) {
    flushbar.dismiss();
  }

  @override
  void initState() {
    isEditing = true;
    _scrollController = ScrollController();
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    // canTap = true;
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
    dummyBool = false;
    _controller = ScrollController();
    _controller2 = ScrollController();
    myImage = Image.asset('assets/images/appIcon.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(myImage.image, context);
    isSwitched = Provider.of<UserData>(context)
        .emptyAfter30Days; //Note to self..... init the state of bool value with after layout
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground,
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: dummyBool
              ? Scaffold(
                  key: key1,
                  floatingActionButton: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.black,
                    child: Icon(
                      EvaIcons.plus,
                      color: Colors.white,
                      size: 27,
                    ),
                    onPressed: () {
                      setState(() {
                        dummyBool = !dummyBool;
                      });
                    },
                  ),
                  backgroundColor: CupertinoColors.white,
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    brightness: Brightness.light,
                    backgroundColor: CupertinoColors.white,
                    elevation: 0.0,
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
                            Directory path =
                                await getApplicationDocumentsDirectory();
                            final String pathToDeviceFolder = path.path;
                            String uid = Uuid().v4();
                            final File imageToCopy = await image
                                .copy('$pathToDeviceFolder/$uid.png');
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
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                      if (notesFromUser != null &&
                                          titleOfNotesFromUser != null) {
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .notesFromUser
                                            .add(notesFromUser);
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .titleOfNotesFromUser
                                            .add(titleOfNotesFromUser);
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .dateOfNoteCreation
                                            .add(
                                              DateTime.now()
                                                  .toString()
                                                  .substring(0, 10)
                                                  .replaceAll('-', '. '),
                                            );
                                        print(Provider.of<UserData>(context,
                                                listen: false)
                                            .titleOfNotesFromUser);
                                        print(Provider.of<UserData>(context,
                                                listen: false)
                                            .notesFromUser);
                                        // Provider.of<UserData>(context, listen: false).imagePathOfEachNote.add(imagePath);
                                        await _updateNotesFromUser(
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .notesFromUser);
                                        await _updatetitleOfNotesFromUser(
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .titleOfNotesFromUser);
                                        await _updatedateOfNoteCreation(
                                            Provider.of<UserData>(context,
                                                    listen: false)
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
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                          message:
                                              "A title and to-do is required.",
                                          maxWidth: 250.0,
                                          duration: Duration(seconds: 3),
                                        );
                                        _flushBar
                                          ..onStatusChanged =
                                              (FlushbarStatus status) {
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
                            textInputAction:
                                customTextField.TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle:
                                  TextStyle(fontSize: 13, color: liltextColor),
                              contentPadding: EdgeInsets.only(left: 1, top: 1),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.4),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.4),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.4),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.4),
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
                          textInputAction:
                              customTextField.TextInputAction.newline,
                          decoration: InputDecoration(
                            labelText: 'To-do',
                            labelStyle:
                                TextStyle(fontSize: 13, color: liltextColor),
                            contentPadding:
                                EdgeInsets.only(left: 30, top: 1, right: 30),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.3),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.3),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.3),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  key: key2,
                  backgroundColor: CupertinoColors.systemBackground,
                  resizeToAvoidBottomPadding: false,
                  floatingActionButton: Transform.scale(
                    scale: 0.9,
                    child: FloatingActionButton(
                      mini: true,
                      elevation: 2.0,
                      backgroundColor: CupertinoColors.systemBlue,
                      child: Icon(
                        EvaIcons.fileText,
                        color: Colors.white,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          dummyBool = !dummyBool;
                        });
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) {
                        //       return AddNewNote();
                        //     },
                        //     fullscreenDialog: true,
                        //   ),
                        // );
                      },
                    ),
                  ),
                  body: SafeArea(
                    child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle.light,
                      child: CustomScrollView(
                        controller: _controller2,
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            collapsedHeight: 70,
                            // expandedHeight: 100,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Transform.scale(
                                scale: 1,
                                child: Form(
                                  // key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Container(
                                          child: Card(
                                            elevation: 1.4,
                                            shadowColor: CupertinoColors
                                                .darkBackgroundGray,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: TextFormField(
                                              onTap: () {
                                                setState(() {
                                                  canTap = false;
                                                });
                                              },
                                              // autofocus: true,
                                              onSaved: (input) {},

                                              validator: (input) => !input
                                                          .contains('@') ||
                                                      !input.contains('.') ||
                                                      input.length < 5 ||
                                                      input == null ||
                                                      input.isEmpty ||
                                                      input.endsWith('.')
                                                  ? null
                                                  : null,
                                              keyboardType: TextInputType.url,
                                              cursorColor: Colors.grey[500],

                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .color,
                                                  fontSize: 15),
                                              autocorrect: false,
                                              enableInteractiveSelection: false,
                                              decoration: InputDecoration(
                                                // contentPadding: EdgeInsets.only(left: 15),
                                                alignLabelWithHint: true,
                                                isDense: true,

                                                hintText: 'Email',
                                                hintStyle: TextStyle(
                                                    color: liltextColor),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      width: 0.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      width: 0.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      width: 0.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      width: 0.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      width: 0.0),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      width: 0.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                EvaIcons.radioButtonOff,
                                                color:
                                                    CupertinoColors.activeBlue,
                                              ),
                                              Transform.scale(
                                                scale: 0.8,
                                                child: Icon(
                                                  EvaIcons.moreHorizotnal,
                                                  color: CupertinoColors
                                                      .activeBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              isDismissible: true,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (BuildContext
                                                          context,
                                                      StateSetter setState) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: Icon(
                                                            EvaIcons
                                                                .trash2Outline,
                                                            color: liltextColor,
                                                          ),
                                                          title: Text(
                                                            'Bin',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    textColor),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) {
                                                                  return Bin();
                                                                },
                                                                fullscreenDialog:
                                                                    true,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                            EvaIcons
                                                                .flagOutline,
                                                            color: liltextColor,
                                                          ),
                                                          title: Text(
                                                            'Flagged',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    textColor),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) {
                                                                  return FlaggedNotes();
                                                                },
                                                                fullscreenDialog:
                                                                    true,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                            EvaIcons
                                                                .eyeOff2Outline,
                                                            color: liltextColor,
                                                          ),
                                                          title: Text(
                                                            'Hidden Notes',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    textColor),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) {
                                                                  return HiddenNotes();
                                                                },
                                                                fullscreenDialog:
                                                                    true,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        Divider(
                                                          indent: 70,
                                                          endIndent: 70,
                                                          color: liltextColor,
                                                          thickness: 0.2,
                                                          height: 0.0,
                                                        ),
                                                        Theme(
                                                          data: ThemeData(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                          ),
                                                          child: ListTile(
                                                            title: Text(
                                                              'Empty Bin after 30 days.',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      liltextColor),
                                                            ),
                                                            //  dense: true,
                                                            trailing:
                                                                Switch.adaptive(
                                                              activeTrackColor:
                                                                  buttonColor,
                                                              activeColor:
                                                                  buttonColor,
                                                              value: isSwitched,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  isSwitched =
                                                                      value;
                                                                  updateDeletePreference(
                                                                      value);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ).whenComplete(() {
                                              setState(() {
                                                canTap = true;
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            brightness: Brightness.light,
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            actions: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  EvaIcons.attachOutline,
                                  color: Colors.transparent,
                                ),
                                onPressed: () => null,
                              ),
                            ],
                            // title: Hero(
                            //   tag: 'title',
                            //   child: RichText(
                            //     text: TextSpan(
                            //       children: [
                            //         TextSpan(
                            //           text: 'Not3s ',
                            //           style: TextStyle(
                            //               letterSpacing: -0.5,
                            //               color: liltextColor,
                            //               fontSize: 18,
                            //               fontWeight: FontWeight.w500),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Column(
                                  children: [
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 500),
                                      child: animationComplete
                                          ? (Provider.of<UserData>(context)
                                                      .notesFromUser
                                                      .length !=
                                                  0
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Card(
                                                      color: CupertinoColors
                                                          .systemBackground,
                                                      shape:
                                                          ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                      borderOnForeground: true,
                                                      elevation: 0,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: ListTile(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 30.0,
                                                                right: 30.0),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              fullscreenDialog:
                                                                  true,
                                                              builder: (_) {
                                                                return EditAndViewNotes(
                                                                  index: index,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        title: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  Provider.of<UserData>(
                                                                          context)
                                                                      .titleOfNotesFromUser[index],
                                                                  style: TextStyle(
                                                                      color:
                                                                          liltextColor,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                Text(
                                                                  Provider.of<UserData>(
                                                                          context)
                                                                      .dateOfNoteCreation[index],
                                                                  style: TextStyle(
                                                                      color:
                                                                          liltextColor,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  Provider.of<UserData>(
                                                                          context)
                                                                      .notesFromUser[index],
                                                                  style: TextStyle(
                                                                      color: liltextColor
                                                                          .withOpacity(
                                                                              0.7),
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  key: ValueKey<int>(2),
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              4,
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        height: 150,
                                                        width: 150,
                                                        child: FlareActor(
                                                          'assets/flare/empty2.flr',
                                                          animation: 'Idle',
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'Your notes are empty',
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          : Container(
                                              key: ValueKey<int>(3),
                                              foregroundDecoration:
                                                  Provider.of<UserData>(context)
                                                              .notesFromUser
                                                              .length ==
                                                          0
                                                      ? BoxDecoration(
                                                          color: testColor)
                                                      : BoxDecoration(),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: index ==
                                                                  0 &&
                                                              index ==
                                                                  Provider.of<UserData>(
                                                                              context)
                                                                          .notesFromUser
                                                                          .length -
                                                                      1
                                                          ? BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(11),
                                                              topLeft: Radius
                                                                  .circular(11),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          11),
                                                              bottomLeft: Radius
                                                                  .circular(11),
                                                            )
                                                          : index == 0
                                                              ? BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          11),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          11),
                                                                )
                                                              : index ==
                                                                      Provider.of<UserData>(context)
                                                                              .notesFromUser
                                                                              .length -
                                                                          1
                                                                  ? BorderRadius
                                                                      .only(
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              11),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              11),
                                                                    )
                                                                  : BorderRadius
                                                                      .zero,
                                                      child: Card(
                                                        color: CupertinoColors
                                                            .systemBackground,
                                                        shape:
                                                            ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                        ),
                                                        borderOnForeground:
                                                            true,
                                                        elevation: 0,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: ListTile(
                                                          title: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 14,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  FLSkeleton(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(2),
                                                                    width: 60,
                                                                    height: 21,
                                                                  ),
                                                                  FLSkeleton(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(2),
                                                                    width: 60,
                                                                    height: 21,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          subtitle: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  FLSkeleton(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(2),
                                                                    width: 200,
                                                                    height: 21,
                                                                  ),
                                                                  // SizedBox(
                                                                  //   height: 15,
                                                                  // )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          // trailing: Padding(
                                                          //   padding: const EdgeInsets.only(bottom: 22.0, right: 10),
                                                          //   child: Text(
                                                          //     Provider.of<UserData>(context).dateOfNoteCreation[index],
                                                          //     style: TextStyle(color: liltextColor, fontSize: 14),
                                                          //   ),
                                                          // ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              },
                              childCount:
                                  // Provider.of<UserData>(context)
                                  //     .notesFromUser
                                  //     .length
                                  Provider.of<UserData>(context)
                                              .notesFromUser
                                              .length ==
                                          0
                                      ? 1
                                      : Provider.of<UserData>(context)
                                          .notesFromUser
                                          .length,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SizedBox(
                                  height: 500,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (Provider.of<UserData>(context, listen: false).notesFromUser.length ==
        0) {
      setState(
        () {
          animationComplete = true;
        },
      );
    } else {
      Future.delayed(
        Duration(milliseconds: 1000),
        () {
          setState(
            () {
              animationComplete = true;
            },
          );
        },
      );
    }
  }
}
