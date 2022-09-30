import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/presentation/bloc/home_bloc.dart';
import 'package:newsly/home/presentation/bloc/home_event.dart';
import 'package:newsly/home/presentation/bloc/home_state.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../../core/widgets/pager_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;
  var currentPage = 1;
  var lastPage = 1;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const FetchNewsEventFixedNumber(1));

    super.initState();
  }
  @override
  void didChangeDependencies() {
    setState(() {
      lastPage = _homeBloc.lastPage==null?3:_homeBloc.lastPage;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPageNumber = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsly app"),
      ),
      body: Column(children: [
        NumberPagination(
          controlButton: Card(
            elevation: 5,
            color: Colors.white,
          ),
          threshold: 4,
          onPageChanged: (int pageNumber) {
            //do somthing for selected page
            setState(() {
              selectedPageNumber = pageNumber;
              _homeBloc.add(FetchNewsEventFixedNumber(selectedPageNumber));
            });
          },
          pageTotal: lastPage,
          pageInit: selectedPageNumber,
          // picked number when init page
          colorPrimary: Colors.deepPurple,
          colorSub: Colors.white,
        ),
        BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is FetchNewsStateFixedNumber) {
            return Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.articles[index].title.toString()),
                    subtitle: Text(state.articles[index].content.toString()),
                  );
                },
                    itemCount: 10,
                    )
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
      ]),
    );
  }
}
