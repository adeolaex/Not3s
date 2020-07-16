import 'package:flutter/material.dart';

//Stores the UserData gotten from the phone's storage with the help of https://pub.dev/packages/shared_preferences
//The data can then be accessed from anywhere within the application, updated and finally
//stored back into the phone's storage.

class UserData with ChangeNotifier {
  List<String> notesFromUser;
  List<String> titleOfNotesFromUser;
  List<String> dateOfNoteCreation;
  List<String> imagePathOfEachNote;
  bool emptyAfter30Days;
  List<String> notesInBin;
  List<String> flaggedNotes;
  List<String> hiddenNotes;
}
