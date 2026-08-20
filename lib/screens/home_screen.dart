import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/wishlist_provider.dart';
import 'package:untitled1/screens/add_gift_screen.dart';

// Если нужно переходить на другие экраны, их тоже нужно импортировать сюда
// import 'home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Это конструктор, пока просто пишем его так

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<WishlistProvider>(context, listen:false);

    return Scaffold(
      appBar: AppBar(title: const Text("My Wish List")),
      body:StreamBuilder<QuerySnapshot>(
        stream: provider.getGiftsStream(),
        builder: (context, snapshot){
          // 1. Проверяем состояние загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Крутилка
          }

          // 2. Обрабатываем возможные ошибки базы
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3. Проверяем, есть ли вообще данные
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Список пуст. Добавьте первый подарок!'));
          }

          // 4. Если всё ок, вытаскиваем массив документов
          final gifts = snapshot.data!.docs;

          // Здесь мы будем возвращать список
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              // Достаем конкретный документ и кастуем его в Map (словарь)
              final giftData = gifts[index].data() as Map<String, dynamic>;

              // Безопасно достаем значения, используя fallback-значения на случай null
              final title = giftData['title'] ?? 'Без названия';
              final imageUrl = giftData['imageUrl'] ?? '';
              final link = giftData['link'] ?? '';

              // Card - это готовый виджет карточки с тенями и скруглениями
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  // Отрисовка картинки по ссылке
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.card_giftcard, size: 50),
                  title: Text(title),
                  subtitle: Text(link, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGiftScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
