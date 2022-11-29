import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_matching/post_files/post/post_model.dart';
import 'package:house_matching/post_files/post_detail/post_detail_model.dart';
import 'package:house_matching/post_files/post_list/post_list_model.dart';
import 'package:house_matching/post_files/register_nearest_station/register_nearest_station_model.dart';
import 'package:house_matching/time_line_files/time_line/time_line_model.dart';
import 'package:provider/provider.dart';

import 'account/account_model.dart';
import 'auth_files/sign_in/sign_in_model.dart';
import 'auth_files/sign_in/sign_in_page.dart';
import 'auth_files/sign_up/sign_up_model.dart';
import 'favorite_list/favorite_model.dart';
import 'filtered_area_search/filtered_area_model.dart';
import 'filtered_station_search/filtered_search_model.dart';
import 'filtered_station_search/only_filtering_station/only_filtering_station_model.dart';
import 'firebase_options.dart';
import 'main_select_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInModel()),
        ChangeNotifierProvider(create: (_) => SignUpModel()),
        ChangeNotifierProvider(
            create: (_) => AccountModel()
              ..fetchProfile()
              ..fetchFavorite()),
        ChangeNotifierProvider(create: (_) => PostListModel()..fetchFavorite()),
        ChangeNotifierProvider(create: (_) => PostModel()),
        ChangeNotifierProvider(create: (_) => PostDetailModel()),
        ChangeNotifierProvider(create: (_) => FavoriteModel()..fetchFavorite()),
        ChangeNotifierProvider(create: (_) => TimeLineModel()..fetchFavorite()),
        ChangeNotifierProvider(
            create: (_) => FilteredSearchModel()..fetchFavorite()),
        ChangeNotifierProvider(
            create: (_) =>
                OnlyFilteringStationModel()..trackLineJsonConvertToList()),
        ChangeNotifierProvider(
            create: (_) =>
                RegisterNearestStationModel()..trackLineConvertJson()),
        ChangeNotifierProvider(
            create: (_) => FilteredAreaModel()..fetchFavorite()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Margin heaven',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MainSelectPage();
              }
              return const SignInPage();
            }),
      ),
    );
  }
}
