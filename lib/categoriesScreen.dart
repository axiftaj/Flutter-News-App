import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/homeScreen.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/model/all_news_model.dart';
import 'package:flutter_news_app/newsDetailScreen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<String> btnCategories = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  final format = new DateFormat('MMMM dd,yyyy');
  NewsViewModel newsListViewModel = NewsViewModel();

  int btnSelected = 0;
  String selectedCategory = 'General';
  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    final width  = MediaQuery.sizeOf(context).width * 1 ;
    final height  = MediaQuery.sizeOf(context).height * 1 ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[600],
            )),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: Kheight * 0.07,
            child: ListView.builder(
                itemCount: btnCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          primary: index == btnSelected
                              ? Colors.blueAccent
                              : Colors.grey),
                      onPressed: () {
                        btnSelected = index;
                        selectedCategory = btnCategories[index];
                        setState(() {});
                      },
                      child: Text(
                        btnCategories[index],
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
                  );
                }),
          ),
          Expanded(
            child: FutureBuilder<AllNewsModel>(
              future:
                  newsListViewModel.fetchNews(selectedCategory.toLowerCase()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinkit);
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                            snapshot.data!.articles![index].publishedAt!);

                        return InkWell(
                          onTap: () {
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                        newsImage,
                                        newsTitle,
                                        newsDate,
                                        newsAuthor,
                                        newsDesc,
                                        newsContent,
                                        newsSource)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width:  width * .3,
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Container(
                                      height: height * .18,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${snapshot.data!.articles![index].title!}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                            // softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),

                                                style:
                                                GoogleFonts.poppins(fontSize: 13 , fontWeight: FontWeight.w600)
                                                ,),
                                              Text(format.format(dateTime),
                                                overflow: TextOverflow.ellipsis
                                                ,style:
                                                GoogleFonts.poppins(fontSize: 12 , fontWeight: FontWeight.w500)
                                                ,)
                                            ],
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
                        // return Row(
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Text(snapshot.data!.articles![index].title!),
                        //       ],
                        //     ),

                        //   ],
                        // );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
