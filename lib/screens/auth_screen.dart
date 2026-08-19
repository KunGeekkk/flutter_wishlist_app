import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screens/home_screen.dart';

// Если нужно переходить на другие экраны, их тоже нужно импортировать сюда
// import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password")),
            ElevatedButton(
                onPressed: () async { // Добавили слово async
                  try {
                    // 1. Достаем текст из контроллеров в обычные переменные
                    final email = emailController.text;
                    final password = passwordController.text;

                    // 2. Просим Firebase создать пользователя
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

                    // 3. Если строчка выше выполнилась без ошибок, значит юзер создан!
                    // Перекидываем его на главный экран
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));

                  } catch (e) {
                    // Если пользователь ввел плохой email или слишком короткий пароль,
                    // программа попадет сюда, а не вылетит с ошибкой.
                    // Пока просто выведем ошибку в консоль разработчика:
                    print("Ошибка регистрации: $e");
                  }
                },
              child: const Text("Authorize"),
            ),
            ElevatedButton(
              onPressed: () async { // Добавили слово async
                try {
                  // 1. Достаем текст из контроллеров в обычные переменные
                  final email = emailController.text;
                  final password = passwordController.text;

                  // 2. Просим Firebase создать пользователя
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

                  // 3. Если строчка выше выполнилась без ошибок, значит юзер создан!
                  // Перекидываем его на главный экран
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));

                } catch (e) {
                  // Если пользователь ввел плохой email или слишком короткий пароль,
                  // программа попадет сюда, а не вылетит с ошибкой.
                  // Пока просто выведем ошибку в консоль разработчика:
                  print("Ошибка регистрации: $e");
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
