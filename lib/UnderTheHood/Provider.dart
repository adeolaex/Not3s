import 'package:flutter/material.dart';

//Stores the number of notes and the actaul notes and is in charge os the state managment.
class UserData with ChangeNotifier {
  List<String> notesFromUser;
  List<String> titleOfNotesFromUser;
  bool emptyAfter30Days;
}
