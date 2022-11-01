import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsly/core/service/bookmark/bookmark.dart';
import 'package:newsly/core/widgets/navigation_drawer.dart';
import '../../../core/routes/route.dart';
import '../../../core/service/hive_boxes.dart';
import '../../../core/theme/newsly_theme_data.dart';
import '../../../details/data/model/news_details_model.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({Key? key}) : super(key: key);

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(title: const Text('Bookmarks'),),
      body: ValueListenableBuilder<Box<Bookmark>>(
        valueListenable: Boxes.getBookmarks().listenable(),
        builder: (context, box, _) {
          final bookmarks = box.values.toList().cast<Bookmark>();

          return buildContent(bookmarks);
        },
      ),
    );
  }

  Widget buildContent(List<Bookmark> bookmarks) {
    if (bookmarks.isEmpty) {
      return const Center(
        child: Text(
          'No Bookmarks yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 24),
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
                content: bookmark.content
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(10)),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     offset: Offset(0.0, 1.0), //(x,y)
          //     blurRadius: 5.0,
          //   ),
          // ],
        ),
        child: Stack(
          children: [
            Container(
              width: 10,
              height: 50,
              decoration: BoxDecoration(
                  color: NewslyThemeData.borderCornerColor,
                  borderRadius: BorderRadius.all(
                      Radius.circular(50))
              ),
            ),
            Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                  color: NewslyThemeData.borderCornerColor,
                  borderRadius: BorderRadius.all(
                      Radius.circular(50))
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                // color: Colors.deepOrange,
                // borderRadius: BorderRadius.vertical(
                //     top: Radius.circular(
                //       20.0,
                //     ),
                //     bottom: Radius.circular(20)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color(0xff969696),
                //     offset: Offset(0.0, 1.0), //(x,y)
                //     blurRadius: 4.0,
                //   ),
                // ],
              ),
              padding: EdgeInsets.all(10),
              height: 120,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10.0),
                    child: Hero(
                      tag: bookmark
                          .urlToImage.toString(),
                      child: Image.network(
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Text('Opps!!!');
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
                            Text(bookmark
                                .publishedAt
                                .toString())
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
              child: Container(
                decoration: BoxDecoration(
                    color: NewslyThemeData.borderCornerColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(50))
                ),
                width: 10,
                height: 50,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: NewslyThemeData.borderCornerColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(50))
                ),
                width: 50,
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
