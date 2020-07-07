import 'package:Not3s/Screens/AddNewNoteScreen.dart';
import 'package:Not3s/UnderTheHood/Colors.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animations/animations.dart';
import 'package:Not3s/UnderTheHood/menu_action.dart' as customMenuAction;

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
    isSwitched = Provider.of<UserData>(context).emptyAfter30Days;
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
              PageTransition(child: AddNewNote(), type: PageTransitionType.fade),
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
              //  padding: EdgeInsets.zero,
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
                                'Recently Deleted',
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
                                  'Empty Deleted notes after 30 days.',
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
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                print('Done');
                              } else if (direction == DismissDirection.startToEnd) {
                                setState(() {
                                  Provider.of<UserData>(context, listen: false).notesFromUser.removeAt(index);
                                });
                              }
                            },
                            background: Container(
                              color: Colors.red[500],
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                                child: FlareActor(
                                  "assets/flare/errorR.flr",
                                  alignment: Alignment.center,
                                  animation: "Error",
                                  //    color: darkAppBarColor,
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: buttonColor,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
                                child: Icon(EvaIcons.doneAllOutline, color: Colors.white),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: CupertinoContextMenu(
                                actions: <Widget>[
                                  customMenuAction.CupertinoContextMenuAction(
                                    child: Text(
                                      'text',
                                      style: TextStyle(color: textColor),
                                    ),
                                    trailingIcon: EvaIcons.diagonalArrowLeftDown,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  customMenuAction.CupertinoContextMenuAction(
                                    child: Text(
                                      'textsd',
                                      style: TextStyle(color: textColor),
                                    ),
                                    trailingIcon: EvaIcons.diagonalArrowLeftDown,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFE8E8E8),
                                      ),
                                      child: Image.asset('assets/images/appIcon1.png'),
                                      margin: EdgeInsets.only(top: 10, left: 10),
                                      width: 40,
                                      height: 30,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      margin: EdgeInsets.only(left: 60, top: 10, right: 10),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            Provider.of<UserData>(context).titleOfNotesFromUser[index],
                                            style: TextStyle(color: liltextColor, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 30,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            Provider.of<UserData>(context).notesFromUser[index],
                                            style: TextStyle(color: liltextColor, fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(left: 60, top: 40, bottom: 10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 30,
                                    ),
                                  ],
                                ),
                                // child: Material(
                                //   color: Colors.white,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(2.0),
                                //     child: Container(
                                //       color: Colors.white,
                                //       padding: EdgeInsets.all(3),
                                //       child: Stack(
                                //         children: <Widget>[
                                //           Container(
                                //             decoration: BoxDecoration(
                                //               shape: BoxShape.circle,
                                //               color: Color(0xFFE8E8E8),
                                //             ),
                                //             child: Image.asset('assets/images/appIcon1.png'),
                                //             margin: EdgeInsets.only(top: 10, left: 10),
                                //             width: 40,
                                //             height: 30,
                                //           ),
                                //           Container(
                                //             decoration: BoxDecoration(
                                //               shape: BoxShape.rectangle,
                                //               borderRadius: BorderRadius.circular(2),
                                //             ),
                                //             margin: EdgeInsets.only(left: 60, top: 10, right: 10),
                                //             child: Padding(
                                //               padding: EdgeInsets.only(left: 10),
                                //               child: Material(
                                //                 color: Colors.transparent,
                                //                 child: Text(
                                //                   Provider.of<UserData>(context).titleOfNotesFromUser[index],
                                //                   style: TextStyle(color: liltextColor, fontSize: 17),
                                //                 ),
                                //               ),
                                //             ),
                                //             width: 500,
                                //             height: 17,
                                //           ),
                                //           Container(
                                //             decoration: BoxDecoration(
                                //               shape: BoxShape.rectangle,
                                //               borderRadius: BorderRadius.circular(2),
                                //             ),
                                //             child: Padding(
                                //               padding: EdgeInsets.only(left: 10),
                                //               child: Material(
                                //                 color: Colors.transparent,
                                //                 child: Text(
                                //                   Provider.of<UserData>(context).notesFromUser[index],
                                //                   style: TextStyle(color: liltextColor, fontSize: 15),
                                //                 ),
                                //               ),
                                //             ),
                                //             margin: EdgeInsets.only(left: 60, top: 40, bottom: 10),
                                //             width: 100,
                                //             height: 17,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                previewBuilder: (BuildContext context, Animation<double> animation, Widget child) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(13.0 * animation.value),
                                    child: Material(
                                      color: Color(0xFFEEEEEE),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFEEEEEE),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.asset('assets/images/appIcon1.png'),
                                            ),
                                            margin: EdgeInsets.only(top: 10, left: 10),
                                            width: 40,
                                            height: 30,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                            margin: EdgeInsets.only(left: 60, top: 10, right: 10),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  Provider.of<UserData>(context).titleOfNotesFromUser[index],
                                                  style: TextStyle(color: liltextColor, fontSize: 17),
                                                ),
                                              ),
                                            ),
                                            width: 500,
                                            height: 17,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  Provider.of<UserData>(context).notesFromUser[index],
                                                  style: TextStyle(color: liltextColor, fontSize: 15),
                                                ),
                                              ),
                                            ),
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
    Future.delayed(
      Duration(seconds: 2),
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
