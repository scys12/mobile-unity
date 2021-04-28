import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/news.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/pages/parent/detail_article.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

import 'detail_task.dart';

class ListArticles extends StatefulWidget {
  @override
  _ListArticlesState createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles> {

  List<News> _news;
  @override
  Widget build(BuildContext context) {
    _news = Provider.of<List<News>>(context);
    return  Scaffold(
      appBar: CustomAppBar(true, "Semua Artikel"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SubHeader(title: 'Semua Artikel',isLihatSemua: false,),
            SizedBox(height: 15.0,),
            ListView.builder(
              itemCount: _news.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailArticle(news: _news[index],)));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            spreadRadius: 1.0,
                            blurRadius: 2.0,
                            offset: Offset(0.0, 1.0)
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Image.network(_news[index].imageUrl).image,
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _news[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat("dd MMMM yyyy").format(_news[index].createdAt),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: shadowColor,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                      Icon(Icons.circle, size: 10.0, color: shadowColor,),
                                      SizedBox(width: 10.0,),
                                      Text(
                                        DateFormat("HH:mm").format(_news[index].createdAt),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: shadowColor,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.double_arrow, color: shadowColor,),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
