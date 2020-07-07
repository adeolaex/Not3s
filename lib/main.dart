import 'package:Not3s/Screens/HomeScreen.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> warmUp() async {
  List _fileNames = [
    'assets/flare/errorR.flr',
    'assets/flare/successR.flr',
    'assets/flare/empty2.flr',
  ];
  for (int i = 0; i < _fileNames.length; i++) {
    cachedActor(
      AssetFlare(
        bundle: rootBundle,
        name: _fileNames[i],
      ),
    );
  }
}

_notesFromUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> notesFromUser = preferences.getStringList('notesFromUser') ?? [];
  return notesFromUser;
}

_titleOfNotesFromUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> titleOfNotesFromUser = preferences.getStringList('titleOfNotesFromUser') ?? [];
  return titleOfNotesFromUser;
}

_emptyAfter30Days() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool emptyAfter30Days = preferences.getBool('emptyAfter30Days') ?? true;
  return emptyAfter30Days;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<String> notesFromUser = await _notesFromUser();
  final List<String> titleOfNotesFromUser = await _titleOfNotesFromUser();
  bool emptyAfter30Days = await _emptyAfter30Days();
  FlareCache.doesPrune = false;
  warmUp();
  warmUp().then(
    (value) => runApp(
      MyApp(
        notesFromUser: notesFromUser,
        titleOfNotesFromUser: titleOfNotesFromUser,
        emptyAfter30Days: emptyAfter30Days,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<String> notesFromUser;
  final List<String> titleOfNotesFromUser;
  final int numberOfNotes;
  final bool emptyAfter30Days;
  const MyApp({Key key, this.notesFromUser, this.numberOfNotes, this.emptyAfter30Days, this.titleOfNotesFromUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Not3s',
        theme: ThemeData(
          accentColor: Colors.grey[400].withOpacity(0.4),
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              Provider.of<UserData>(context).notesFromUser = notesFromUser;
              Provider.of<UserData>(context).titleOfNotesFromUser = titleOfNotesFromUser;
              Provider.of<UserData>(context).emptyAfter30Days = emptyAfter30Days;
              return MyHomePage();
            },
          );
        },
      ),
    );
  }
}
