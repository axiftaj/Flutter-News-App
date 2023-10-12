

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/bloc/news_event.dart';
import 'package:flutter_news_app/bloc/news_states.dart';
import 'package:flutter_news_app/view/cateogires_screen.dart';
import 'package:flutter_news_app/view/home/widgets/home_app_bar_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';

import '../../news_detail_screen.dart';
import '../home_screen.dart';

class HeadlinesWidget extends StatelessWidget {
  final String dateAndTime ;
  final int index ;
  const HeadlinesWidget({Key? key, required this.dateAndTime , required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.sizeOf(context).width * 1 ;
    final height  = MediaQuery.sizeOf(context).height * 1 ;
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (BuildContext context, state) {
        return InkWell(
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
                                Text(dateAndTime,
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

      },

    );
  }
}
