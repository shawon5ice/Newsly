import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsly/core/logger/logger.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';
import 'package:newsly/details/data/model/news_details_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/service/bookmark/bookmark.dart';
import '../../../core/service/hive_boxes.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({Key? key}) : super(key: key);

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late NewsDetails news;
  late Bookmark bookmark;
  final box = Boxes.getBookmarks();

  @override
  void didChangeDependencies() {
    news = ModalRoute.of(context)!.settings.arguments as NewsDetails;

    bookmark = Bookmark()
      ..source = news.source.toString()
      ..author = news.author.toString()
      ..url = news.url.toString()
      ..publishedAt = news.publishedAt.toString()
      ..content = news.content.toString()
      ..urlToImage = news.urlToImage.toString()
      ..title = news.title.toString()
      ..description = news.description.toString();

    var bookmarkCheck = box.values
        .where((element) => news.publishedAt == element.publishedAt)
        .isNotEmpty;

    if (bookmarkCheck) {
      isBookmarked = true;
      logger.printDebugLog("true");
    }
    super.didChangeDependencies();
  }

  final GlobalKey webViewKey = GlobalKey();
  bool isBookmarked = false;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> controller = Completer<WebViewController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'By ${news.author}',
          style: GoogleFonts.kaushanScript(
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                    child: Text(
                      news.title.toString(),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.access_time ,size: 16,),
                      const SizedBox(width: 10,),
                      Text("${DateFormat.yMMMd()
                          .format(DateTime.parse(news.publishedAt.toString()))} At ${DateFormat('hh:mm a')
                          .format(DateTime.parse(news.publishedAt.toString()))}",style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 12),
                      ),)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Hero(
                        tag: news.urlToImage.toString(),
                        child: CachedNetworkImage(
                          imageUrl: news
                              .urlToImage
                              .toString()
                              .replaceAll(
                              "h_675,pg_1,q_80,w_300",
                              "w_100,pg_1,q_50,w_300"),
                          height: 250,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              SizedBox(height:10,width:80,child: Center(child: LinearProgressIndicator(value: downloadProgress.progress,color: NewslyThemeData.primaryColor,))),
                          errorWidget: (context, url, error) => const Icon(Icons.image_not_supported,size: 300,),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isBookmarked) {
                                  isBookmarked = false;
                                  var task = box.values
                                      .where((element) =>
                                          news.publishedAt == element.publishedAt)
                                      .first;
                                  task.delete();
                                } else {
                                  addBookmark(news);
                                  logger.printDebugLog("Bookmarked...");
                                  isBookmarked = true;
                                }
                                setState(() {});
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                    size: 40,
                                    color:
                                        isBookmarked ? Colors.green : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Share.share('check out this news ${news.url}',
                                    subject: 'Look what this news saying...');
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.ios_share_outlined,
                                    size: 40,
                                    color: NewslyThemeData.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      news.description.toString(),
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                color: NewslyThemeData.cardColor,
                height: 5000,
                child: WebView(
                  initialUrl: news.url,
                  javascriptMode: JavascriptMode.disabled,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller.complete(webViewController);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addBookmark(NewsDetails news) {
    final bookmark = Bookmark()
      ..source = news.source.toString()
      ..author = news.author.toString()
      ..url = news.url.toString()
      ..publishedAt = news.publishedAt.toString()
      ..content = news.content.toString()
      ..urlToImage = news.urlToImage.toString()
      ..title = news.title.toString()
      ..description = news.description.toString()
      ..timeStamp = DateTime.now().toIso8601String();

    box.add(bookmark);
    logger.printDebugLog("Bookmarked...");
  }

  void deleteBookMark(Bookmark bookmark) {
    bookmark.delete();
  }
}
