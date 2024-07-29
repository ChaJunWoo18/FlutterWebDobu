import 'package:flutter/material.dart';
import 'package:prob/model/user_model.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../api/login.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context);

    Future<void> login(String email, String password) async {
      try {
        UserModel user = await Login.loginUser(email, password);
        userProvider.setUser(user);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print('Login failed: $e');
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo_dobu.png',
                    width: 250, // 필요에 따라 크기를 조정
                  ),
                  const Text("돈을 모으자!"),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 아이디 입력 박스
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '아이디',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 비밀번호 입력 박스
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      final String email = emailController.text;
                      final String password = passwordController.text;
                      login(email, password);
                    },
                    child: const Text('로그인'),
                  ),
                  const SizedBox(height: 20),

                  // 아이디 찾기, 비밀번호 찾기 텍스트
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          // 아이디 찾기 클릭 시 동작
                        },
                        child: const Text('아이디 찾기'),
                      ),
                      const Text(' | '),
                      TextButton(
                        onPressed: () {},
                        child: const Text('비밀번호 찾기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(), // 빈 공간
            ),
          ],
        ),
      ),
    );
  }
}
