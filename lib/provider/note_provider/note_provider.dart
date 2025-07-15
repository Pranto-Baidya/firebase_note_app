import 'package:back_to_firebase/firestore/firestore.dart';
import 'package:back_to_firebase/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  List<NoteModel> _searchNotes = [];
  List<NoteModel> get searchNotes => _searchNotes;

  List<NoteModel> _filteredCategory = [];
  List<NoteModel> get filteredCategory => _filteredCategory;

  String _selectedCategory = "All";
  String get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  void setCategory(String category){
    _selectedCategory = category;
    getFilteredCategory(category);
    notifyListeners();
  }

  Future<void> getFilteredCategory(String category)async{
    if(category == 'All'){
      _filteredCategory = notes;
    }
    else{
      _filteredCategory = _notes.where((cat)=>cat.category==category).toList();
    }
    notifyListeners();
  }

  Future<void> searchForNotes(String query) async {
    if (query.isEmpty) {
      _searchNotes = _notes;
    } else {
      _searchNotes = _notes.where((note) {
        final title = note.title.toLowerCase();
        final description = note.description.toLowerCase();
        return title.contains(query.toLowerCase()) || description.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void getAllNotes(String uid) {
    _firestoreService.getAllNotes(uid).listen((data) {
      _notes = data;
      getFilteredCategory(_selectedCategory);
    });
  }

  Future<void> addNote(NoteModel note) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.addNote(note);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateNote(NoteModel note) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.updateNote(note);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteNote(String uid, String id) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.deleteNote(uid, id);
    _isLoading = false;
    notifyListeners();
  }


}
