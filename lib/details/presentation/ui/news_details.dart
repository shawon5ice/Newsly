import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final news = ModalRoute.of(context)!.settings.arguments as NewsDetails;
    image = news.urlToImage.toString();
    author = news.author.toString();
    title = news.title.toString();
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
                  Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(publishedAt))+" On "+DateFormat.HOUR_MINUTE_GENERIC_TZ)
                ],),
                Image.network(
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  image,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
