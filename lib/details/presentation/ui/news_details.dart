import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsly/core/logger/logger.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';
import 'package:newsly/core/utils/constants.dart';
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

    var _bookmarkCheck = box.values
        .where((element) => news.publishedAt == element.publishedAt)
        .isNotEmpty;

    if (_bookmarkCheck) {
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
                padding: EdgeInsets.all(8),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                    child: Text(
                      news.title.toString(),
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      FaIcon(
                        FontAwesomeIcons.clock,
                        color: NewslyThemeData.primaryColor,
                      ),
                      SizedBox(width: 10),
                      Text(DateFormat.yMMMd()
                              .format(DateTime.parse(news.publishedAt.toString())) +
                          " At " +
                          DateFormat('hh:mm a')
                              .format(DateTime.parse(news.publishedAt.toString())))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Hero(
                        tag: news.urlToImage.toString(),
                        child: Image.network(
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          news.urlToImage.toString(),
                          height: 300,
                          fit: BoxFit.cover,
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
                                  var _task = box.values
                                      .where((element) =>
                                          news.publishedAt == element.publishedAt)
                                      .first;
                                  _task.delete();
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
                                  padding: EdgeInsets.all(10),
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
                                child: Padding(
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
              WebView(
                initialUrl: news.url,
              )
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
    ;

    box.add(bookmark);
    logger.printDebugLog("Bookmarked...");
  }

  void deleteBookMark(Bookmark bookmark) {
    bookmark.delete();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  _onShare(String text) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      text,
      subject: "Share this news...",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
