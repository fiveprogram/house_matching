import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/profile.dart';
import 'edit_model.dart';

class EditPage extends StatefulWidget {
  Profile? profile;
  EditPage(this.profile, {Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditModel>(
      create: (_) => EditModel(widget.profile!),
      child: Scaffold(
        appBar: AppBar(title: const Text('プロフィールを編集')),
        body: Consumer<EditModel>(builder: (context, model, child) {
          return Stack(
            children: [
              Column(
                children: [
                  if (model.file != null)
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: FileImage(model.file!),
                    ),
                  if (model.file == null)
                    CircleAvatar(
                        radius: 64,
                        backgroundImage: widget.profile!.imgURL != ''
                            ? NetworkImage(widget.profile!.imgURL!)
                            : const NetworkImage(
                                'https://jobneta.sasamedia.net/miyashikai/wp-content/uploads/2017/02/default-avatar.png')),
                  TextButton(
                      onPressed: () {
                        model.selectPhoto(context);
                      },
                      child: const Text(
                        'プロフィール写真を変更',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 30),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Text(
                          '名前',
                          style: TextStyle(fontSize: 20),
                        )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: TextFormField(
                            controller: model.nameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Text(
                          'メール\nアドレス',
                          style: TextStyle(fontSize: 20),
                        )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: TextFormField(
                            controller: model.mailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Text(
                          '自己紹介',
                          style: TextStyle(fontSize: 20),
                        )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          child: TextFormField(
                            controller: model.selfIntroduction,
                            maxLines: 5,
                            maxLength: 150,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () {
                        model.sendProfile(context);
                      },
                      child: const Text('登録する'))
                ],
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
      ),
    );
  }
}
