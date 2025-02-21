import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'core/services/styles.dart';
import 'viewmodels/add_post_widget/add_post_widget_view_model.dart';
import 'viewmodels/local_post/local_post_bloc.dart';
import 'viewmodels/post/post_bloc.dart';

import 'models/local_post_model.dart';
import 'repositories/local_post_repository.dart';
import 'repositories/post_repository.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  Hive.registerAdapter(LocalPostModelAdapter());
  final localPostBox = await Hive.openBox<LocalPostModel>('local_posts');
  runApp(MyApp(localPostBox: localPostBox));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.localPostBox,
  });

  final Box<LocalPostModel> localPostBox;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(
            client: http.Client(),
          ),
        ),
        RepositoryProvider<LocalPostRepository>(
          create: (context) => LocalPostRepository(localPostBox),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider<LocalPostBloc>(
            create: (context) => LocalPostBloc(
              localPostRepository: context.read<LocalPostRepository>(),
            ),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<AddPostWidgetViewModel>(
              create: (context) => AddPostWidgetViewModel(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Styles.kPrimaryBlue),
              useMaterial3: true,
              textTheme: TextTheme(
                titleLarge: Styles.titleLarge,
                titleMedium: Styles.titleMedium,
                titleSmall: Styles.titleSmall,
                bodyLarge: Styles.bodyLarge,
                bodyMedium: Styles.bodyMedium,
                bodySmall: Styles.bodySmall,
              ),
            ),
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}
