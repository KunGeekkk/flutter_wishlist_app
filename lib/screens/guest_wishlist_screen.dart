import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/wishlist_provider.dart';

class GuestWishlistScreen extends StatelessWidget {
  final String targetUserId;

  const GuestWishlistScreen({super.key, required this.targetUserId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Чужой вишлист")),
      body: StreamBuilder<QuerySnapshot>(
        stream: provider.getGuestGiftsStream(targetUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Список пуст или пользователя нет'));
          }

          final gifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final giftDoc = gifts[index];
              final giftData = giftDoc.data() as Map<String, dynamic>;

              final title = giftData['title'] ?? 'Без названия';
              final imageUrl = giftData['imageUrl'] ?? '';
              final reservedBy = giftData['reservedBy'];

              // Логика отображения статуса
              Widget trailingWidget;
              if (reservedBy == null) {
                trailingWidget = ElevatedButton(
                  onPressed: () {
                    // Передаем ID владельца списка и ID самого подарка (документа)
                    provider.reserveGift(targetUserId, giftDoc.id);
                  },
                  child: const Text('Забронировать'),
                );
              } else if (reservedBy == currentUserId) {
                trailingWidget = const Text('Забронировано вами', style: TextStyle(color: Colors.green));
              } else {
                trailingWidget = const Text('Занято', style: TextStyle(color: Colors.red));
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.card_giftcard, size: 50),
                  title: Text(title),
                  trailing: trailingWidget, // Та самая кнопка или текст статуса
                ),
              );
            },
          );
        },
      ),
    );
  }
}