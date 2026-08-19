import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistProvider extends ChangeNotifier{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> addGift(String title, String productLink, String imageUrl) async{
    try{
      final userId = _auth.currentUser!.uid;

      await _db.collection("users").doc(userId).collection("wishlist").add({
        "title": title,
        "link": productLink,
        "imageUrl": imageUrl,
        "reservedBy": null,
        "createdAt": FieldValue.serverTimestamp()
      });
    } catch(e){
      print("Error while adding: $e");
    }
  }
}