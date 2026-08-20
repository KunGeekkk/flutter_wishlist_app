import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/wishlist_provider.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen({super.key});

  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  // 1. Ключ для управления состоянием формы (валидации)
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final linkController = TextEditingController();
  final imageController = TextEditingController();

  // 2. Флаг загрузки для блокировки интерфейса
  bool _isLoading = false;

  // 3. Очистка памяти (хорошая инженерная практика)
  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    imageController.dispose();
    super.dispose();
  }

  // 4. Логика сохранения с проверками
  Future<void> _saveGift() async {
    // Запускаем валидацию всех TextFormField
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Включаем крутилку

      try {
        final provider = Provider.of<WishlistProvider>(context, listen: false);
        await provider.addGift(
          titleController.text.trim(),
          linkController.text.trim(),
          imageController.text.trim(),
        );

        if (mounted) {
          // Показываем зеленый снэкбар успеха
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Подарок успешно добавлен!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Закрываем экран
        }
      } catch (e) {
        if (mounted) {
          // Показываем красный снэкбар с ошибкой
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при сохранении: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false); // Выключаем крутилку
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить подарок")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 5. Оборачиваем колонку в Form и передаем ей ключ
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Название (обязательно)"),
                // Правило: поле не может быть пустым
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название подарка';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: linkController,
                decoration: const InputDecoration(labelText: "Ссылка на товар (обязательно)"),
                // Правило: поле не пустое и начинается с http
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите ссылку';
                  }
                  if (!value.startsWith('http')) {
                    return 'Ссылка должна начинаться с http или https';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "Ссылка на картинку (опционально)"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  // Если идет загрузка, отключаем кнопку (передаем null)
                  onPressed: _isLoading ? null : _saveGift,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}