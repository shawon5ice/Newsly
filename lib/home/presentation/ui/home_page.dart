import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/presentation/bloc/home_bloc.dart';
import 'package:newsly/home/presentation/bloc/home_event.dart';
import 'package:newsly/home/presentation/bloc/home_state.dart';

import '../../../core/widgets/pager_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const FetchNewsEvent(1, []));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Newsly app"),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is FetchNewsSuccess) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
                    GestureDetector(
                      onTap: (){

                      },
                        child: Card(child: Container(alignment:Alignment.center, width: 30,height: 30,child: Text('1'),))),
                    GestureDetector(child: Card(child: Container(alignment:Alignment.center,width: 30,height: 30,child: Text('2'),))),
                    GestureDetector(child: Card(child: Container(alignment:Alignment.center,width: 30,height: 30,child: Text('3'),))),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward))
                  ],),
                  Expanded(
                    child: PagerListView<Articles>(
                        isLoading: _homeBloc.isLoadingMoreVisible,
                        onNewLoad: (data, nextPage) {
                          setState(() {
                            _homeBloc.isLoadingMoreVisible = true;
                          });
                          _homeBloc.add(FetchNewsEvent(
                            nextPage,
                            data,
                          ));
                        },
                        totalPage: state.totalArticles % 10 != 0
                            ? ((state.totalArticles / 10) + 1).toInt()
                            : state.totalArticles ~/ 10,
                        totalSize: state.totalArticles,
                        itemPerPage: 10,
                        items: state.articles,
                        onHideFab: (hide) {},
                        itemBuilder: (context, article) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(article.title.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                                Text(article.description.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              );
            }
            if(state is FirstPageLoading) return Center(child: CircularProgressIndicator(),);
            return CircularProgressIndicator();
          },
        ));
  }
}
