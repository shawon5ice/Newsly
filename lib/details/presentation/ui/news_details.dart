import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';
import 'package:newsly/core/utils/constants.dart';
import 'package:newsly/details/data/model/news_details_model.dart';
import 'package:webviewx/webviewx.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({Key? key}) : super(key: key);

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late String image;
  late String title;
  late String author;
  late String publishedAt;
  late String description;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final news = ModalRoute.of(context)!.settings.arguments as NewsDetails;
    image = news.urlToImage.toString();
    author = news.author.toString();
    title = news.title.toString();
    description= news.description.toString();
    publishedAt = news.publishedAt.toString();
  }

  final GlobalKey webViewKey = GlobalKey();

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
        title: Text('By $author'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 10),
                    FaIcon(FontAwesomeIcons.clock),
                    SizedBox(width: 10),
                    Text(
                        DateFormat.yMMMd().format(DateTime.parse(publishedAt)) +
                            " At " +
                            DateFormat('hh:mm a')
                                .format(DateTime.parse(publishedAt)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Hero(
                      tag: image,
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
                        image,
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
                            onTap: () {},
                            child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  bookMarkDone,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: FaIcon(FontAwesomeIcons.share,size: 40,color: Color(0xff80a0b5),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                _buildWebViewX(),
                ])
    )
    )));
  }
}
Widget _buildWebViewX() {
  late WebViewXController webviewController;
  final initialContent =
      '<h4> This is some hardcoded HTML code embedded inside the webview <h4> <h2> Hello world! <h2>';
  final executeJsErrorMessage =
      'Failed to execute this task because the current content is (probably) URL that allows iframe embedding, on Web.\n\n'
      'A short reason for this is that, when a normal URL is embedded in the iframe, you do not actually own that content so you cant call your custom functions\n'
      '(read the documentation to find out why).';
  return WebViewX(
    key: const ValueKey('webviewx'),
    initialContent: initialContent,
    initialSourceType: SourceType.html,
    height: 320.h,
    width: min(360.w * 0.8, 1024),
    onWebViewCreated: (controller) => webviewController = controller,
    onPageStarted: (src) =>
        debugPrint('A new page has started loading: $src\n'),
    onPageFinished: (src) =>
        debugPrint('The page has finished loading: $src\n'),
    jsContent: const {
      EmbeddedJsContent(
        js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
      ),
      EmbeddedJsContent(
        webJs:
        "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
        mobileJs:
        "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
      ),
    },
    // dartCallBacks: {
    //   DartCallback(
    //     name: 'TestDartCallback',
    //     callBack: (msg) => showSnackBar(msg.toString(), context),
    //   )
    // },
    webSpecificParams: const WebSpecificParams(
      printDebugInfo: true,
    ),
    mobileSpecificParams: const MobileSpecificParams(
      androidEnableHybridComposition: true,
    ),
    navigationDelegate: (navigation) {
      debugPrint(navigation.content.sourceType.toString());
      return NavigationDecision.navigate;
    },
  );
}