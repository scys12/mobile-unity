import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';

class KidTask extends StatefulWidget {
  @override
  _KidTaskState createState() => _KidTaskState();
}

class _KidTaskState extends State<KidTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, "Tugas"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildHeader(context),
          ),
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SubHeader(title: 'Segera diselesaikan',isLihatSemua: false),
          ),
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _buildCard()
                ),
                SizedBox(width: 15.0,),
                Expanded(
                  child: _buildCard(),
                ),
              ],
            ),
          ),
          SizedBox(height: 35.0,),
          _buildAnotherTask(),
        ],
      ),
    );
  }

  Widget _buildAnotherTask(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2.0,
            blurRadius: 2.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0)
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          SubHeader(title: "Tugas Lain",isLihatSemua: false,),
          SizedBox(height: 10.0,),
          ListView.builder(
            itemCount: 9,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return InkWell(
                onTap: ()=>Navigator.pushNamed(context, '/parent/detail_task'),
                splashFactory: InkRipple.splashFactory,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          spreadRadius: 3.0,
                          blurRadius: 2.0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Berhasil menyelesaikan tugas',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Text(
                                "5 hari lagi",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Text(
                                "+10pts",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      )
    );
  }

  Widget _buildCard(){
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(1,2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: redColor,
                ),
                child: Text(
                  "1 hari lagi",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: redColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+10',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      'pts',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Text(
            "Berhasil menyelesaikan 1 tugas",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 15.0
            ),
          ),
          SizedBox(height: 10.0,),
          Text(
            '05-04-2021',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: thirdColor,
                fontSize: 15.0
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: greenColor,
            ),
            child: Text(
              "Pendidikan",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tugasku",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Selesaikan segera tugas-tugas \nagar mendapat poin",
                  style: TextStyle(
                      color: shadowColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5
                  ),
                )
              ],
            ),
          ]
        )
    );
  }


}
