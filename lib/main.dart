import 'package:Not3s/Data/SharedPreferencesClass.dart';
import 'package:Not3s/Screens/HomeScreen.dart';
import 'package:Not3s/Data/Provider.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Used to warm up the flare asset files so as to speed up animation play times
// Another method would be to run  the same function with after layout. A flutter package that runs
// code when the first frame of a screen is shown (rendered)

// Although this would be practical, it might result it a slower user experience
// This method makes sure the warm up is executed during the splash screen resulting the little to no startup time :)

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

final List<String> dummyList = ['dummy'];

//The main function that contains the runApp() used in rendering screens.

// The functions above return values that are passed down to the MyApp() widget which then passes it
// to the Provider classes.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitDown,
  ]);
  final bool firstRun = await SharedPreferencesClass().firstRun();

  if (firstRun == true) {
    SharedPreferencesClass().updateNotesFromUser(dummyList);
    SharedPreferencesClass().updatedateOfNoteCreation(dummyList);
    SharedPreferencesClass().updatetitleOfNotesFromUser(dummyList);
    SharedPreferencesClass().updateHasAlarm(dummyList);
    SharedPreferencesClass().updateimagePathOfEachNote(dummyList);
  }
  final List<String> notesFromUser = await SharedPreferencesClass().notesFromUser();
  final List<String> titleOfNotesFromUser = await SharedPreferencesClass().titleOfNotesFromUser();
  final List<String> imagePathOfEachNote = await SharedPreferencesClass().imagePathOfEachNote();
  bool emptyAfter30Days = await SharedPreferencesClass().emptyAfter30Days();
  final List<String> dateOfNoteCreation = await SharedPreferencesClass().dateOfNoteCreation();
  final List<String> hasAlarm = await SharedPreferencesClass().hasAlarm();
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
      hasAlarm: hasAlarm,
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<String> notesFromUser;
  final List<String> titleOfNotesFromUser;
  final List<String> dateOfNoteCreation;
  final List<String> imagePathOfEachNote;
  final List<String> hasAlarm;

  final int numberOfNotes;
  final bool emptyAfter30Days;
  const MyApp({Key key, this.notesFromUser, this.numberOfNotes, this.emptyAfter30Days, this.titleOfNotesFromUser, this.dateOfNoteCreation, this.imagePathOfEachNote, this.hasAlarm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Not3s',
        // theme: ThemeData(brightness: Brightness.light),

        // A certain package needs a MaterialPageRoute
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              Provider.of<UserData>(context).notesFromUser = notesFromUser;
              Provider.of<UserData>(context).titleOfNotesFromUser = titleOfNotesFromUser;
              Provider.of<UserData>(context).emptyAfter30Days = emptyAfter30Days;
              Provider.of<UserData>(context).dateOfNoteCreation = dateOfNoteCreation;
              Provider.of<UserData>(context).imagePathOfEachNote = imagePathOfEachNote;
              Provider.of<UserData>(context).hasAlarm = hasAlarm;
              return MyHomePage();
            },
          );
        },
      ),
    );
  }
}
