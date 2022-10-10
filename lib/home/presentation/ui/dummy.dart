// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:newsly/home/data/model/news_details_model.dart';
// import 'package:newsly/home/presentation/bloc/news_details_bloc.dart';
// import 'package:newsly/home/presentation/bloc/news_details_event.dart';
// import 'package:newsly/home/presentation/bloc/news_details_state.dart';
// import 'package:number_pagination/number_pagination.dart';
//
// import '../../../core/widgets/pager_list_view.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late HomeBloc _homeBloc;
//   var currentPage = 1;
//
//   @override
//   void initState() {
//     _homeBloc = BlocProvider.of<HomeBloc>(context);
//     _homeBloc.add(const FetchNewsEventFixedNumber(1));
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var selectedPageNumber = 1;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Newsly app"),
//       ),
//       body: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, state) {
//           if (state is FetchNewsSuccess) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: PagerListView<Articles>(
//                     isLoading: _homeBloc.isLoadingMoreVisible,
//                     onNewLoad: (data, nextPage) {
//                       currentPage = nextPage - 1;
//                       setState(() {
//                         _homeBloc.isLoadingMoreVisible = true;
//                       });
//                       _homeBloc.add(FetchNewsEvent(
//                         nextPage,
//                         data,
//                       ));
//                     },
//                     totalPage: state.totalArticles % 10 != 0
//                         ? ((state.totalArticles / 10) + 1).toInt()
//                         : state.totalArticles ~/ 10,
//                     totalSize: state.totalArticles,
//                     itemPerPage: 10,
//                     items: state.articles,
//                     onHideFab: (hide) {},
//                     itemBuilder: (context, article) => Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Text(
//                               article.title.toString(),
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w700),
//                             ),
//                             Text(
//                               article.description.toString(),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//
//           return Column(
//             children: [
//           NumberPagination(
//           controlButton: Card(
//           elevation: 5,
//             color: Colors.white,
//           ),
//           threshold: 4,
//           onPageChanged: (int pageNumber) {
//           //do somthing for selected page
//           setState(() {
//           selectedPageNumber = pageNumber;
//           _homeBloc.add(FetchNewsEventFixedNumber(selectedPageNumber));
//           });
//           },
//           pageTotal: lastPage,
//           pageInit: selectedPageNumber,
//           // picked number when init page
//           colorPrimary: Colors.deepPurple,
//           colorSub: Colors.white,
//           ),
//           if(state is FetchNewsStateFixedNumber){
//           int lastPage = state.totalArticles % 10 != 0
//           ? ((state.totalArticles / 10) + 1).toInt()
//               : state.totalArticles ~/ 10;
//           Expanded(
//           child: ListView.builder(
//           itemCount: 10,
//           shrinkWrap: true,
//           itemBuilder: (context, index){
//           return ListTile(
//           title: Text(state.articles[index].title.toString()),
//           subtitle: Text(state.articles[index].content.toString()),
//           );
//           }),
//           )
//           ],
//           );
//           }
//           if (state is FirstPageLoading)
//           return Center(
//           child: CircularProgressIndicator(),
//           );
//           return CircularProgressIndicator();
//         },
//       ),
//     );
//   }
//
//   PaginationButton({required int currentPage, required int value}) {
//     return GestureDetector(
//         onTap: () {
//           setState(() {
//             currentPage = value;
//             print(currentPage.toString());
//           });
//         },
//         child: Card(
//           color: value == currentPage ? Colors.deepOrange : Colors.white,
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: Text(
//               (value).toString(),
//             ),
//           ),
//         ));
//   }
// }
//
// // class PaginationButton extends StatelessWidget {
// //   const PaginationButton({
// //     Key? key,
// //     required this.currentPage,
// //     required this.value,
// //   }) : super(key: key);
// //
// //   final int currentPage;
// //   final int value;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //     onTap: () {
// //     },
// //     child: Card(
// //       color: value==currentPage?Colors.deepOrange:Colors.white,
// //       elevation: 1,
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
// //         child: Text(
// //           (value).toString(),
// //         ),
// //       ),
// //     ));
// //   }
// // }
