import 'package:hive/hive.dart';
import 'package:newsly/core/service/bookmark/bookmark.dart';


class Boxes {
  static Box<Bookmark> getBookmarks() =>
      Hive.box<Bookmark>('bookmarks');
}