

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/bloc/news_event.dart';
import 'package:flutter_news_app/bloc/news_states.dart';
import 'package:flutter_news_app/view/cateogires_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50.0,
);


enum FilterList { bbcNews, aryNews , independent , reuters, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {


  FilterList? selectedMenu ;
  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news' ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NewsBloc>()..add(FetchNewsChannelHeadlines(name));
    context.read<NewsBloc>()..add(NewsCategories('general'));

  }
  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.sizeOf(context).width * 1 ;
    final height  = MediaQuery.sizeOf(context).height * 1 ;

    return  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.read<NewsBloc>()..add(FetchNewsChannelHeadlines(name));
        },
      ),
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


                context.read<NewsBloc>()..add(FetchNewsChannelHeadlines(name));


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
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (BuildContext context, state) {
                print(state);
                switch(state.status){
                  case Status.initial:
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  case Status.failure:
                    return Text(state.message.toString());
                  case Status.success:
                  return ListView.builder(
                      itemCount: state.newsList!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context , index){

                        DateTime dateTime = DateTime.parse(state.newsList!.articles![index].publishedAt.toString());
                        return   InkWell(
                          onTap: (){
                            String newsImage =
                            state.newsList!.articles![index].urlToImage!;
                            String newsTitle =
                            state.newsList!.articles![index].title!;
                            String newsDate =
                            state.newsList!.articles![index].publishedAt!;
                            String newsAuthor =
                            state.newsList!.articles![index].author!;
                            String newsDesc =
                            state.newsList!.articles![index].description!;
                            String newsContent =
                            state.newsList!.articles![index].content!;
                            String newsSource =
                            state.newsList!.articles![index].source!.name!;
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
                                      imageUrl: state.newsList!.articles![index].urlToImage.toString(),
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
                                            child: Text(state.newsList!.articles![index].title.toString(),
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
                                                Text(state.newsList!.articles![index].source!.name.toString(),
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
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (BuildContext context, state) {
                switch(state.categoriesStatus){
                  case Status.initial:
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  case Status.failure:
                    return Text(state.categoriesMessage.toString());
                  case Status.success:
                    return ListView.builder(
                        itemCount: state.newsCategoriesList!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context , index){

                          DateTime dateTime = DateTime.parse(state.newsCategoriesList!.articles![index].publishedAt.toString());
                          return  Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: state.newsCategoriesList!.articles![index].urlToImage.toString(),
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
                                        Text(state.newsCategoriesList!.articles![index].title.toString() ,
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
                                            Expanded(
                                              child: Text(state.newsCategoriesList!.articles![index].source!.name.toString() ,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14 ,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w600
                                                ),
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
