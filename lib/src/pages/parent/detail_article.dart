import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/news.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';

class DetailArticle extends StatefulWidget {
  final News news;
  DetailArticle({this.news});

  @override
  _DetailArticleState createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Artikel"),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.network(widget.news.imageUrl).image,
                  fit: BoxFit.fill
              ),
            ),
          ),Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.news.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 5.0,),
                Row(
                  children: [
                    Text(
                      DateFormat("dd MMMM yyyy").format(widget.news.createdAt),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: shadowColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Icon(Icons.circle, size: 10.0, color: shadowColor,),
                    SizedBox(width: 10.0,),
                    Text(
                      DateFormat("HH:mm").format(widget.news.createdAt),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: shadowColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Text(
                  widget.news.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
