
import 'package:back_to_firebase/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

 CollectionReference <Map<String, dynamic>> noteCollection(String uid){ //firestore a create kora database er reference er jonno Collection reference neya hoise
   return FirebaseFirestore.instance.collection('users').doc(uid).collection('notes'); //uid holo je account theke sign in korsi oitar unique id
 }

 Stream<List<NoteModel>> getAllNotes(String uid){
   return noteCollection(uid).snapshots().map((snapshot){  //.snapshots() holo ekta listener jeta firestore collection er live stream dei
     return snapshot.docs.map((doc)=> NoteModel.fromMap(doc.id, doc.data())).toList();
   });
}

 Future<void> addNote(NoteModel note)async{
   await noteCollection(note.uid).add({
     ...note.toMap(),
     'createdAt' : FieldValue.serverTimestamp(),
     'updatedAt': FieldValue.serverTimestamp(),
   });
 }

 Future<void> updateNote(NoteModel note)async{
   await noteCollection(note.uid).doc(note.id).update({
     ...note.toMap(),
     'createdAt': note.createdAt,
     'updatedAt': FieldValue.serverTimestamp(),
   }); //ekhane doc(id) ta holo notes subcollection er noteId ta
 }

 Future<void> deleteNote(String uid, String id)async{ // ekhane duita parameter nisi karon amader pura notemodel dorkar nai tai
   await noteCollection(uid).doc(id).delete(); //ekhane doc(id) ta holo notes subcollection er noteId ta
 }

}