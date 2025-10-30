import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/screens/components/bottom_nav_bar.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/utils/app_colors.dart';
import 'news_detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  final BookmarkController bookmarkController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
     leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.black),
  onPressed: () => Get.offAll(() => HomeScreen()), 
),
      ),
      body: Obx(() {
        final bookmarks = bookmarkController.bookmarkedArticles;

        if (bookmarks.isEmpty) {
          return Center(
            child: Text(
              '',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final article = bookmarks[index];

            return GestureDetector(
              onTap: () {
        Get.to(() => NewsDetailScreen());
      },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.urlToImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          article.urlToImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.source?.name ?? "Unknown Source",
                            style: TextStyle(
                              color: Colors.brown[700],
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(height: 4),

                          Text(
                            article.title ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),

                          Text(
                            article.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
            

                              GestureDetector(
                                onTap: () {
                                  bookmarkController.toggleBookmark(article);
                                  Get.snackbar(
                                    "Removed",
                                    "Article removed from bookmarks ",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white,
                                    colorText: Colors.black87,
                                    margin: EdgeInsets.all(12),
                                    duration: Duration(seconds: 2),
                                  );
                                },
                                child: Icon(
                    
                                  Icons.bookmark_remove_rounded,
                                  size: 20,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
 
    );
    
  }
}
