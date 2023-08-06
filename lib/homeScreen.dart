import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/bloc/news_states.dart';
import 'package:flutter_news_app/categoriesScreen.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/model/all_news_model.dart';
import 'package:flutter_news_app/model/news_channel_model.dart';
import 'package:flutter_news_app/newsDetailScreen.dart';
import 'package:flutter_news_app/view_model/newsListViewModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'bloc/news_event.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// This is the type used by the popup menu below.
enum SampleItem {  bbcNews,alJjazeera, independent, reuters , cnn}


class _HomeScreenState extends State<HomeScreen> {
  NewsListViewModel newsListViewModel = NewsListViewModel();
  final format = new DateFormat('MMMM dd,yyyy');

  SampleItem? selectedMenu;
  String name = 'bbc-news' ;

  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => NewsBloc()..add(FetchNewsChannelHeadlines(name)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: Kheight * 0.05,
              width: Kwidth * 0.05,
            ),
          ),
          title: Text('News',
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.w800)),
          actions: [
            BlocBuilder<NewsBloc , NewsState>(
                builder: (context, state){
                  return PopupMenuButton<SampleItem>(
                    icon: Icon(Icons.more_vert,color: Colors.black,),
                    initialValue: selectedMenu,
                    // Callback that sets the selected popup menu item.
                    onSelected: (SampleItem item) {

                      if(SampleItem.bbcNews.name == item.name){
                        name = 'bbc-news' ;
                      }
                      if(SampleItem.cnn.name == item.name){
                        name = 'cnn' ;
                      }
                      if(SampleItem.alJjazeera.name == item.name){
                        name = 'al-jazeera-english' ;
                      }
                      if(SampleItem.alJjazeera.name == item.name){
                        name = 'al-jazeera-english' ;
                      }
                      if(SampleItem.reuters.name == item.name){
                        name = 'reuters' ;
                      }
                      if(SampleItem.independent.name == item.name){
                        name = 'independent' ;
                      }
                      selectedMenu = item;


                      context.read<NewsBloc>().add(FetchNewsChannelHeadlines(name));

                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.bbcNews,
                        child: Text('BBC News'),
                      ),
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.alJjazeera,
                        child: Text('Al Jazeera'),
                      ),
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.independent,
                        child: Text('Independent '),
                      ),
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.reuters,
                        child: Text('Reuters'),
                      ),
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.cnn,
                        child: Text('CNN'),
                      ),
                    ],
                  ) ;
                }
            ),

          ],
        ),
        body: BlocBuilder<NewsBloc , NewsState>(
          builder: (context, state){
            switch(state.status){
              case Status.initial:
                return SizedBox(
                    height: Kheight * 0.55,
                    child: Center(child: CircularProgressIndicator()));
              case Status.failure:
                return GestureDetector(
                    onTap: (){
                      NewsBloc()..add(FetchNewsChannelHeadlines(name));
                    },
                    child:  Center(child: Text(state.message.toString())));
                case Status.success:
                  print("lenghts:"+state.newsList!.totalResults.toString());
                  return ListView(
                    children: [

                      Container(
                        height: Kheight * 0.55,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.newsList!.articles!.length,
                            itemBuilder: (context, index) {

                              DateTime dateTime = DateTime.parse(state.newsList!.articles![index].publishedAt!);

                              return Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Kheight * 0.02),
                                      height: Kheight * 0.6,
                                      width: Kwidth * 0.9,

                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          "${state.newsList!.articles![index].urlToImage.toString()}",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(child: spinkit2),
                                          errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      child: InkWell(
                                        onTap: () {
                                          String newsImage = state.newsList!.articles![index].urlToImage!;
                                          String newsTitle =
                                          state.newsList!.articles![index].title!;
                                          String newsDate =state.newsList!.articles![index].publishedAt!;
                                          String newsAuthor =
                                          state.newsList!.articles![index].author!;
                                          String newsDesc = state.newsList!.articles![index].description!;
                                          String newsContent = state.newsList!.articles![index].content!;
                                          String newsSource = state.newsList!.articles![index].source!.name!;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsDetailScreen(
                                                          newsImage,
                                                          newsTitle,
                                                          newsDate,
                                                          newsAuthor,
                                                          newsDesc,
                                                          newsContent,
                                                          newsSource)));
                                        },
                                        child: Card(
                                          elevation: 5,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12)),
                                          child: Container(
                                              alignment: Alignment.bottomCenter,
                                              padding: EdgeInsets.all(10),
                                              height: Kheight * 0.22,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: Kwidth * 0.7,
                                                    child: Text(
                                                      '${state.newsList!.articles![index].title!}',
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 17,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                      // softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    width: Kwidth * 0.7,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                              '${state.newsList!.articles![index].source!.name}',
                                                              softWrap: true,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style:
                                                              GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${format.format(dateTime)}',
                                                          softWrap: true,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              color: Colors.black87,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      // FutureBuilder<AllNewsModel>(
                      //   future: newsListViewModel.fetchNews('general'),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return Text('');
                      //     } else {
                      //       return ListView.builder(
                      //           shrinkWrap: true,
                      //           physics: new NeverScrollableScrollPhysics(),
                      //           itemCount: snapshot.data!.articles!.length,
                      //           itemBuilder: (context, index) {
                      //             DateTime dateTime = DateTime.parse(
                      //                 snapshot.data!.articles![index].publishedAt!);
                      //
                      //             return InkWell(
                      //               onTap: () {
                      //                 String newsImage =
                      //                 snapshot.data!.articles![index].urlToImage!;
                      //                 String newsTitle =
                      //                 snapshot.data!.articles![index].title!;
                      //                 String newsDate =
                      //                 snapshot.data!.articles![index].publishedAt!;
                      //                 String newsAuthor =
                      //                 snapshot.data!.articles![index].author!;
                      //                 String newsDesc =
                      //                 snapshot.data!.articles![index].description!;
                      //                 String newsContent =
                      //                 snapshot.data!.articles![index].content!;
                      //                 String newsSource =
                      //                 snapshot.data!.articles![index].source!.name!;
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) => NewsDetailScreen(
                      //                             newsImage,
                      //                             newsTitle,
                      //                             newsDate,
                      //                             newsAuthor,
                      //                             newsDesc,
                      //                             newsContent,
                      //                             newsSource)));
                      //               },
                      //               child: Container(
                      //                 alignment: Alignment.topLeft,
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: Kwidth * 0.04,
                      //                     vertical: Kheight * 0.02),
                      //                 child: Row(
                      //                   children: [
                      //                     ClipRRect(
                      //                       borderRadius: BorderRadius.circular(10.0),
                      //                       child: CachedNetworkImage(
                      //                         imageUrl:
                      //                         "${snapshot.data!.articles![index].urlToImage.toString()}",
                      //                         height: Kheight * 0.18,
                      //                         width: Kwidth * 0.3,
                      //                         fit: BoxFit.cover,
                      //                         placeholder: (context, url) =>
                      //                             Container(child: spinkit2),
                      //                         errorWidget: (context, url, error) =>
                      //                         new Icon(Icons.error),
                      //                       ),
                      //                     ),
                      //                     Container(
                      //                         padding: EdgeInsets.only(left: 10),
                      //                         height: Kheight * 0.18,
                      //                         child: Column(
                      //                           crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                           children: [
                      //                             Container(
                      //                               width: Kwidth * 0.59,
                      //                               child: Text(
                      //                                 '${snapshot.data!.articles![index].title!}',
                      //                                 style: GoogleFonts.poppins(
                      //                                     fontSize: 15,
                      //                                     color: Colors.black87,
                      //                                     fontWeight: FontWeight.w600),
                      //                                 // softWrap: true,
                      //                                 overflow: TextOverflow.ellipsis,
                      //                                 maxLines: 3,
                      //                               ),
                      //                             ),
                      //                             Spacer(),
                      //                             Container(
                      //                               width: Kwidth * 0.56,
                      //                               child: Row(
                      //                                 mainAxisAlignment:
                      //                                 MainAxisAlignment.spaceBetween,
                      //                                 children: [
                      //                                   Expanded(
                      //                                     child: Container(
                      //                                       child: Text(
                      //                                         '${snapshot.data!.articles![index].source!.name}',
                      //                                         softWrap: true,
                      //                                         overflow:
                      //                                         TextOverflow.ellipsis,
                      //                                         style: GoogleFonts.poppins(
                      //                                             fontSize: 13,
                      //                                             color: Colors.blueAccent,
                      //                                             fontWeight:
                      //                                             FontWeight.w600),
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                   Text(
                      //                                     '${format.format(dateTime)}',
                      //                                     softWrap: true,
                      //                                     overflow: TextOverflow.ellipsis,
                      //                                     style: GoogleFonts.poppins(
                      //                                         fontSize: 12,
                      //                                         color: Colors.black87,
                      //                                         fontWeight: FontWeight.w500),
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                             )
                      //                           ],
                      //                         ))
                      //                   ],
                      //                 ),
                      //               ),
                      //             );
                      //             // return Row(
                      //             //   children: [
                      //             //     Column(
                      //             //       children: [
                      //             //         Text(snapshot.data!.articles![index].title!),
                      //             //       ],
                      //             //     ),
                      //
                      //             //   ],
                      //             // );
                      //           });
                      //     }
                      //   },
                      // ),
                    ],
                  );
            }

          },
        ),
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50.0,
);

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// // This is the type used by the popup menu below.
// enum SampleItem {  bbcNews,alJjazeera, independent, reuters , cnn}
//
//
// class _HomeScreenState extends State<HomeScreen> {
//   NewsListViewModel newsListViewModel = NewsListViewModel();
//   final format = new DateFormat('MMMM dd,yyyy');
//
//   SampleItem? selectedMenu;
//   String name = 'bbc-news' ;
//
//   @override
//   Widget build(BuildContext context) {
//     double Kwidth = MediaQuery.of(context).size.width;
//     double Kheight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => CategoriesScreen()));
//           },
//           icon: Image.asset(
//             'images/category_icon.png',
//             height: Kheight * 0.05,
//             width: Kwidth * 0.05,
//           ),
//         ),
//         title: Text('News',
//             style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w800)),
//         actions: [
//           PopupMenuButton<SampleItem>(
//             icon: Icon(Icons.more_vert,color: Colors.black,),
//             initialValue: selectedMenu,
//             // Callback that sets the selected popup menu item.
//             onSelected: (SampleItem item) {
//
//               if(SampleItem.bbcNews.name == item.name){
//                 name = 'bbc-news' ;
//               }
//               if(SampleItem.cnn.name == item.name){
//                 name = 'cnn' ;
//               }
//               if(SampleItem.alJjazeera.name == item.name){
//                 name = 'al-jazeera-english' ;
//               }
//               if(SampleItem.alJjazeera.name == item.name){
//                 name = 'al-jazeera-english' ;
//               }
//               if(SampleItem.reuters.name == item.name){
//                 name = 'reuters' ;
//               }
//               if(SampleItem.independent.name == item.name){
//                 name = 'independent' ;
//               }
//               setState(() {
//                 selectedMenu = item;
//               });
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
//               const PopupMenuItem<SampleItem>(
//                 value: SampleItem.bbcNews,
//                 child: Text('BBC News'),
//               ),
//               const PopupMenuItem<SampleItem>(
//                 value: SampleItem.alJjazeera,
//                 child: Text('Al Jazeera'),
//               ),
//               const PopupMenuItem<SampleItem>(
//                 value: SampleItem.independent,
//                 child: Text('Independent '),
//               ),
//               const PopupMenuItem<SampleItem>(
//                 value: SampleItem.reuters,
//                 child: Text('Reuters'),
//               ),
//               const PopupMenuItem<SampleItem>(
//                 value: SampleItem.cnn,
//                 child: Text('CNN'),
//               ),
//             ],
//           ),
//
//         ],
//       ),
//       body: ListView(
//         children: [
//           Container(
//             height: Kheight * 0.55,
//             child: FutureBuilder<ModelBbcNews>(
//               future: newsListViewModel.fetchBBcNews(name),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: spinkit);
//                 } else {
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data?.articles?.length,
//                       itemBuilder: (context, index) {
//
//                         DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt!);
//
//                         return Container(
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: Kheight * 0.02),
//                                 height: Kheight * 0.6,
//                                 width: Kwidth * 0.9,
//
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                   child: CachedNetworkImage(
//                                     imageUrl:
//                                     "${snapshot.data!.articles![index].urlToImage!}",
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) =>
//                                         Container(child: spinkit2),
//                                     errorWidget: (context, url, error) =>
//                                     new Icon(Icons.error),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 20,
//                                 child: InkWell(
//                                   onTap: () {
//                                     String newsImage = snapshot
//                                         .data!.articles![index].urlToImage!;
//                                     String newsTitle =
//                                     snapshot.data!.articles![index].title!;
//                                     String newsDate = snapshot
//                                         .data!.articles![index].publishedAt!;
//                                     String newsAuthor =
//                                     snapshot.data!.articles![index].author!;
//                                     String newsDesc = snapshot
//                                         .data!.articles![index].description!;
//                                     String newsContent = snapshot
//                                         .data!.articles![index].content!;
//                                     String newsSource = snapshot
//                                         .data!.articles![index].source!.name!;
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 NewsDetailScreen(
//                                                     newsImage,
//                                                     newsTitle,
//                                                     newsDate,
//                                                     newsAuthor,
//                                                     newsDesc,
//                                                     newsContent,
//                                                     newsSource)));
//                                   },
//                                   child: Card(
//                                     elevation: 5,
//                                     color: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(12)),
//                                     child: Container(
//                                         alignment: Alignment.bottomCenter,
//                                         padding: EdgeInsets.all(10),
//                                         height: Kheight * 0.22,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: Kwidth * 0.7,
//                                               child: Text(
//                                                 '${snapshot.data!.articles![index].title!}',
//                                                 style: GoogleFonts.poppins(
//                                                     fontSize: 17,
//                                                     color: Colors.black87,
//                                                     fontWeight:
//                                                     FontWeight.w700),
//                                                 // softWrap: true,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 3,
//                                               ),
//                                             ),
//                                             Spacer(),
//                                             Container(
//                                               width: Kwidth * 0.7,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: Container(
//                                                       child: Text(
//                                                         '${snapshot.data!.articles![index].source!.name}',
//                                                         softWrap: true,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style:
//                                                         GoogleFonts.poppins(
//                                                             fontSize: 13,
//                                                             color: Colors
//                                                                 .blueAccent,
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .w600),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     '${format.format(dateTime)}',
//                                                     softWrap: true,
//                                                     overflow:
//                                                     TextOverflow.ellipsis,
//                                                     style: GoogleFonts.poppins(
//                                                         fontSize: 12,
//                                                         color: Colors.black87,
//                                                         fontWeight:
//                                                         FontWeight.w500),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         )),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       });
//                 }
//               },
//             ),
//           ),
//           FutureBuilder<AllNewsModel>(
//             future: newsListViewModel.fetchNews('general'),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Text('');
//               } else {
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     physics: new NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data!.articles!.length,
//                     itemBuilder: (context, index) {
//                       DateTime dateTime = DateTime.parse(
//                           snapshot.data!.articles![index].publishedAt!);
//
//                       return InkWell(
//                         onTap: () {
//                           String newsImage =
//                           snapshot.data!.articles![index].urlToImage!;
//                           String newsTitle =
//                           snapshot.data!.articles![index].title!;
//                           String newsDate =
//                           snapshot.data!.articles![index].publishedAt!;
//                           String newsAuthor =
//                           snapshot.data!.articles![index].author!;
//                           String newsDesc =
//                           snapshot.data!.articles![index].description!;
//                           String newsContent =
//                           snapshot.data!.articles![index].content!;
//                           String newsSource =
//                           snapshot.data!.articles![index].source!.name!;
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => NewsDetailScreen(
//                                       newsImage,
//                                       newsTitle,
//                                       newsDate,
//                                       newsAuthor,
//                                       newsDesc,
//                                       newsContent,
//                                       newsSource)));
//                         },
//                         child: Container(
//                           alignment: Alignment.topLeft,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: Kwidth * 0.04,
//                               vertical: Kheight * 0.02),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 child: CachedNetworkImage(
//                                   imageUrl:
//                                   "${snapshot.data!.articles![index].urlToImage.toString()}",
//                                   height: Kheight * 0.18,
//                                   width: Kwidth * 0.3,
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) =>
//                                       Container(child: spinkit2),
//                                   errorWidget: (context, url, error) =>
//                                   new Icon(Icons.error),
//                                 ),
//                               ),
//                               Container(
//                                   padding: EdgeInsets.only(left: 10),
//                                   height: Kheight * 0.18,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         width: Kwidth * 0.59,
//                                         child: Text(
//                                           '${snapshot.data!.articles![index].title!}',
//                                           style: GoogleFonts.poppins(
//                                               fontSize: 15,
//                                               color: Colors.black87,
//                                               fontWeight: FontWeight.w600),
//                                           // softWrap: true,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 3,
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Container(
//                                         width: Kwidth * 0.56,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: Container(
//                                                 child: Text(
//                                                   '${snapshot.data!.articles![index].source!.name}',
//                                                   softWrap: true,
//                                                   overflow:
//                                                   TextOverflow.ellipsis,
//                                                   style: GoogleFonts.poppins(
//                                                       fontSize: 13,
//                                                       color: Colors.blueAccent,
//                                                       fontWeight:
//                                                       FontWeight.w600),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               '${format.format(dateTime)}',
//                                               softWrap: true,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: GoogleFonts.poppins(
//                                                   fontSize: 12,
//                                                   color: Colors.black87,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ))
//                             ],
//                           ),
//                         ),
//                       );
//                       // return Row(
//                       //   children: [
//                       //     Column(
//                       //       children: [
//                       //         Text(snapshot.data!.articles![index].title!),
//                       //       ],
//                       //     ),
//
//                       //   ],
//                       // );
//                     });
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// const spinkit2 = SpinKitFadingCircle(
//   color: Colors.amber,
//   size: 50.0,
// );


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// // This is the type used by the popup menu below.
// enum SampleItem {  bbcNews,alJjazeera, independent, reuters , cnn}
//
//
// class _HomeScreenState extends State<HomeScreen> {
//   NewsListViewModel newsListViewModel = NewsListViewModel();
//   final format = new DateFormat('MMMM dd,yyyy');
//
//   SampleItem? selectedMenu;
//   String name = 'bbc-news' ;
//
//   @override
//   Widget build(BuildContext context) {
//     double Kwidth = MediaQuery.of(context).size.width;
//     double Kheight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => CategoriesScreen()));
//           },
//           icon: Image.asset(
//             'images/category_icon.png',
//             height: Kheight * 0.05,
//             width: Kwidth * 0.05,
//           ),
//         ),
//         title: Text('News',
//             style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w800)),
//         actions: [
//         PopupMenuButton<SampleItem>(
//           icon: Icon(Icons.more_vert,color: Colors.black,),
//         initialValue: selectedMenu,
//         // Callback that sets the selected popup menu item.
//         onSelected: (SampleItem item) {
//
//             if(SampleItem.bbcNews.name == item.name){
//               name = 'bbc-news' ;
//             }
//             if(SampleItem.cnn.name == item.name){
//               name = 'cnn' ;
//             }
//             if(SampleItem.alJjazeera.name == item.name){
//               name = 'al-jazeera-english' ;
//             }
//             if(SampleItem.alJjazeera.name == item.name){
//               name = 'al-jazeera-english' ;
//             }
//             if(SampleItem.reuters.name == item.name){
//               name = 'reuters' ;
//             }
//             if(SampleItem.independent.name == item.name){
//               name = 'independent' ;
//             }
//           setState(() {
//             selectedMenu = item;
//           });
//         },
//         itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.bbcNews,
//             child: Text('BBC News'),
//           ),
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.alJjazeera,
//             child: Text('Al Jazeera'),
//           ),
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.independent,
//             child: Text('Independent '),
//           ),
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.reuters,
//             child: Text('Reuters'),
//           ),
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.cnn,
//             child: Text('CNN'),
//           ),
//         ],
//       ),
//
//         ],
//       ),
//       body: ListView(
//         children: [
//           Container(
//             height: Kheight * 0.55,
//             child: FutureBuilder<ModelBbcNews>(
//               future: newsListViewModel.fetchBBcNews(name),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: spinkit);
//                 } else {
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data?.articles?.length,
//                       itemBuilder: (context, index) {
//
//                         DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt!);
//
//                         return Container(
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: Kheight * 0.02),
//                                 height: Kheight * 0.6,
//                                 width: Kwidth * 0.9,
//
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                   child: CachedNetworkImage(
//                                     imageUrl:
//                                         "${snapshot.data!.articles![index].urlToImage!}",
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) =>
//                                         Container(child: spinkit2),
//                                     errorWidget: (context, url, error) =>
//                                         new Icon(Icons.error),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 20,
//                                 child: InkWell(
//                                   onTap: () {
//                                     String newsImage = snapshot
//                                         .data!.articles![index].urlToImage!;
//                                     String newsTitle =
//                                         snapshot.data!.articles![index].title!;
//                                     String newsDate = snapshot
//                                         .data!.articles![index].publishedAt!;
//                                     String newsAuthor =
//                                         snapshot.data!.articles![index].author!;
//                                     String newsDesc = snapshot
//                                         .data!.articles![index].description!;
//                                     String newsContent = snapshot
//                                         .data!.articles![index].content!;
//                                     String newsSource = snapshot
//                                         .data!.articles![index].source!.name!;
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 NewsDetailScreen(
//                                                     newsImage,
//                                                     newsTitle,
//                                                     newsDate,
//                                                     newsAuthor,
//                                                     newsDesc,
//                                                     newsContent,
//                                                     newsSource)));
//                                   },
//                                   child: Card(
//                                     elevation: 5,
//                                     color: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                     child: Container(
//                                         alignment: Alignment.bottomCenter,
//                                         padding: EdgeInsets.all(10),
//                                         height: Kheight * 0.22,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: Kwidth * 0.7,
//                                               child: Text(
//                                                 '${snapshot.data!.articles![index].title!}',
//                                                 style: GoogleFonts.poppins(
//                                                     fontSize: 17,
//                                                     color: Colors.black87,
//                                                     fontWeight:
//                                                         FontWeight.w700),
//                                                 // softWrap: true,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 3,
//                                               ),
//                                             ),
//                                             Spacer(),
//                                             Container(
//                                               width: Kwidth * 0.7,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: Container(
//                                                       child: Text(
//                                                         '${snapshot.data!.articles![index].source!.name}',
//                                                         softWrap: true,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style:
//                                                             GoogleFonts.poppins(
//                                                                 fontSize: 13,
//                                                                 color: Colors
//                                                                     .blueAccent,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     '${format.format(dateTime)}',
//                                                     softWrap: true,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: GoogleFonts.poppins(
//                                                         fontSize: 12,
//                                                         color: Colors.black87,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         )),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       });
//                 }
//               },
//             ),
//           ),
//           FutureBuilder<AllNewsModel>(
//             future: newsListViewModel.fetchNews('general'),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Text('');
//               } else {
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     physics: new NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data!.articles!.length,
//                     itemBuilder: (context, index) {
//                       DateTime dateTime = DateTime.parse(
//                           snapshot.data!.articles![index].publishedAt!);
//
//                       return InkWell(
//                         onTap: () {
//                           String newsImage =
//                               snapshot.data!.articles![index].urlToImage!;
//                           String newsTitle =
//                               snapshot.data!.articles![index].title!;
//                           String newsDate =
//                               snapshot.data!.articles![index].publishedAt!;
//                           String newsAuthor =
//                               snapshot.data!.articles![index].author!;
//                           String newsDesc =
//                               snapshot.data!.articles![index].description!;
//                           String newsContent =
//                               snapshot.data!.articles![index].content!;
//                           String newsSource =
//                               snapshot.data!.articles![index].source!.name!;
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => NewsDetailScreen(
//                                       newsImage,
//                                       newsTitle,
//                                       newsDate,
//                                       newsAuthor,
//                                       newsDesc,
//                                       newsContent,
//                                       newsSource)));
//                         },
//                         child: Container(
//                           alignment: Alignment.topLeft,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: Kwidth * 0.04,
//                               vertical: Kheight * 0.02),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 child: CachedNetworkImage(
//                                   imageUrl:
//                                       "${snapshot.data!.articles![index].urlToImage.toString()}",
//                                   height: Kheight * 0.18,
//                                   width: Kwidth * 0.3,
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) =>
//                                       Container(child: spinkit2),
//                                   errorWidget: (context, url, error) =>
//                                       new Icon(Icons.error),
//                                 ),
//                               ),
//                               Container(
//                                   padding: EdgeInsets.only(left: 10),
//                                   height: Kheight * 0.18,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         width: Kwidth * 0.59,
//                                         child: Text(
//                                           '${snapshot.data!.articles![index].title!}',
//                                           style: GoogleFonts.poppins(
//                                               fontSize: 15,
//                                               color: Colors.black87,
//                                               fontWeight: FontWeight.w600),
//                                           // softWrap: true,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 3,
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Container(
//                                         width: Kwidth * 0.56,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: Container(
//                                                 child: Text(
//                                                   '${snapshot.data!.articles![index].source!.name}',
//                                                   softWrap: true,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: GoogleFonts.poppins(
//                                                       fontSize: 13,
//                                                       color: Colors.blueAccent,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               '${format.format(dateTime)}',
//                                               softWrap: true,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: GoogleFonts.poppins(
//                                                   fontSize: 12,
//                                                   color: Colors.black87,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ))
//                             ],
//                           ),
//                         ),
//                       );
//                       // return Row(
//                       //   children: [
//                       //     Column(
//                       //       children: [
//                       //         Text(snapshot.data!.articles![index].title!),
//                       //       ],
//                       //     ),
//
//                       //   ],
//                       // );
//                     });
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// const spinkit2 = SpinKitFadingCircle(
//   color: Colors.amber,
//   size: 50.0,
// );
