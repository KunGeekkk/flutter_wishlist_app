import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistProvider extends ChangeNotifier{

  // 1. Получение потока данных ДРУГОГО пользователя
  Stream<QuerySnapshot> getGuestGiftsStream(String guestUserId) {
    return _db
        .collection('users')
        .doc(guestUserId)
        .collection('wishlist')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 2. Бронирование подарка
  Future<void> reserveGift(String targetUserId, String giftId) async {
    try {
      final currentUserId = _auth.currentUser!.uid;

      // Обновляем конкретный документ (подарок), записывая туда наш ID
      await _db
          .collection('users')
          .doc(targetUserId)
          .collection('wishlist')
          .doc(giftId)
          .update({'reservedBy': currentUserId});
    } catch (e) {
      print("Ошибка при бронировании: $e");
    }
  }

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

  Stream<QuerySnapshot> getGiftsStream(){
    final userId = _auth.currentUser!.uid;

    return _db
        .collection("users")
        .doc(userId)
        .collection("wishlist")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

}