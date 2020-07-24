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
import 'package:Not3s/UnderTheHood/lan.dart';
import 'package:after_layout/after_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flui/flui.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:uuid/uuid.dart';

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

class _MyHomePageState extends State<MyHomePage> with AfterLayoutMixin, SingleTickerProviderStateMixin {
  //Various keys are used in order for the animation switcher widget to transitions without errors.
  final GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> key2 = GlobalKey<ScaffoldState>();
  updateDeletePreference(bool value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('emptyAfter30Days', value);
  }

  bool animationComplete = false;
  ScrollController _controller;

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
  int index;
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
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    // canTap = true;
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
    var time = DateTime.now().add(
      Duration(seconds: 2),
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('your other channel id', 'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // flutterLocalNotificationsPlugin.schedule(0, 'To-do', 'Also test', time, notificationDetails)
    //   ..whenComplete(
    //     () {
    //       FlutterAppBadger.updateBadgeCount(2);
    //     },
    //   );

    dummyBool = false;
    _controller = ScrollController();
    myImage = Image.asset('assets/images/appIcon.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(myImage.image, context);
    isSwitched = Provider.of<UserData>(context).emptyAfter30Days; //Note to self..... init the state of bool value with after layout
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground,
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Scaffold(
            key: key2,
            backgroundColor: CupertinoColors.systemBackground,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: Transform.scale(
              scale: 1.0,
              child: FloatingActionButton(
                // mini: true,
                elevation: 2.0,
                backgroundColor: Color.fromRGBO(29, 161, 242, 1.0),
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Icon(
                        EvaIcons.fileText,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      right: 24,
                      top: 7,
                      child: Transform.scale(
                        scale: 0.7,
                        child: Icon(
                          EvaIcons.plusOutline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return AddNewNoteScreen();
                      },
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ),
            body: SafeArea(
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  onPanCancel: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: CustomScrollView(
                    physics: NoImplicitScrollPhysics(
                      parent: ScrollPhysics(),
                    ),
                    controller: _controller,
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        collapsedHeight: 70,
                        // expandedHeight: 10,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Form(
                            // key: _formKey,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                    child: Container(
                                      child: Card(
                                        elevation: 0.0,
                                        shadowColor: CupertinoColors.lightBackgroundGray,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: TextFormField(
                                          textCapitalization: TextCapitalization.words,

                                          onTap: () {
                                            setState(() {
                                              canTap = false;
                                            });
                                          },
                                          // autofocus: true,
                                          onSaved: (input) {},

                                          keyboardType: TextInputType.text,
                                          cursorColor: Color.fromRGBO(29, 161, 242, 1.0),
                                          style: TextStyle(color: textColor, fontSize: 15),
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 10),
                                            prefixIcon: Container(width: 1),
                                            suffixIcon: Container(width: 1),
                                            isDense: true,
                                            hintText: 'Search',
                                            hintStyle: TextStyle(color: liltextColor.withOpacity(0.7), fontSize: 17),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide(color: Colors.grey[300], width: 0.7),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide(color: Colors.grey[300], width: 0.7),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide(color: Colors.grey[300], width: 0.7),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide(color: Colors.grey[300], width: 0.7),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide(color: Colors.grey[300], width: 0.7),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide(color: Colors.grey[300], width: 0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(200, 0),
                                    child: SizedBox(
                                      height: 1000,
                                      width: 80,
                                      child: FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 30.0),
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: Icon(
                                              EvaIcons.moreVertical,
                                              color: liltextColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          FlutterAppBadger.updateBadgeCount(7);
                                          print(Provider.of<UserData>(context, listen: false).notesFromUser);
                                          print(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                                          print(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);

                                          showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState) {
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      ListTile(
                                                        leading: Icon(
                                                          EvaIcons.trash2Outline,
                                                          color: liltextColor,
                                                        ),
                                                        title: Text(
                                                          'Bin',
                                                          style: TextStyle(fontSize: 14, color: textColor),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return Bin();
                                                              },
                                                              fullscreenDialog: true,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          EvaIcons.flagOutline,
                                                          color: liltextColor,
                                                        ),
                                                        title: Text(
                                                          'Flagged',
                                                          style: TextStyle(fontSize: 14, color: textColor),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return FlaggedNotes();
                                                              },
                                                              fullscreenDialog: true,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          EvaIcons.eyeOff2Outline,
                                                          color: liltextColor,
                                                        ),
                                                        title: Text(
                                                          'Hidden Notes',
                                                          style: TextStyle(fontSize: 14, color: textColor),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return HiddenNotes();
                                                              },
                                                              fullscreenDialog: true,
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
                                                          splashColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            'Empty Bin after 30 days.',
                                                            style: TextStyle(fontSize: 14, color: liltextColor),
                                                          ),
                                                          //  dense: true,
                                                          trailing: Switch.adaptive(
                                                            activeTrackColor: buttonColor,
                                                            activeColor: buttonColor,
                                                            value: isSwitched,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isSwitched = value;
                                                                updateDeletePreference(value);
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
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(20, 0),
                                    child: SizedBox(
                                      height: 900,
                                      width: 80,
                                      child: FlatButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: Icon(
                                              EvaIcons.externalLinkOutline,
                                              color: liltextColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          FlutterAppBadger.updateBadgeCount(7);
                                          print(Provider.of<UserData>(context, listen: false).notesFromUser);
                                          print(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                                          print(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);

                                          showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState) {
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      ListTile(
                                                        leading: Icon(
                                                          EvaIcons.trash2Outline,
                                                          color: liltextColor,
                                                        ),
                                                        title: Text(
                                                          'Bin',
                                                          style: TextStyle(fontSize: 14, color: textColor),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return Bin();
                                                              },
                                                              fullscreenDialog: true,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          EvaIcons.flagOutline,
                                                          color: liltextColor,
                                                        ),
                                                        title: Text(
                                                          'Flagged',
                                                          style: TextStyle(fontSize: 14, color: textColor),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return FlaggedNotes();
                                                              },
                                                              fullscreenDialog: true,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          EvaIcons.eyeOff2Outline,
                                                          color: liltextColor,
                                                        ),
                                                        title: Text(
                                                          'Hidden Notes',
                                                          style: TextStyle(fontSize: 14, color: textColor),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) {
                                                                return HiddenNotes();
                                                              },
                                                              fullscreenDialog: true,
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
                                                          splashColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            'Empty Bin after 30 days.',
                                                            style: TextStyle(fontSize: 14, color: liltextColor),
                                                          ),
                                                          //  dense: true,
                                                          trailing: Switch.adaptive(
                                                            activeTrackColor: buttonColor,
                                                            activeColor: buttonColor,
                                                            value: isSwitched,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isSwitched = value;
                                                                updateDeletePreference(value);
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
                                    ),
                                  ),
                                ],
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
                                    child: Provider.of<UserData>(context).notesFromUser.length != 0
                                        ? Dismissible(
                                            key: UniqueKey(),
                                            confirmDismiss: (direction) async {
                                              bool returnValue;
                                              if (direction == DismissDirection.endToStart) {
                                                Provider.of<UserData>(context, listen: false).notesFromUser.removeAt(index);
                                                Provider.of<UserData>(context, listen: false).titleOfNotesFromUser.removeAt(index);
                                                Provider.of<UserData>(context, listen: false).dateOfNoteCreation.removeAt(index);
                                                await _updateNotesFromUser(Provider.of<UserData>(context, listen: false).notesFromUser);
                                                await _updatetitleOfNotesFromUser(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                                                await _updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                                                returnValue = true;
                                              } else if (direction == DismissDirection.startToEnd) {
                                                returnValue = true;
                                              }
                                              return returnValue;
                                            },
                                            background: Container(
                                              color: Color(0xFF1aa260),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 28.0),
                                                  child: Icon(
                                                    EvaIcons.flag,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            secondaryBackground: Container(
                                              color: Colors.red,
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 28.0),
                                                  child: Icon(
                                                    EvaIcons.trash,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Card(
                                                  color: CupertinoColors.systemBackground,
                                                  shape: ContinuousRectangleBorder(
                                                    borderRadius: BorderRadius.zero,
                                                  ),
                                                  borderOnForeground: true,
                                                  elevation: 0,
                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  child: Theme(
                                                    data: ThemeData(splashColor: Colors.transparent),
                                                    child: ListTile(
                                                      contentPadding: EdgeInsets.only(left: 30.0, right: 30.0),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            fullscreenDialog: true,
                                                            builder: (_) {
                                                              return EditAndViewNotes(
                                                                index: index,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      title: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                Provider.of<UserData>(context).titleOfNotesFromUser[index],
                                                                style: TextStyle(color: liltextColor, fontSize: 16),
                                                              ),
                                                              Text(
                                                                  Provider.of<UserData>(context).dateOfNoteCreation[index] == DateTime.now().toString().substring(0, 10).replaceAll('-', '. ')
                                                                      ? 'Today'
                                                                      : Provider.of<UserData>(context).dateOfNoteCreation[index],
                                                                  style: TextStyle(color: liltextColor.withOpacity(0.7), fontSize: 14)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Padding(
                                                        padding: const EdgeInsets.only(top: 18.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.circular(2),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                Provider.of<UserData>(context).notesFromUser[index],
                                                                style: TextStyle(color: liltextColor.withOpacity(0.7), fontSize: 15),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            key: ValueKey<int>(2),
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height / 4,
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
                                                  style: TextStyle(color: textColor),
                                                ),
                                              )
                                            ],
                                          ))
                              ],
                            );
                          },
                          childCount:
                              // Provider.of<UserData>(context)
                              //     .notesFromUser
                              //     .length
                              Provider.of<UserData>(context).notesFromUser.length == 0 ? 1 : Provider.of<UserData>(context).notesFromUser.length,
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
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (Provider.of<UserData>(context, listen: false).notesFromUser.length == 0) {
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

class NoImplicitScrollPhysics extends AlwaysScrollableScrollPhysics {
  const NoImplicitScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  bool get allowImplicitScrolling => false;

  @override
  NoImplicitScrollPhysics applyTo(ScrollPhysics ancestor) {
    return NoImplicitScrollPhysics(parent: buildParent(ancestor));
  }
}
