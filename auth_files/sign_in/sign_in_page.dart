import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_matching/auth_files/sign_in/sign_in_model.dart';

import 'package:provider/provider.dart';

import '../sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SignInModel>(builder: (context, model, child) {
        return Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Margin heaven',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 60,
                      width: 300,
                      child: TextFormField(
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[あ-ん]')),
                        ],
                        decoration: const InputDecoration(
                            hintText: 'メールアドレス', border: OutlineInputBorder()),
                        controller: model.idController,
                      ),
                    ),
                    if (model.errorText != null)
                      Text(model.errorText!,
                          style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      width: 300,
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[あ-ん]')),
                        ],
                        obscureText: model.isSecret,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    model.isSecret = !model.isSecret;
                                  });
                                },
                                icon: Icon(model.isSecret
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            hintText: 'パスワード',
                            border: const OutlineInputBorder()),
                        controller: model.passController,
                      ),
                    ),
                    if (model.errorText1 != null)
                      Text(
                        model.errorText1!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 50),
                    SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {
                              model.trySignIn();
                            },
                            child: const Text('ログイン'))),
                    const SizedBox(height: 30),
                    const Text('または'),
                    const SizedBox(height: 30),
                    SizedBox(
                        width: 300,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                            child: const Text(
                              '新規登録はこちら',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ))),
                  ]),
            ),
            if (model.isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        );
      }),
    );
  }
}
