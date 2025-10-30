import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/models/news_articles.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailScreen extends StatelessWidget {
  final NewsArticles article = Get.arguments as NewsArticles;
  final BookmarkController bookmarkController = Get.put(BookmarkController());

  NewsDetailScreen({super.key});

  String cleanHtml(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]+>', multiLine: true, caseSensitive: false);
    var cleaned = htmlString.replaceAll(exp, ' ').trim();

    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    cleaned = cleaned.replaceAll('. ', '.\n\n'); 

    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? '',
            height: 380,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.divider,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.divider,
              child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
            ),
          ),

          Container(
            height: 380,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBlurIcon(icon: Icons.arrow_back, onTap: () => Get.back()),
                  Row(
                    children: [
                      Obx(() {
                        final isBookmarked = bookmarkController.isBookmarked(article);
                        return _buildBlurIcon(
                          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.brown[900]! : Colors.white,
                          onTap: () {
                            final isNowBookmarked = bookmarkController.toggleBookmark(article);
                            Get.snackbar(
                              isNowBookmarked ? 'Added to Bookmarks' : 'Removed from Bookmarks',
                              isNowBookmarked ? 'Article saved successfully.' : 'Article removed.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black.withOpacity(0.8),
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(12),
                              borderRadius: 12,
                              duration: const Duration(seconds: 2),
                            );
                          },
                        );
                      }),
                      const SizedBox(width: 10),
                      _buildBlurIcon(icon: Icons.share, onTap: _shareArticle),
                      const SizedBox(width: 10),
                      _buildBlurIcon(
                        icon: Icons.more_vert,
                        onTap: () {
                          showMenu(
                            context: context,
                            position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
                            items: [
                              PopupMenuItem(
                                value: 'copy_link',
                                child: const Text('Copy Link'),
                                onTap: _copyLink,
                              ),
                              PopupMenuItem(
                                value: 'open_browser',
                                child: const Text('Open in Browser'),
                                onTap: _openInBrowser,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -3)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (article.source?.name != null)
                            Text(
                              article.source!.name!,
                              style: const TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                              ),
                            ),
                          const SizedBox(width: 12),
                          if (article.publishedAt != null)
                            Text(
                              timeago.format(DateTime.parse(article.publishedAt!)),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),


                      Text(
                        article.title ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),

   
                      if (article.description != null)
                        Text(
                          cleanHtml(article.description!),
                          style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                        ),
                      const SizedBox(height: 20),

                      if (article.content != null) ...[
                        const Text(
                          'Content',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cleanHtml(article.content!),
                          style: const TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (article.url != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openInBrowser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Read full article',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBlurIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check out this news'}\n\n${article.url}',
        subject: article.title,
      );
    }
  }

  void _copyLink() {
    if (article.url == null) return;
    Clipboard.setData(ClipboardData(text: article.url!));
    Get.snackbar(
      'Success',
      'Link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'ERROR',
          "Couldn't open the link",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
