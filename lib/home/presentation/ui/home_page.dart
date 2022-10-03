import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/details/presentation/ui/news_details.dart';
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
  var lastPage = 3;
  String dropdownvalue = 'popularity';

  // List of items in our dropdown menu
  var items = [
    'popularity',
    'relevancy',
    'publishedAt',
  ];

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const FetchNewsEventFixedNumber(1));
    _homeBloc.stream.listen((state) {

    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPageNumber = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsly app"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    _homeBloc.sortBy = dropdownvalue;
                    _homeBloc.add(FetchNewsEventFixedNumber(1));
                  });
                },
              ),
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is FetchNewsStateFixedNumber) {
              lastPage = state.totalArticles % 10 != 0
                  ? ((state.totalArticles / 10) + 1).toInt()
                  : state.totalArticles ~/ 10;
              if(!(lastPage<=100)){
                lastPage = 100;
              }
              var articles = state.articles;
              return Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetails()));
                    },
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Image.network(
                              articles[index].urlToImage.toString().replaceAll("h_675,pg_1,q_80,w_1200", "h_80,pg_1,q_50,w_140"),
                              width: 160,
                              height: 80,
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Column(children: [
                                Text(
                                  maxLines:2,
                                  overflow: TextOverflow.ellipsis,
                                  articles[index].title.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(articles[index].content!,
                                    maxLines:3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle()),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: state.articles.length,
              ));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
        ]),
      ),
    );
  }
}
