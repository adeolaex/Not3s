import 'package:flutter/material.dart';

//Stores the number of notes and the actaul notes and is in charge os the state managment.
class UserData with ChangeNotifier {
  int numberOfNotes;
  List<List<String>> notesFromUser = [];
  bool emptyAfter30Days;
  String titleToTrack;
  String noteToTrack;
}
