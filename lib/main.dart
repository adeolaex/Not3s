import 'package:Not3s/Screens/HomeScreen.dart';
import 'package:Not3s/UnderTheHood/Provider.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Used to warm up the flare asset files so as to speed up animation play times.
//Another method would be to run  the same function with after layout. A flutter package that runs
// code when the first frame of a screen is shown (rendered)
// Although this would be practical, it might result it a slow user experience.
// This method makes sure the warm up is executed during the splash screen resulting the little to know startup time :)
Future<void> warmUp() async {
  cachedActor(
    AssetFlare(
      bundle: rootBundle,
      name: 'assets/flare/empty2.flr',
    ),
  );
}

Future<void> warmUp2() async {
  cachedActor(
    AssetFlare(
      bundle: rootBundle,
      name: 'assets/flare/success.flr',
    ),
  );
}

Future<void> warmUp3() async {
  cachedActor(
    AssetFlare(
      bundle: rootBundle,
      name: 'assets/flare/error.flr', //...pre cache in the later future
    ),
  );
}

// Gets the User Data from the internal sotrage using https://pub.dev/packages/shared_preferences
// and stores said data values into the Provider classes.
//
_notesFromUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // preferences.setStringList('notesFromUser', []);
  // This are used to reset the data stored within the storage of a device during production.
  List<String> notesFromUser = preferences.getStringList('notesFromUser') ?? [];
  return notesFromUser;
}

_titleOfNotesFromUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // preferences.setStringList('titleOfNotesFromUser', []);
  // This are used to reset the data stored within the storage of a device during production.
  List<String> titleOfNotesFromUser = preferences.getStringList('titleOfNotesFromUser') ?? [];

  return titleOfNotesFromUser;
}

_emptyAfter30Days() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // preferences.setBool('emptyAfter30Days', false);
  // This are used to reset the data stored within the storage of a device during production.
  bool emptyAfter30Days = preferences.getBool('emptyAfter30Days') ?? true;
  return emptyAfter30Days;
}

_dateOfNoteCreation() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // preferences.setStringList('dateOfNoteCreation', []);
  // This are used to reset the data stored within the storage of a device during production.
  List<String> dateOfNoteCreation = preferences.getStringList('dateOfNoteCreation') ?? [];
  return dateOfNoteCreation;
}

_imagePathOfEachNote() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // preferences.setStringList('imagePathOfEachNote', []);
  //  This are used to reset the data stored within the storage of a device during production.
  List<String> imagePathOfEachNote = preferences.getStringList('imagePathOfEachNote') ?? [];
  return imagePathOfEachNote;
}

//The main function that contains the runApp() used in rendering screens.

// The functions above return values that are passed down to the MyApp() widget which then passes it
// to the Provider classes.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitDown,
  ]);
  final List<String> notesFromUser = await _notesFromUser();
  final List<String> titleOfNotesFromUser = await _titleOfNotesFromUser();
  final List<String> imagePathOfEachNote = await _imagePathOfEachNote();
  bool emptyAfter30Days = await _emptyAfter30Days();
  final List<String> dateOfNoteCreation = await _dateOfNoteCreation();
  FlareCache.doesPrune = false; //This makes sure the wamr up function caches the flare asset files.
  warmUp();
  FlareCache.doesPrune = false;
  warmUp2();
  FlareCache.doesPrune = false;
  runApp(
    MyApp(
      notesFromUser: notesFromUser,
      titleOfNotesFromUser: titleOfNotesFromUser,
      emptyAfter30Days: emptyAfter30Days,
      dateOfNoteCreation: dateOfNoteCreation,
      imagePathOfEachNote: imagePathOfEachNote,
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<String> notesFromUser;
  final List<String> titleOfNotesFromUser;
  final List<String> dateOfNoteCreation;
  final List<String> imagePathOfEachNote;
  final int numberOfNotes;
  final bool emptyAfter30Days;
  const MyApp({Key key, this.notesFromUser, this.numberOfNotes, this.emptyAfter30Days, this.titleOfNotesFromUser, this.dateOfNoteCreation, this.imagePathOfEachNote}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Not3s',
        theme: ThemeData(brightness: Brightness.light),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              Provider.of<UserData>(context).notesFromUser = notesFromUser;
              Provider.of<UserData>(context).titleOfNotesFromUser = titleOfNotesFromUser;
              Provider.of<UserData>(context).emptyAfter30Days = emptyAfter30Days;
              Provider.of<UserData>(context).dateOfNoteCreation = dateOfNoteCreation;
              Provider.of<UserData>(context).imagePathOfEachNote = imagePathOfEachNote;
              return MyHomePage();
            },
          );
        },
      ),
    );
  }
}
