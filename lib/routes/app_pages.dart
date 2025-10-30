import 'package:get/get.dart';
import 'package:news_app/bindings/app_bindings.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/news_detail_screen.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/screens/splash_screen.dart';

part 'app_routes.dart';


class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH, 
      page: () => SplashScreen(),
      ),
    GetPage(
      name: _Paths.HOME, 
      page: () => HomeScreen(),
      binding: AppBindings(),
      ),
    GetPage(
      name: _Paths.NEWS_DETAIL, 
  page: () => NewsDetailScreen(),
      ),
      GetPage(
        name: _Paths.BOOKMARK, 
        page: () => BookmarkScreen(),
        ),
      GetPage(
        name: _Paths.SEARCH, 
        page: () => SearchScreen(),
        ),
  ];
}