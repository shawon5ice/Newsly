import 'package:hive/hive.dart';
part 'bookmark.g.dart';

@HiveType(typeId: 0)
class Bookmark extends HiveObject{
  @HiveField(0)
  late String source;

  @HiveField(1)
  late String author;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String url;

  @HiveField(5)
  late String urlToImage;

  @HiveField(6)
  late String publishedAt;

  @HiveField(7)
  late String content;
}