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
  AnimationController _animationController;
  Animation<double> sizeAnimation;
  int canBeClicked;
  bool clicked;
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
    canBeClicked = 0;
    clicked = false;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    sizeAnimation = Tween(begin: 1.0, end: 0.7).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _sweetSheet = SweetSheet();
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
    precacheImage(myImage.image, context);
    isSwitched = Provider.of<UserData>(context).emptyAfter30Days; //Note to self..... init the state of bool value with after layout
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
      child: SafeArea(
        bottom: false,
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
          body: GestureDetector(
            onPanCancel: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: CustomScrollView(
              cacheExtent: 10.0,
              physics: NoImplicitScrollPhysics(
                parent: ScrollPhysics(),
              ),
              controller: _controller,
              slivers: [
                SliverAppBar(
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
                                  icon: Icon(EvaIcons.menu2Outline, color: liltextColor.withOpacity(0.8)),
                                  onPressed: () {
                                    _sweetSheet.show(
                                      context: context,
                                      description: Text(
                                        'Choose the folder displayed',
                                        style: TextStyle(color: Color(0xff2D3748)),
                                      ),
                                      color: CustomSheetColor(
                                        main: Colors.white,
                                        accent: Color(0xff5A67D8),
                                        icon: Color(0xff5A67D8),
                                      ),
                                      icon: EvaIcons.folder,
                                      positive: SweetSheetAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        title: 'Deleted',
                                      ),
                                      negative: SweetSheetAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        title: 'Flaged Notes',
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
                                          padding: EdgeInsets.only(top: 3.0),
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
                                                      style: TextStyle(color: liltextColor, fontSize: 15.7)),
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
                                                    Provider.of<UserData>(context).notesFromUser[index].trim(),
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
                      GestureDetector(
                        onPanCancel: () {
                          print('worked');
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                        ),
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
