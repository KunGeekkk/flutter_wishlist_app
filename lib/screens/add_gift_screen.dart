import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/wishlist_provider.dart';

// Если нужно переходить на другие экраны, их тоже нужно импортировать сюда
// import 'home_screen.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen({
    super.key,
  });
  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final titleController = TextEditingController();
  final linkController = TextEditingController();
  final imageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Wish List")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            SizedBox(height: 16),
            TextField(controller: linkController, decoration: const InputDecoration(labelText: "Link")),
            SizedBox(height: 16),
            TextField(controller: imageController, decoration: const InputDecoration(labelText: "Image")),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text;
                final productLink = linkController.text;
                final imageUrl = imageController.text;
                final provider = Provider.of<WishlistProvider>(context, listen:false);
                await provider.addGift(title, productLink, imageUrl);

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),

    );
  }
}
