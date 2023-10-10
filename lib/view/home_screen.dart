

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


import '../categoriesScreen.dart';
import '../models/categories_new_model.dart';
import '../models/news_channel_headlines_model.dart';
import '../view_model/news_view_model.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


enum FilterList { bbcNews, aryNews , independent , reuters, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu ;
  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news' ;

  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.sizeOf(context).width * 1 ;
    final height  = MediaQuery.sizeOf(context).height * 1 ;

    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png' ,
            height: 30,
            width: 30,
          ),
        ),
        title: Text('News' , style: GoogleFonts.poppins(fontSize: 24 , fontWeight: FontWeight.w700),),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(Icons.more_vert , color: Colors.black,),
              onSelected: (FilterList item){

                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news' ;
                }
                if(FilterList.aryNews.name ==item.name){
                  name  = 'ary-news';
                }

                if(FilterList.alJazeera.name ==item.name){
                  name  = 'al-jazeera-english';
                }


                setState(() {
                  selectedMenu = item;
                });

              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>> [
                PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews ,
                  child: Text('BBC News'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.aryNews ,
                  child: Text('Ary News'),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera ,
                  child: Text('Al-Jazeera News'),
                ),
              ]
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height:  height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: null,
              //future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              builder: (BuildContext context,  snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                }else {
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context , index){

                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return   InkWell(
                          onTap: (){
                            String newsImage =
                            snapshot.data!.articles![index].urlToImage!;
                            String newsTitle =
                            snapshot.data!.articles![index].title!;
                            String newsDate =
                            snapshot.data!.articles![index].publishedAt!;
                            String newsAuthor =
                            snapshot.data!.articles![index].author!;
                            String newsDesc =
                            snapshot.data!.articles![index].description!;
                            String newsContent =
                            snapshot.data!.articles![index].content!;
                            String newsSource =
                            snapshot.data!.articles![index].source!.name!;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                newsImage,
                                newsTitle,
                                newsDate,
                                newsAuthor,
                                newsDesc,
                                newsContent,
                                newsSource
                            )));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height:  height * 0.6,
                                  width:  width * .9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal:  height * .02
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder:  (context , url) => Container(child: spinKit2,),
                                      errorWidget: (context, url  ,error) => Icon(Icons.error_outline ,color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12) ,
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(15),
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                                maxLines: 2 ,
                                                overflow: TextOverflow.ellipsis
                                                ,style:
                                              GoogleFonts.poppins(fontSize: 17 , fontWeight: FontWeight.w700)
                                              ,),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2 ,
                                                  overflow: TextOverflow.ellipsis
                                                  ,style:
                                                  GoogleFonts.poppins(fontSize: 13 , fontWeight: FontWeight.w600)
                                                  ,),
                                                Text(format.format(dateTime),
                                                  maxLines: 2 ,
                                                  overflow: TextOverflow.ellipsis
                                                  ,style:
                                                  GoogleFonts.poppins(fontSize: 12 , fontWeight: FontWeight.w500)
                                                  ,)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  ) ;
                }
              },

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: null,
              //future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context,  snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                }else {
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      itemBuilder: (context , index){

                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return  Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder:  (context , url) => Container(child: Center(
                                    child: SpinKitCircle(
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                  ),),
                                  errorWidget: (context, url  ,error) => Icon(Icons.error_outline ,color: Colors.red,),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height:  height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString() ,
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15 ,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString() ,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14 ,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(format.format(dateTime) ,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15 ,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  ) ;
                }
              },

            ),
          )
        ],
      ),
    );
  }


}


const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
