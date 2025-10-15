import 'package:get/get.dart';
import 'package:news_app/models/news_articles.dart';
import 'package:news_app/services/news_services.dart';
import 'package:news_app/utils/constants.dart';

class NewsController extends GetxController {
  // untuk memproses request yang sudh dibuat oleh NewsServices
  final NewsServices _newsService = NewsServices();

  // Observable variables (variable yang bisa berubah)
  final _isLoading = false.obs; //apakah aplikasi sedang memuat berita
  final _articles = <NewsArticles>[].obs; //untuk menampilkan daftar berita 
  final _selectedCategory = 'general'.obs; // untuk handle kategori yang sedang dipilkihj (yang akan muncul dihome screen)
  final _error = ''.obs; //kalau ada kesalahn pesan error akan disimpan disini

  // Getters
  // getter ini seperti jendela untuk melihat isi variabel tadi
  //dengan ini, UI bisa dengan mudah melihat data dari controller 
  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;
 @override

  // begitu aplikasi dibuk aplikasi langsung menampilkan berita utama dari 
  //endpoint top-headlines
  //TODO: Fetching data dri endpoint top-headlines
 
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  Future<void> fetchTopHeadlines({String? category}) async {
    // blok ini akan dijalankan ketika REST API berhasil berkomunikasi dengan server 
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      // finally akan diexecute setelah salah satu dari blok try atau catch sudah berhasil mendapatklan hasil
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}