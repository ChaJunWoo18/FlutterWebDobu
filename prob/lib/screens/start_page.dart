import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:prob/api/login.dart';
import 'package:prob/widgets/sign_button.dart';
import 'package:prob/widgets/signup_form.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
            const Expanded(
              flex: 2,
              child: LoginForm(),
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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFailed = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future<void> login(String email, String password) async {
      try {
        final tokenData = await Login.getToken(email, password);
        final token = tokenData['access_token'] as String;

        // Provider에 토큰 set
        authProvider.setToken(token);
        Navigator.pushReplacementNamed(
          context,
          "/home",
        );
      } catch (e) {
        //print('Error: $e');
        setState(() {
          isFailed = true;
        });
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isFailed
            ? const Text(
                "잘못된 아이디 또는 비밀번호입니다.",
                style: TextStyle(color: Colors.red, fontSize: 15),
              )
            : const SizedBox.shrink(), // Placeholder widget
        const SizedBox(height: 10),
        // 아이디 입력 박스
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '아이디',
          ),
        ),
        const SizedBox(height: 15),
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
        SignButton(
          text: '로그인',
          onPressed: () {
            final String email = emailController.text;
            final String password = passwordController.text;
            login(email, password);
          },
        ),
        const SizedBox(height: 10), // 버튼 사이의 간격
        SignButton(
          text: '회원가입',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // 모달이 화면을 꽉 채우도록 설정
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const SignupForm(),
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 20),

        // 아이디 찾기, 비밀번호 찾기 텍스트
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     TextButton(
        //       onPressed: () {
        //         // 아이디 찾기 클릭 시 동작
        //       },
        //       child: const Text('아이디 찾기'),
        //     ),
        //     const Text(' | '),
        //     TextButton(
        //       onPressed: () {},
        //       child: const Text('비밀번호 찾기'),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
