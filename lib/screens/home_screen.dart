import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/screens/components/bottom_nav_bar.dart';
import 'package:news_app/screens/components/news_card.dart';
import 'package:news_app/screens/components/trending_news_card.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

final newsController = Get.find<NewsController>();

class HomeScreen extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Taptalk',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
         IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        Get.to(() => SearchScreen());
      },
    ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 1.0),
        ),
      ),

      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (controller.selectedCategory.toLowerCase() == "general")
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Trending News",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: controller.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : controller.trendingArticles.isEmpty
                            ? Center(child: Text("No trending news yet"))
                            : PageView.builder(
                                controller: PageController(
                                  viewportFraction: 0.9,
                                ),
                                itemCount: controller.trendingArticles.length,
                                itemBuilder: (context, index) {
                                  final article =
                                      controller.trendingArticles[index];
                                  return TrendingNewsCard(
                                    article: article,
                                    onTap: () => Get.toNamed(
                                      Routes.NEWS_DETAIL,
                                      arguments: article,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),

              Container(
                height: 50,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];

                    final isSelected = controller.selectedCategory == category;

                    return GestureDetector(
                      onTap: () => controller.selectCategory(category),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.capitalize ?? category,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.bold : null,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey[700],
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              margin: EdgeInsets.only(top: 4),
                              height: 2,
                              width: isSelected ? 20 : 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (controller.isLoading)
                LoadingShimmer()
              else if (controller.error.isNotEmpty)
                _buildErrorWidget()
              else if (controller.nonTrendingArticles.isEmpty)
                _buildEmptyWidget()
              else
                ...controller.nonTrendingArticles.map((article) {
                  return NewsListCard(
                    article: article,
                    onTap: () =>
                        Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
                  );
                }).toList(),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavBar(
          selectedIndex: newsController.selectedIndex.value,
          onItemTapped: (index) {
            newsController.onItemTapped(index);
            if (index == 1) {
              Get.offAllNamed('/bookmark');
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshNews,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search News'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Enter search term...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}
