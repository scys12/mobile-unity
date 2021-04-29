import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/news.dart';
import 'package:mobile_unity/src/pages/teenager/detail_challenge.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class Challenges extends StatefulWidget {
  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  List<Challenge> _challenges;
  List<News> _news;

  @override
  Widget build(BuildContext context) {
    _challenges = Provider.of<List<Challenge>>(context);
    _news = Provider.of<List<News>>(context);
    _news = _news.take(5).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            SubHeader(title: "Semua Tantangan", isLihatSemua: false, path: "",),
            SizedBox(height: 10.0,),
            _challenges.length > 0 ? ListView.builder(
              itemCount: _challenges.length,
              shrinkWrap: true,
              itemBuilder: (builder, index){
                return _buildChallenge(index);
              },
            ) : Text("Belum ada tantangan"),
            SizedBox(height: 20.0,),
            SubHeader(title: "Artikel Edukasi Finansial", path: "", isLihatSemua: false,),
            SizedBox(height: 10.0,),
            _news.length > 0
                ? Column(
              children: [
                _buildArticle(),
                Container(
                  child: _buildArticleButton(),
                  width: double.infinity,
                )
              ],
            ) : Text(
                "Tidak ada artikel"
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleButton() {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/parent/all_articles');
        },
        child: Text(
          "Lihat Semua Artikel",
          style: TextStyle(
              color: Colors.white
          ),
        )
    );
  }

  Widget _buildArticle(){
    return ListView.builder(
      itemCount: _news.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        return InkWell(
          onTap: (){print("abc");},
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network(_news[index].imageUrl).image,
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(10.0)
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChallenge(int index) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder) => DetailChallenge(uid: _challenges[index].uid,)));
      },
      child: Card(
        color: thirdColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.local_activity, size: 60.0,color: secondaryColor,),
              SizedBox(width: 10.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _challenges[index].title,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      decoration: BoxDecoration(
                        color: _challenges[index].isDone ? greenColor : redColor,
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        _challenges[index].isDone ? "Sudah Selesai" : "Belum Selesai",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
