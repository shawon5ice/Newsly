import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:newsly/core/utils/constants.dart';
import 'package:newsly/details/data/model/news_details_model.dart';

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(description,style: TextStyle(fontSize: 24),textAlign: TextAlign.left,),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
