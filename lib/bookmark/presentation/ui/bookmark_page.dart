import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return WillPopScope(

      onWillPop: () async {
        selectedIndex = 0;
        return true;
      },
      child: Scaffold(
        drawer: NavDraw(),
        appBar: AppBar(title: Text('Bookmarks', style: GoogleFonts.kaushanScript(
        textStyle: const TextStyle(
        fontSize: 18,
            fontWeight: FontWeight.bold),
        ),),),
        body: ValueListenableBuilder<Box<Bookmark>>(
          valueListenable: Boxes.getBookmarks().listenable(),
          builder: (context, box, _) {
            var items = box.values.toList();
            items.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
            // final bookmarks = box.values.where((element) => element.timeStamp.compareTo(other))

            return buildContent(items);
          },
        ),
      ),
    );
  }

  Widget buildContent(List<Bookmark> bookmarks) {
    if (bookmarks.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/no_bookmark.svg',width: 300,),
            Text('Your bookmarks will appear here',style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 18,),
            ),),
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
                        child: CachedNetworkImage(
                          imageUrl: bookmark
                              .urlToImage
                              .toString()
                              .replaceAll(
                              "h_675,pg_1,q_80,w_1200",
                              "h_100,pg_1,q_50,w_100"),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              SizedBox(height:10,width:80,child: Center(child: LinearProgressIndicator(value: downloadProgress.progress,color: NewslyThemeData.primaryColor,))),
                          errorWidget: (context, url, error) => const Icon(Icons.image_not_supported,size: 100,),
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
                            style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.access_time ,size: 16,),
                              const SizedBox(width: 5,),
                              Text("${DateFormat.yMd()
                                  .format(DateTime.parse(bookmark.publishedAt.toString()))} At ${DateFormat('HH:mm')
                                  .format(DateTime.parse(bookmark.publishedAt.toString()))}",style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 12),
                              ),)
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
