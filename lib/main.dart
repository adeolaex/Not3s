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
  cachedActor(
    AssetFlare(bundle: rootBundle, name: 'assets/flare/empty2.flr'),
  );
}

_numberOfNotes() async {
  SharedPreferences prefences = await SharedPreferences.getInstance();
  int numberOfNotes = prefences.getInt('numberOfNotes') ?? 0;
  return numberOfNotes;
}

_notesFromUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<List<String>> notesFromUser = preferences.getStringList('notesFromUser') ?? [[]];
  return notesFromUser;
}

_emptyAfter30Days() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool emptyAfter30Days = preferences.getBool('emptyAfter30Days') ?? true;
  return emptyAfter30Days;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlareCache.doesPrune = false;
  int numberOfNotes = await _numberOfNotes();
  final List<List<String>> notesFromUser = await _notesFromUser();
  bool emptyAfter30Days = await _emptyAfter30Days();
  warmUp().then(
    (value) => runApp(
      MyApp(
        numberOfNotes: numberOfNotes,
        notesFromUser: notesFromUser,
        emptyAfter30Days: emptyAfter30Days,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<List<String>> notesFromUser;
  final int numberOfNotes;
  final bool emptyAfter30Days;
  const MyApp({Key key, this.notesFromUser, this.numberOfNotes, this.emptyAfter30Days}) : super(key: key);
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
              Provider.of<UserData>(context).numberOfNotes = numberOfNotes;
              Provider.of<UserData>(context).notesFromUser = notesFromUser;
              Provider.of<UserData>(context).emptyAfter30Days = emptyAfter30Days;
              return MyHomePage();
            },
          );
        },
      ),
    );
  }
}
