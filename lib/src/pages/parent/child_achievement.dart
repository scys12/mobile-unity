import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/indicator.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class ChildAchievement extends StatefulWidget {
  @override
  _ChildAchievementState createState() => _ChildAchievementState();
}

class _ChildAchievementState extends State<ChildAchievement> {
  int touchedIndex;
  ChildProvider _childProvider;
  final List<String> menuItems = [
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
    'Histori Keuangan',
  ];
  String _currentType = 'Hari Ini';
  List<Financial> financials;

  List<Financial> filterFinancial(){
    List<Financial> filtered = [];
    var now = DateTime.now();
    var weekDay = now.weekday;
    var startDate = now.subtract(Duration(days: weekDay-1));
    if (_currentType == 'Hari Ini') {
      filtered = financials.where((element) => element.createdAt.difference(now).inDays == 0).toList();
    }else if (_currentType == 'Minggu Ini') {
      filtered = financials.where((element) => (startDate.difference(element.createdAt).inDays <=0 && startDate.difference(element.createdAt).inDays >=-6)).toList();
    }else if(_currentType == 'Bulan Ini') {
      filtered = financials.where((element) => element.createdAt.month == now.month && element.createdAt.year == now.year).toList();
    }
    return filtered;
  }

  int _countIncomeOutcome(String type, List<Financial> finances){
    return finances.where((element) => element.type == type).toList().fold(0, (previous, current) => previous + current.money);
  }

  @override
  Widget build(BuildContext context) {
    _childProvider = Provider.of<ChildProvider>(context);
    financials = Provider.of<List<Financial>>(context);
    print(financials.length);
    var _filteredFinancials = filterFinancial();
    int _outcome = _countIncomeOutcome("outcome", _filteredFinancials);
    int _income = _countIncomeOutcome("income", _filteredFinancials);
    return Scaffold(
      appBar: CustomAppBar(false, "Prestasi"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: 25.0,),
          _buildHeader(context),
          SizedBox(height: 25.0,),
          _buildCard(_income, _outcome),
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

  Widget _buildCard(int income, int outcome){
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
                  _currentType,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              PopupMenuButton(
                onSelected: (val) {
                  if (val == 'Histori Keuangan') {
                    Navigator.pushNamed(context, '/parent/transactions');
                  }else {
                    setState(() {
                      _currentType = val;
                    });
                  }
                },
                initialValue: _currentType,
                icon: Icon(
                  Icons.more_vert,
                  color: shadowColor,
                ),
                itemBuilder: (BuildContext context){
                  return menuItems.map((e) => PopupMenuItem(
                    child: Text(e),
                    value: e,
                  )).toList();
                },
              )
            ],
          ),
          SizedBox(height: 10.0,),
          income == 0 && outcome == 0
              ? Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: redColor,
                ),
                child: Text(
                  "Tdk Ada Transaksi Keuangan",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ) : Row(
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
                        sections: showingSections(income, outcome)),
                  ),
                ),
              ),
              SizedBox(width: 10.0,),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Indicator(
                        color: primaryColor,
                        text: '',
                        isSquare: false,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pemasukan',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Rp ${income}',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Indicator(
                        color: secondaryColor,
                        text: '',
                        isSquare: false,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengeluaran',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Rp ${outcome}',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4,
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
                  "Prestasi ${_childProvider.selectedChild.name}",
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
            _childProvider.selectedChild.imageUrl.length > 0
                ? ClipRRect(
              child: Image.network(
                _childProvider.selectedChild.imageUrl,
                fit: BoxFit.fill,
                height: 40,
                width: 40,
              ),borderRadius: BorderRadius.circular(20.0),) : Icon(
              Icons.account_circle,
              size: 50.0,
            ),
          ],
        )
    );
  }

  List<PieChartSectionData> showingSections(int income, int outcome) {
    double incomePercent = (income/(income+outcome))*100;
    double outcomePercent = (outcome/(income+outcome))*100;
    int totalValue = incomePercent <= 0 || outcomePercent <= 0 ? 1 : 2;
    return List.generate(totalValue, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: totalValue == 1 && incomePercent <= 0 ? secondaryColor : primaryColor,
            value: totalValue == 1 && incomePercent <= 0 ? outcomePercent : incomePercent,
            title: '${totalValue == 1 && incomePercent <= 0 ? outcomePercent.round() : incomePercent.round()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: secondaryColor,
            value: outcomePercent,
            title: '${outcomePercent.round()}%',
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
