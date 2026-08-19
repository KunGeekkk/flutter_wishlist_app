import 'package:flutter/material.dart';
import 'package:untitled1/screens/add_gift_screen.dart';

// Если нужно переходить на другие экраны, их тоже нужно импортировать сюда
// import 'home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Это конструктор, пока просто пишем его так

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Текст на кнопке'),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text("My Wish List")),
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
