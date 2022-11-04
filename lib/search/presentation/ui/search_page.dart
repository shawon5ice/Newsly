import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';
import 'package:newsly/core/utils/constants.dart';
import 'package:newsly/search/presentation/bloc/search_bloc.dart';
import 'package:newsly/search/presentation/bloc/search_event.dart';
import 'package:newsly/search/presentation/bloc/search_state.dart';

import '../../../core/routes/route.dart';
import '../../../core/widgets/shimmer_loader_view.dart';
import '../../../details/data/model/news_details_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool showSuggestions = true;
  late SearchBloc _searchBloc;

  @override
  void initState() {
    focusNode.addListener(_onFocusChange);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    super.initState();
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      showSuggestions = true;
    } else {
      showSuggestions = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          focusNode.unfocus();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_back_ios),
                        )),
                    Flexible(
                      child: TextField(
                        controller: _textEditingController,
                        focusNode: focusNode,
                        autofocus: true,
                        onSubmitted: (value){
                          _searchBloc.add(FetchNewsEvent(value));
                        },
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.only(bottom: 5, left: 10),
                          hintText: 'Search',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {
                                focusNode.unfocus();
                                _textEditingController.clear();
                              },
                              child: Icon(
                                size: 18,
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                showSuggestions
                    ? Wrap(
                        spacing: 10,
                        children: SearchItems.map(
                          (item) => InkWell(
                            onTap: (){
                              _textEditingController.text = item;
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: NewslyThemeData.borderCornerColor),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(item)),
                          ),
                        ).toList())
                    : SizedBox(),
                    _allNews(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _allNews() {
    return SingleChildScrollView(
      child: SizedBox(
        height: 0.90.sh,
        child: Column(
          children: [
            BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if(state is FetchNewsLoading){
                return ShimmerLoaderView(true);
              }
              if (state is FetchNewsSuccess) {
                var articles = state.articles!;
                if(articles.length==0){
                  return SizedBox(
                    height: 1.sh,
                      child: Center(child: Text("Opps!,something wen wrong"),));
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(newsDetails,
                              arguments: NewsDetails(
                                  title: articles[index].title,
                                  description: articles[index].description,
                                  author: articles[index].author,
                                  publishedAt: articles[index].publishedAt,
                                  url: articles[index].url,
                                  urlToImage: articles[index].urlToImage,
                                  sourceName: articles[index].source!.name,
                                  content: articles[index].content));
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
                                Container(
                                  width: 10,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: NewslyThemeData.borderCornerColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                                Container(
                                  width: 50,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      color: NewslyThemeData.borderCornerColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
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
                                          tag: articles[index]
                                              .urlToImage
                                              .toString(),
                                          child: Image.network(
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return const Text('Opps!!!');
                                            },
                                            articles[index]
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
                                              articles[index].title.toString(),
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
                                                Text(articles[index]
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
                                    decoration: const BoxDecoration(
                                        color:
                                        NewslyThemeData.borderCornerColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    width: 10,
                                    height: 50,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                        NewslyThemeData.borderCornerColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    width: 50,
                                    height: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.articles!.length,
                  ),
                );
              }
              if(state is FetchNewsFailed){
                return Center(child: Text('Opps! nothing found'),);
              }
              if(state is FetchNewsLoading){
                return Expanded(child: ShimmerLoaderView(true));
              }
              return const Expanded(child: SizedBox(),);
            }),
          ],
        ),
      ),
    );
  }
}
