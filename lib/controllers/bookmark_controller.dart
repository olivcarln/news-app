import 'package:get/get.dart';
import 'package:news_app/models/news_articles.dart';

class BookmarkController extends GetxController {
  final bookmarkedArticles = <NewsArticles>[].obs;

  bool isBookmarked(NewsArticles article) {
    return bookmarkedArticles.any((a) => a.url == article.url);
  }

  bool toggleBookmark(NewsArticles article) {
    if (isBookmarked(article)) {
      bookmarkedArticles.removeWhere((a) => a.url == article.url);
      return false;
    } else {
      bookmarkedArticles.add(article);
      return true;
    }
  }
}
