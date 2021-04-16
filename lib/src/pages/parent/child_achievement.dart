import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/indicator.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';

class ChildAchievement extends StatefulWidget {
  @override
  _ChildAchievementState createState() => _ChildAchievementState();
}

class _ChildAchievementState extends State<ChildAchievement> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, "Prestasi"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: 25.0,),
          _buildHeader(context),
          SizedBox(height: 25.0,),
          _buildCard(),
          SizedBox(height: 25.0,),
          SubHeader(title: 'Lencana', isLihatSemua: false, path: ''),
          SizedBox(height: 25.0,),
          ListView.builder(
            itemCount: 9,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return InkWell(
                onTap: ()=>Navigator.pushNamed(context, '/parent/detail_task'),
                splashFactory: InkRipple.splashFactory,
                child: Container()
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildImpian(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(1.0, 3.0)
            )
          ]
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.nights_stay_rounded,
                color: primaryColor,
                size: 30.0,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Text(
                  'Berhasil menyelesaikan tugas abcdeffsdfasdfaskl',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.black
                  ),
                ),
              ),
              Text(
                "30 tahun lagi",
                style: TextStyle(
                    color: shadowColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
          SizedBox(height: 12.0,),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: LinearProgressIndicator(
              minHeight: 5.0,
              backgroundColor: thirdColor,
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              value: .5,
            ),
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rp 40000",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 13.0
                ),
              ),
              Text(
                "Rp 100000",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 13.0
                ),
              ),
            ],
          ),
        ],
      ),
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
              Text(
                "Keuangan",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 15.0
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: thirdColor,
                ),
                child: Text(
                  "Minggu ini",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              IconButton(
                color: shadowColor,
                onPressed: (){},
                icon: Icon(Icons.more_vert)
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                            if (desiredTouch && pieTouchResponse.touchedSection != null) {
                              touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                            } else {
                              touchedIndex = -1;
                            }
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections()),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Indicator(
                    color: Color(0xff0293ee),
                    text: 'First',
                    isSquare: false,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xfff8b250),
                    text: 'Second',
                    isSquare: false,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 28,
              ),
            ],
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
                  "Prestasi Lumen",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Daftar prestasi dan keuangan si kecil",
                  style: TextStyle(
                      color: shadowColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5
                  ),
                )
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
              ),
              color: secondaryColor,
              splashRadius: 30.0,
              iconSize: 50.0,
              onPressed: () => createAlertDialog(context),
            )
          ],
        )
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 70,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 10,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 10,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
