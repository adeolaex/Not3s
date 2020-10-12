import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  // This functions get the data stored in memoty
  updateFirstRun(bool firstRun) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("firstRun", firstRun);
  }

  updateNotesFromUser(List<String> notesFromUseR) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('notesFromUser', notesFromUseR);
  }

  updatetitleOfNotesFromUser(List<String> titleOfNotesFromUseR) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('titleOfNotesFromUser', titleOfNotesFromUseR);
  }

  updatedateOfNoteCreation(List<String> dateOfNoteCreation) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('dateOfNoteCreation', dateOfNoteCreation);
  }

  updateHasAlarm(List<String> hasAlarm) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('hasAlarm', hasAlarm);
  }

  updateimagePathOfEachNote(List<String> imagePathOfEachNote) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('imagePathOfEachNote', imagePathOfEachNote);
  }

  // This functions get the data in memory
  firstRun() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setStringList('notesFromUser', []);
    // This are used to reset the data stored within the storage of a device during production.
    bool notesFromUser = preferences.getBool('firstRun') ?? true;
    return notesFromUser;
  }

  notesFromUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setStringList('notesFromUser', []);
    // This are used to reset the data stored within the storage of a device during production.
    List<String> notesFromUser = preferences.getStringList('notesFromUser') ?? ['empty'];
    return notesFromUser;
  }

  titleOfNotesFromUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setStringList('titleOfNotesFromUser', []);
    // This are used to reset the data stored within the storage of a device during production.
    List<String> titleOfNotesFromUser = preferences.getStringList('titleOfNotesFromUser') ?? ['empty'];

    return titleOfNotesFromUser;
  }

  emptyAfter30Days() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setBool('emptyAfter30Days', false);
    // This are used to reset the data stored within the storage of a device during production.
    bool emptyAfter30Days = preferences.getBool('emptyAfter30Days') ?? true;
    return emptyAfter30Days;
  }

  dateOfNoteCreation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setStringList('dateOfNoteCreation', []);
    // This are used to reset the data stored within the storage of a device during production.
    List<String> dateOfNoteCreation = preferences.getStringList('dateOfNoteCreation') ?? ['empty'];
    return dateOfNoteCreation;
  }

  hasAlarm() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setStringList('notesFromUser', []);
    // This are used to reset the data stored within the storage of a device during production.
    List<String> notesFromUser = preferences.getStringList('hasAlarm') ?? ['empty'];
    return notesFromUser;
  }

  imagePathOfEachNote() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setStringList('imagePathOfEachNote', []);
    //  This are used to reset the data stored within the storage of a device during production.
    List<String> imagePathOfEachNote = preferences.getStringList('imagePathOfEachNote') ?? ['empty'];
    return imagePathOfEachNote;
  }
}
