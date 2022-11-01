import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsly/core/service/bookmark/bookmark.dart';
import 'package:newsly/core/widgets/navigation_drawer.dart';
import '../../../core/service/hive_boxes.dart';

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
          final transactions = box.values.toList().cast<Bookmark>();

          return buildContent(transactions);
        },
      ),
    );
  }

  buildContent(List<Bookmark> articles){
    if(articles.isEmpty){
      return const Center(child: Text('You don\'t have any bookmar'),);
    }else{
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // if(articles[index].urlToImage!=null && !articles[index].urlToImage!.contains(".jpg") || !articles[index].urlToImage.toString().contains(".jpeg") || !articles[index].urlToImage!.contains(".png")){
            //   return Container();
            // }
            return GestureDetector(
              child: Card(
                child: Text(articles[index].title),
              ),
            );
          },
          itemCount: articles.length,
        ),
      );
    }
    return Container();
  }
}
