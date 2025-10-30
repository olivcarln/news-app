import 'package:get/get.dart';
import 'package:news_app/models/news_articles.dart';
import 'package:news_app/services/news_services.dart';
import 'package:news_app/utils/constants.dart';

class NewsController extends GetxController {
  final NewsServices _newsService = NewsServices();

  // ✅ Observables
  final _isLoading = false.obs;
  final _articles = <NewsArticles>[].obs; // untuk HomeScreen
  final _trending = <NewsArticles>[].obs;
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;

  var hoveredCategory = "".obs;
  var selectedIndex = 0.obs;

  // ✅ Tambahan baru untuk SearchScreen
  var searchResults = <NewsArticles>[].obs;
  var recentSearches = <NewsArticles>[].obs;

  // ✅ Getters
  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  List<NewsArticles> get trending => _trending;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  List<NewsArticles> get trendingArticles {
    final count = articles.length >= 5 ? 5 : articles.length;
    return articles.take(count).toList();
  }

  List<NewsArticles> get nonTrendingArticles {
    final count = trendingArticles.length;
    return articles.skip(count).toList();
  }

  
  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  // ✅ Navigation
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  // ✅ Fetch berita utama
  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.assignAll(response.articles);
      _trending.assignAll(
        response.articles
            .where((article) =>
                article.urlToImage != null && article.urlToImage!.isNotEmpty)
            .take(5)
            .toList(),
      );
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  //  Refresh berita
  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }

  //  Ganti kategori
  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  //  Pencarian berita
  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.searchNews(query: query);
      searchResults.assignAll(response.articles);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  //  Tambah ke pencarian terbaru
  void addToRecent(NewsArticles article) {
    if (!recentSearches.any((a) => a.title == article.title)) {
      recentSearches.insert(0, article);
    }
  }
}
