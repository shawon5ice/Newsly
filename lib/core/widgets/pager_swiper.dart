import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef PagerWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class PagerSwiper<T> extends StatelessWidget {
  final PagerWidgetBuilder<T> itemBuilder;
  final List<T> items;
  final bool isLoading;
  final _scrollController = ScrollController();
  final Function(List<T>, int) onNewLoad;
  final Function(bool) onHideFab;
  final int totalPage;
  final int totalSize;
  final int itemPerPage;

  PagerSwiper({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.isLoading,
    required this.onNewLoad,
    required this.totalPage,
    required this.totalSize,
    required this.itemPerPage,
    required this.onHideFab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      // if loader is visible then previous execution is not completed
      // or duplicate execution is about to happen
      // so we stop it by return
      // also if total page is 1 or total size is less equal item per page
      // so we don't need to call newLoad any more
      if (isLoading || totalPage == 1 || totalSize <= itemPerPage) return;

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // hide the fab when list is scrolling down
        onHideFab(true);
      } else {
        // show the fab when list scrolling idle or forward
        onHideFab(false);
      }

      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels > 0) {
        // this condition will be execute when you are in bottom of the list
        // then callback function will be trigger which we pass through parameter
        // will be execute for loading more data
        int newLength = totalSize % itemPerPage == 0
            ? (totalSize - 1) - items.length
            : totalSize - items.length;
        if (newLength > itemPerPage) {
          int nextPage = totalPage - (newLength / itemPerPage).floor();
          onNewLoad(items, nextPage);
        } else {
          if (newLength <= 0) return;
          onNewLoad(items, totalPage);
        }
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          flex: 1,
          child: Swiper(
            itemBuilder: (context, index) {
              return itemBuilder(context, items[index]);
            },
            itemWidth: 300.w,
            itemHeight: 300.h,
            itemCount: items.length,
            layout: SwiperLayout.STACK,
          ),
        ),
        isLoading
            ? Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: CircularProgressIndicator(),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      TextSpan(
                          text: "Loading",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black45,
                          )),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
