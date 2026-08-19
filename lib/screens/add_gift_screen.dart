import 'package:flutter/material.dart';

// Если нужно переходить на другие экраны, их тоже нужно импортировать сюда
// import 'home_screen.dart';

class AddGiftScreen extends StatelessWidget {
  const AddGiftScreen({
    super.key,
  }); // Это конструктор, пока просто пишем его так

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(),
            SizedBox(height: 16),
            TextField(),
            SizedBox(height: 16),
            TextField(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text("My Wish List")),
    );
  }
}
