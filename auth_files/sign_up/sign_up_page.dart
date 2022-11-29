import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_matching/auth_files/sign_up/sign_up_model.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Consumer<SignUpModel>(builder: (context, model, child) {
        return Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    const Text(
                      'メールアドレスでアカウント作成',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
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
                        controller: model.mailController,
                      ),
                    ),
                    if (model.errorText1 != null)
                      Text(
                        model.errorText1!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 60,
                      width: 300,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 12,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
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
                    if (model.errorText != null)
                      Text(
                        model.errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 30),
                    SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {
                              model.trySignUp(context);
                            },
                            child: const Text(
                              '次へ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ))),
                  ]),
            ),
            if (model.isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}
