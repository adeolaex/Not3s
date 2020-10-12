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
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _MyHomePageState extends State<MyHomePage> with AfterLayoutMixin, TickerProviderStateMixin {
  //Various keys are used in order for the animation switcher widget to transitions without errors.

  final GlobalKey<ScaffoldState> key2 = GlobalKey<ScaffoldState>();
  final GlobalKey key1 = GlobalKey();

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
  AnimationController _animationController;
  AnimationController _animationController2;
  Animation<double> sizeAnimation;
  Animation<Color> animatedColor;
  int canBeClicked;
  bool clicked;
  double height, width, defaultHeight, defaultWidth;
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

  updateHasAlarm(List<String> hasAlarm) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('hasAlarm', hasAlarm);
  }

  removeFlushbar(Flushbar flushbar) {
    flushbar.dismiss();
  }

  @override
  void initState() {
    canBeClicked = 0;
    clicked = false;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController2 = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    sizeAnimation = Tween(begin: 1.0, end: 0.7).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    animatedColor = ColorTween(begin: buttonColor, end: Colors.black87.withOpacity(0.7)).animate(_animationController2)
      ..addListener(() {
        setState(() {});
      });
    timerOn = false;
    isEditing = true;
    // canTap = true;
    dummyBool = false;
    _controller = ScrollController();
    myImage = Image.asset('assets/images/appIcon.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    defaultHeight = MediaQuery.of(context).size.height / 1.48;
    defaultWidth = MediaQuery.of(context).size.width / 1.22;
    precacheImage(myImage.image, context);
//Note to self..... init the state of bool value with after layout
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: key2,
          backgroundColor: backGroundColor,
          resizeToAvoidBottomPadding: false,
          floatingActionButton: Transform.scale(
            scale: sizeAnimation.value,
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  canBeClicked = canBeClicked + 1;
                });
                if (canBeClicked == 1) {
                  _animationController.forward();
                  Future.delayed(Duration(seconds: 2), () {
                    _animationController.reverse();
                  });
                  Future.delayed(Duration(milliseconds: 400), () async {
                    canBeClicked = 0;
                  });
                }
              },
              child: FloatingActionButton(
                splashColor: Colors.transparent,
                highlightElevation: 0.0,
                onPressed: () async {
                  print(Provider.of<UserData>(context, listen: false).notesFromUser);
                  print(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                  print(Provider.of<UserData>(context, listen: false).hasAlarm);
                  print(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                  print(Provider.of<UserData>(context, listen: false).imagePathOfEachNote);
                  setState(() {
                    canBeClicked = canBeClicked + 1;
                  });
                  if (canBeClicked == 1) {
                    _animationController.forward();
                    Future.delayed(Duration(milliseconds: 200), () {
                      _animationController.reverse();
                    });
                    Future.delayed(Duration(milliseconds: 400), () async {
                      canBeClicked = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return AddNewNoteScreen();
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    });
                  }
                },
                // mini: true,
                elevation: 2.0,
                backgroundColor: animatedColor.value,
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
          body: GestureDetector(
            child: CustomScrollView(
              cacheExtent: 10.0,
              physics: NoImplicitScrollPhysics(
                parent: ScrollPhysics(),
              ),
              controller: _controller,
              slivers: [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  collapsedHeight: 73,
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment(1.0, 0.0),
                            children: <Widget>[
                              TextFormField(
                                textCapitalization: TextCapitalization.words,

                                onTap: () {},
                                // autofocus: true,
                                onSaved: (input) {},

                                keyboardType: TextInputType.text,
                                cursorColor: CupertinoColors.activeBlue,
                                style: TextStyle(color: liltextColor.withOpacity(0.9), fontSize: 16),
                                autocorrect: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10, top: 1),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: liltextColor.withOpacity(0.7), fontSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300].withOpacity(0.8), width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300].withOpacity(0.8), width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300].withOpacity(0.8), width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300].withOpacity(0.8), width: 1.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300].withOpacity(0.8), width: 1.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300].withOpacity(0.8), width: 1.0),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(EvaIcons.menu2Outline, color: liltextColor.withOpacity(0.7)),
                                  onPressed: () {
                                    showCupertinoDialogCustom(
                                        useRootNavigator: true,
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => CustomBox(
                                              height: height,
                                              width: width,
                                              defaultHeight: defaultHeight,
                                              defaultWidth: defaultWidth,
                                            ))
                                      ..whenComplete(() => _animationController2.reverse());
                                    _animationController2.forward();
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
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return index == 0
                          ? Container(
                              margin: EdgeInsets.only(left: 30, bottom: 7),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.folderOutline,
                                    size: 14,
                                    color: liltextColor.withOpacity(0.8),
                                  ),
                                  Text(
                                    ' Notes',
                                    style: TextStyle(color: liltextColor, fontSize: 15),
                                  ),
                                ],
                              ),
                            )
                          : Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  Provider.of<UserData>(context, listen: false).notesFromUser.removeAt(index);
                                  Provider.of<UserData>(context, listen: false).titleOfNotesFromUser.removeAt(index);
                                  Provider.of<UserData>(context, listen: false).dateOfNoteCreation.removeAt(index);
                                  Provider.of<UserData>(context, listen: false).hasAlarm.removeAt(index);
                                  await _updateNotesFromUser(Provider.of<UserData>(context, listen: false).notesFromUser);
                                  await _updatetitleOfNotesFromUser(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                                  await _updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                                  await _updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).hasAlarm);
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
                                      data: ThemeData(splashColor: Color(0xFFE1E8ED).withOpacity(0.6), highlightColor: Color(0xFFE1E8ED).withOpacity(0.9)),
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
                                          padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    Provider.of<UserData>(context).titleOfNotesFromUser[index].trim(),
                                                    style: TextStyle(color: liltextColor, fontSize: 15.7),
                                                  ),
                                                  Text(
                                                      Provider.of<UserData>(context).dateOfNoteCreation[index] == DateTime.now().toString().substring(0, 10).replaceAll('-', '. ')
                                                          ? 'Today'
                                                          : Provider.of<UserData>(context).dateOfNoteCreation[index].trim(),
                                                      style: TextStyle(color: liltextColor.withOpacity(0.8), fontSize: 15.7)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    Provider.of<UserData>(context).notesFromUser[index].trim(),
                                                    style: TextStyle(color: liltextColor.withOpacity(0.8), fontSize: 15),
                                                  ),
                                                  Provider.of<UserData>(context).hasAlarm[index] == 'true'
                                                      ? Transform.scale(
                                                          scale: 0.8,
                                                          child: Icon(
                                                            EvaIcons.clock,
                                                            color: liltextColor.withOpacity(0.8),
                                                          ),
                                                        )
                                                      : SizedBox()
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
                        height: MediaQuery.of(context).size.height / 1.2,
                      )
                    ],
                  ),
                )
              ],
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
        Duration(microseconds: 1),
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

class CustomBox extends StatefulWidget {
  final double height, width, defaultWidth, defaultHeight;
  CustomBox({this.height, this.width, this.defaultHeight, this.defaultWidth});
  @override
  _CustomBoxState createState() => _CustomBoxState();
}

class _CustomBoxState extends State<CustomBox> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationController2;
  Animation<double> height;
  Animation<double> width;
  Animation<double> radius;
  Animation<double> padding;
  Animation<double> alignment;
  Animation<double> position;
  Animation<double> safeArea;
  Animation<double> spacer;
  double defaultHeight;
  double defaultWidth;
  bool clicked;
  bool checkbox;
  bool isExpanded;
  updateDeletePreference(bool value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('emptyAfter30Days', value);
    Provider.of<UserData>(context, listen: false).emptyAfter30Days = value;
  }

  @override
  void initState() {
    clicked = false;
    isExpanded = false;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100), reverseDuration: Duration(milliseconds: 20));
    _animationController2 = AnimationController(vsync: this, duration: Duration(milliseconds: 250), reverseDuration: Duration(milliseconds: 200));
    height = Tween(begin: widget.defaultHeight, end: widget.height).animate(_animationController2)
      ..addListener(() {
        setState(() {});
      });
    width = Tween(begin: widget.defaultWidth, end: widget.width).animate(_animationController2)
      ..addListener(() {
        setState(() {});
      });
    padding = Tween(begin: 60.0, end: 100.0).animate(_animationController2)
      ..addListener(() {
        setState(() {});
      });
    safeArea = Tween(begin: 0.0, end: 10.0).animate(_animationController2)
      ..addListener(() {
        setState(() {});
      });
    spacer = Tween(begin: 5.0, end: 15.0).animate(_animationController2)
      ..addListener(() {
        setState(() {});
      });
    radius = Tween(begin: 8.0, end: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    alignment = Tween(begin: 1.0, end: 5.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    checkbox = Provider.of<UserData>(context).emptyAfter30Days;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.0),
      child: GestureDetector(
        // onVerticalDragUpdate: (DragUpdateDetails details) {
        //   // direction == true ? _animationController2.forward() : _animationController2.reverse();
        //   if (details.delta.dy < 0.0) {
        //     _animationController.forward();
        //     _animationController2.forward();
        //   } else if (details.delta.direction > 0.0) {
        //     _animationController2.reverse();
        //     _animationController.reverse();
        //   }
        // },

        child: Container(
          width: width.value,
          height: height.value,
          child: Material(
            color: Colors.black87.withOpacity(0.7),
            borderRadius: BorderRadius.circular(radius.value),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Divider(
              //   height: 0.0,
              //   thickness: 0.7,
              //   color: Color(0xFFE1E8ED),
              // ),
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                ),
                child: ListTile(
                  title: Text(
                    'Flagged Notes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  leading: Transform.scale(
                    scale: 0.8,
                    child: Icon(
                      EvaIcons.flagOutline,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                ),
                child: ListTile(
                  title: Text(
                    'Bin',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  leading: Transform.scale(
                    scale: 0.8,
                    child: Icon(
                      EvaIcons.trashOutline,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                ),
                child: ListTile(
                  title: Text(
                    'View Repository',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  leading: Transform.scale(
                    scale: 0.8,
                    child: Icon(
                      EvaIcons.githubOutline,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                ),
                child: ListTile(
                  title: Text(
                    'Feedback',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  leading: Transform.scale(
                    scale: 0.8,
                    child: Icon(
                      EvaIcons.messageSquareOutline,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              // Theme(
              //   data: ThemeData(splashColor: Colors.transparent),
              //   child: ListTile(
              //     title: Text(
              //       'Empty bin after 30 days',
              //       style: TextStyle(
              //         color: liltextColor.withOpacity(0.7),
              //         fontSize: 16,
              //       ),
              //     ),
              //     // leading: Icon(EvaIcons.trash2Outline, size: 20),
              //     trailing: Transform.scale(
              //       scale: 0.8,
              //       child: Checkbox(
              //         activeColor: buttonColor,
              //         value: checkbox,
              //         onChanged: (bool value) {
              //           setState(() {
              //             checkbox = !checkbox;
              //           });
              //           updateDeletePreference(checkbox);
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}

Future<T> showCupertinoDialogCustom<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool useRootNavigator = true,
  bool barrierDismissible = false,
  RouteSettings routeSettings,
}) {
  assert(builder != null);
  assert(useRootNavigator != null);
  return showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: CupertinoLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.8),
    // This transition duration was eyeballed comparing with iOS
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return builder(context);
    },
    transitionBuilder: _buildCupertinoDialogTransitions,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.linearToEaseOut));

Widget _buildCupertinoDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  final CurvedAnimation fadeAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );
  if (animation.status == AnimationStatus.reverse) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      child: child,
      scale: animation.drive(_dialogScaleTween),
    ),
  );
}
