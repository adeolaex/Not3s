//The first page rendered to the phone. The main.dart runs functions that returns
//values needed for the Home screen.
//The values are then sent to the Provider classes so that other screens can get the returned values.

//

import 'dart:io';

import 'package:Not3s/Screens/AddNewNoteScreen.dart';
import 'package:Not3s/UnderTheHood/Colors.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _globalKey2 = GlobalKey<AnimatedListState>();
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

  _updateimagePathOfEachNote(List<String> imagePathOfEachNote) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('imagePathOfEachNote', imagePathOfEachNote);
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller2 = ScrollController();
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
    return Material(
      child: Scaffold(
        backgroundColor: CupertinoColors.white,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            EvaIcons.externalLinkOutline,
            color: liltextColor,
            size: 27,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return AddNewNote();
                },
                fullscreenDialog: true,
              ),
            );
          },
        ),
        key: key1,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                EvaIcons.attachOutline,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                EvaIcons.menu2,
                color: secondaryColor,
              ),
              onPressed: () {
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
                              onTap: () {},
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
                              onTap: () {},
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
                              onTap: () {},
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
                );
              },
            ),
          ],
          title: Hero(
            tag: 'title',
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
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 900),
          child: animationComplete
              ? (Provider.of<UserData>(context).notesFromUser.length != 0
                  ? Scrollbar(
                      key: ValueKey<int>(1),
                      controller: _controller2,
                      child: ListView.builder(
                        key: _globalKey,
                        itemCount: Provider.of<UserData>(context).notesFromUser.length,
                        controller: _controller2,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Dismissible(
                                key: UniqueKey(),
                                onDismissed: (DismissDirection direction) async {
                                  if (direction == DismissDirection.startToEnd) {
                                    print('Done');
                                  } else if (direction == DismissDirection.endToStart) {
                                    setState(
                                      () {
                                        Provider.of<UserData>(context, listen: false).notesFromUser.removeAt(index);
                                        Provider.of<UserData>(context, listen: false).titleOfNotesFromUser.removeAt(index);
                                        Provider.of<UserData>(context, listen: false).dateOfNoteCreation.removeAt(index);
                                        Provider.of<UserData>(context, listen: false).imagePathOfEachNote.removeAt(index);
                                      },
                                    );
                                    await _updateNotesFromUser(Provider.of<UserData>(context, listen: false).notesFromUser);
                                    await _updatetitleOfNotesFromUser(Provider.of<UserData>(context, listen: false).titleOfNotesFromUser);
                                    await _updatedateOfNoteCreation(Provider.of<UserData>(context, listen: false).dateOfNoteCreation);
                                    await _updateimagePathOfEachNote(Provider.of<UserData>(context, listen: false).imagePathOfEachNote);
                                  }
                                },
                                background: Container(
                                  color: buttonColor,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          EvaIcons.flag,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Flag',
                                          style: TextStyle(color: CupertinoColors.white, fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red[500],
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          EvaIcons.trash2,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: CupertinoColors.white, fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(),
                                      onTap: () {},
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Provider.of<UserData>(context).titleOfNotesFromUser[index],
                                                style: TextStyle(color: liltextColor, fontSize: 16),
                                              ),
                                              Text(
                                                Provider.of<UserData>(context).dateOfNoteCreation[index],
                                                style: TextStyle(color: liltextColor, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
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
                                              SizedBox(
                                                height: 15,
                                              )
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
                                  ],
                                ),
                              ),
                              Divider(
                                indent: 80,
                                color: liltextColor,
                                thickness: 0.2,
                                height: 0.0,
                              )
                            ],
                          );
                        },
                      ),
                    )
                  : ListView(
                      controller: _controller,
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
              : Scrollbar(
                  key: ValueKey<int>(2),
                  controller: _controller2,
                  child: ListView.builder(
                    key: _globalKey2,
                    itemCount: Provider.of<UserData>(context).notesFromUser.length,
                    controller: _controller2,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          child: Stack(
                            children: <Widget>[
                              FLSkeleton(
                                shape: BoxShape.circle,
                                margin: EdgeInsets.only(top: 10, left: 10),
                                width: 40,
                                height: 30,
                              ),
                              FLSkeleton(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(2),
                                margin: EdgeInsets.only(left: 60, top: 10, right: 10),
                                width: 500,
                                height: 17,
                              ),
                              FLSkeleton(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(2),
                                margin: EdgeInsets.only(left: 60, top: 40, bottom: 10),
                                width: 100,
                                height: 17,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
        Duration(seconds: 1),
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
