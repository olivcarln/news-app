import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/models/news_articles.dart';
import 'package:news_app/screens/news_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final NewsController newsController = Get.find<NewsController>();

  var hasSearched = false.obs;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // void clearSearch() {
  //   searchController.clear();
  //   hasSearched.value = false;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search news...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    hasSearched.value = false;
                    newsController.articles.clear();
                  } else {
                    hasSearched.value = true;
                    newsController.searchNews(value);
                  }
                },
              ),
            ),
            Obx(() => hasSearched.value
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {},
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
      body: Obx(() {
        if (!hasSearched.value) {
          if (newsController.recentSearches.isEmpty) {
            return const Center(
              child: Text(
                'Start typing to search news 🔍',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: newsController.recentSearches.length,
            itemBuilder: (context, index) {
              final NewsArticles article = newsController.recentSearches[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.urlToImage ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    article.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    article.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Get.to(() => NewsDetailScreen());
                  },
                ),
              );
            },
          );
        }
        if (newsController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (newsController.searchResults.isEmpty) {
          return const Center(
            child: Text(
              'No results found.\nTry searching something else!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
         itemCount: newsController.searchResults.length,
          itemBuilder: (context, index) {
            final NewsArticles article = newsController.searchResults[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.urlToImage ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                  ),
                ),
                title: Text(
                  article.title ?? 'No Title',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  article.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  newsController.addToRecent(article); 
                 Get.to(() => NewsDetailScreen(), );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
