import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:newsly/core/service/bookmark/bookmark.dart';
import 'package:newsly/core/widgets/navigation_drawer.dart';
import '../../../core/routes/route.dart';
import '../../../core/service/hive_boxes.dart';
import '../../../core/theme/newsly_theme_data.dart';
import '../../../details/data/model/news_details_model.dart';
import '../../../home/presentation/widget/corner_widget.dart';

class BookMarkPage extends StatelessWidget {
  const BookMarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDraw(),
      appBar: AppBar(title: const Text('Bookmarks'),),
      body: ValueListenableBuilder<Box<Bookmark>>(
        valueListenable: Boxes.getBookmarks().listenable(),
        builder: (context, box, _) {
          var items = box.values.toList();
          items.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
          // final bookmarks = box.values.where((element) => element.timeStamp.compareTo(other))

          return buildContent(items);
        },
      ),
    );
  }

  Widget buildContent(List<Bookmark> bookmarks) {
    if (bookmarks.isEmpty) {
      return Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/svg/no_bookmark.svg'),
            Text('Your bookmarks will appear here'),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                final bookmark = bookmarks[index];

                return buildBookmark(context, bookmark);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildBookmark(
      BuildContext context,
      Bookmark bookmark,
      ) {

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(newsDetails,
            arguments: NewsDetails(
                title: bookmark.title,
                description: bookmark.description,
                author: bookmark.author,
                publishedAt: bookmark.publishedAt,
                url: bookmark.url,
                urlToImage: bookmark.urlToImage,
                sourceName: bookmark.source,
                content: bookmark.content));
      },
      child: Card(
        elevation: 10,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            children: [
              CornerWidget(horizontal: true),
              CornerWidget(horizontal: false),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5),
                padding: const EdgeInsets.all(10),
                height: 120,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(10.0),
                      child: Hero(
                        tag: bookmark
                            .urlToImage
                            .toString(),
                        child: Image.network(
                          errorBuilder: (BuildContext context,
                              Object exception,
                              StackTrace? stackTrace) {
                            return const Text('Opps!!!');
                          },
                          bookmark
                              .urlToImage
                              .toString()
                              .replaceAll(
                              "h_675,pg_1,q_80,w_1200",
                              "h_100,pg_1,q_50,w_100"),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            bookmark.title.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.rotate(
                                angle: 45,
                                child: Icon(Icons.link),
                              ),
                              Text(DateFormat.yMd()
                                  .format(DateTime.parse(bookmark.publishedAt.toString())) +
                                  " At " +
                                  DateFormat('HH:mm')
                                      .format(DateTime.parse(bookmark.publishedAt.toString())))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: CornerWidget(horizontal: false,)
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CornerWidget(horizontal: true,),)
            ],
          ),
        ),
      ),
    );
  }
}
