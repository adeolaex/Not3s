//The first page rendered to the phone. The main.dart runs functions that returns
//values needed for the Home screen.
//The values are then sent to the Provider classes so that other screens can get the returned values.

//
import 'package:Not3s/Screens/AddNewNoteScreen.dart';
import 'package:Not3s/Screens/EditAndViewNotes.dart';
import 'package:Not3s/UnderTheHood/Colors.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetsheet/sweetsheet.dart';

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
  bool viewing;
  bool canTap;
  bool showing = false;
  String notesFromUser;
  String titleOfNotesFromUser;
  String dateOfNoteCreated;
  String imagePath;
  bool isEditing;
  int index;
  bool timerOn;
  SweetSheet _sweetSheet;
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
    _sweetSheet = SweetSheet();
    timerOn = false;
    isEditing = true;
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
      color: backGroundColor,
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Scaffold(
            key: key2,
            backgroundColor: backGroundColor,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: Transform.scale(
              scale: 1.0,
              child: GestureDetector(
                onLongPress: () {
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
                onTap: () {},
                child: FloatingActionButton(
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
                  // mini: true,
                  elevation: 2.0,
                  backgroundColor: buttonColor,
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
                ),
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                onPanCancel: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Provider.of<UserData>(context).notesFromUser.isNotEmpty
                      ? CustomScrollView(
                          key: ValueKey(1),
                          cacheExtent: 10.0,
                          physics: NoImplicitScrollPhysics(
                            parent: ScrollPhysics(),
                          ),
                          controller: _controller,
                          slivers: [
                            SliverAppBar(
                              floating: true,
                              collapsedHeight: 80,
                              // expandedHeight: 10,
                              flexibleSpace: FlexibleSpaceBar(
                                title: Form(
                                  // key: _formKey,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 27.0, right: 27.0),
                                    child: Card(
                                      elevation: 0.0,
                                      shadowColor: CupertinoColors.lightBackgroundGray,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Stack(
                                        alignment: Alignment(1.0, 0.0),
                                        children: <Widget>[
                                          TextFormField(
                                            textCapitalization: TextCapitalization.words,

                                            onTap: () {
                                              setState(() {
                                                canTap = false;
                                              });
                                            },
                                            // autofocus: true,
                                            onSaved: (input) {},

                                            keyboardType: TextInputType.text,
                                            cursorColor: CupertinoColors.activeBlue,
                                            style: TextStyle(color: textColor, fontSize: 16),
                                            autocorrect: false,
                                            decoration: InputDecoration(
                                              // alignLabelWithHint: true,
                                              // contentPadding: EdgeInsets.only(bottom: 30),

                                              contentPadding: EdgeInsets.only(left: 10, top: 1),
                                              hintText: 'Search',
                                              hintStyle: TextStyle(color: liltextColor.withOpacity(0.7), fontSize: 16),
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
                                          Positioned(
                                            child: IconButton(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              icon: Icon(
                                                EvaIcons.externalLinkOutline,
                                                color: liltextColor.withOpacity(0.9),
                                              ),
                                              onPressed: () {
                                                _sweetSheet.show(
                                                  context: context,
                                                  description: Text(
                                                    'Place your order. Please confirm the placement of your order : Iphone X 128GB',
                                                    style: TextStyle(color: Color(0xff2D3748)),
                                                  ),
                                                  color: CustomSheetColor(
                                                    main: Colors.white,
                                                    accent: Color(0xff5A67D8),
                                                    icon: Color(0xff5A67D8),
                                                  ),
                                                  icon: Icons.local_shipping,
                                                  positive: SweetSheetAction(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    title: 'Continue',
                                                  ),
                                                  negative: SweetSheetAction(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    title: 'Cancel',
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // brightness: Brightness.light,
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
                                  return Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (direction) async {
                                      if (direction == DismissDirection.endToStart) {
                                        Provider.of<UserData>(context, listen: false).notesFromUser.removeAt(index);
                                        Provider.of<UserData>(context, listen: false).titleOfNotesFromUser.removeAt(index);
                                        Provider.of<UserData>(context, listen: false).dateOfNoteCreation.removeAt(index);
                                        await _updateNotesFromUser(Provider.of<UserData>(context, listen: false).notesFromUser);
                                        await _updatetitleOfNotesFromUser(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                                        await _updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                                      } else if (direction == DismissDirection.startToEnd) {}
                                    },
                                    background: Container(
                                      color: buttonColor,
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
                                            EvaIcons.trash2,
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
                                          color: backGroundColor,
                                          shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          borderOnForeground: true,
                                          elevation: 0,
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Theme(
                                            data: ThemeData(splashColor: Colors.transparent),
                                            child: ListTile(
                                              // dense: true,
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
                                              title: Padding(
                                                padding: index != 0 ? const EdgeInsets.only(top: 20.0) : EdgeInsets.only(top: 0.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          Provider.of<UserData>(context).titleOfNotesFromUser[index],
                                                          style: TextStyle(color: liltextColor, fontSize: 15),
                                                        ),
                                                        Text(
                                                            Provider.of<UserData>(context).dateOfNoteCreation[index] == DateTime.now().toString().substring(0, 10).replaceAll('-', '. ')
                                                                ? 'Today'
                                                                : Provider.of<UserData>(context).dateOfNoteCreation[index],
                                                            style: TextStyle(color: liltextColor, fontSize: 15)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 15.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          Provider.of<UserData>(context).notesFromUser[index],
                                                          style: TextStyle(color: liltextColor, fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                childCount: Provider.of<UserData>(context).notesFromUser.length,
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
                        )
                      : Column(
                          key: ValueKey(2),
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
