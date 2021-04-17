import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/finance_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/indicator.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class ChildTransactions extends StatefulWidget {
  @override
  _ChildTransactionsState createState() => _ChildTransactionsState();
}

class _ChildTransactionsState extends State<ChildTransactions> with TickerProviderStateMixin{

  int _tabIndex = 0;
  TabController _tabController;
  int touchedIndex;
  ChildProvider _childProvider;
  FinancialProvider _financialProvider;
  List<Financial> financials = [];
  bool _loading = true;
  final List<String> menuItems = [
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
  ];
  final List<String> tabItems = [
    'Pendapatan',
    'Pengeluaran',
  ];
  String _currentType = 'Hari Ini';

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

  List<Financial> filterIncomeOutcome(List<Financial> finances){
    return _tabIndex == 0 ? finances.where((element) => element.type == 'income').toList() : finances.where((element) => element.type == 'outcome').toList();
  }

  void initState() {
    super.initState();
    _childProvider = Provider.of<ChildProvider>(context, listen: false);
    _financialProvider = Provider.of(context, listen: false);
    _financialProvider.getFinancialBasedChildId(childId: _childProvider.selectedChild.uid);
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 2, vsync: this);
    _financialProvider = Provider.of<FinancialProvider>(context);
    if (_financialProvider.financials != null) {
      setState(() {
        _loading = false;
      });
      financials = _financialProvider.financials;
    }
    var _filteredFinancials = filterFinancial();

    int _outcome = _countIncomeOutcome("outcome", _filteredFinancials);
    int _income = _countIncomeOutcome("income", _filteredFinancials);
    _filteredFinancials = filterIncomeOutcome(_filteredFinancials);
    print("Gas ${_filteredFinancials.length}");
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(false, "Prestasi"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 25.0,),
                  _buildHeader(context),
                  SizedBox(height: 25.0,),
                  _buildDropdown(),
                  SizedBox(height: 25.0,),
                  _buildCard(_income, _outcome),
                  SizedBox(height: 25.0,),
                  _buildTab(),
                ],
              ),
            ),
            _buildListKeuangan(_filteredFinancials),
          ],
        ),
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
          Text(
            "Keuangan",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 15.0
            ),
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

  Widget _buildHeader(BuildContext context){
    return Container(
     width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Ringkasan",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 23.0
              ),
            ),
            SizedBox(height: 8.0,),
            Text(
              "Lihat kemana saja uang ${_childProvider.selectedChild.name} digunakan",
              style: TextStyle(
                  color: shadowColor,
                  fontSize: 16.0,
                  letterSpacing: 0.5
              ),
            )
          ],
        ),
    );
  }

  Widget _buildDropdown(){
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lihat Ringkasan',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: blueOpColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(

                  icon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  dropdownColor: secondaryColor,
                  items: menuItems.map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  )).toList(),
                  onChanged: (value){
                    setState(() {
                      _currentType = value;
                    });
                  },
                  value:  _currentType,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(){
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        onTap: (val) => setState(() => _tabIndex = val),
        unselectedLabelColor: Colors.white,
        isScrollable: false,
        tabs: [
          ...tabItems.map((e) => Tab(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              decoration: e == tabItems[_tabIndex] ? BoxDecoration(
                color: orangeOpColor,
                borderRadius: BorderRadius.circular(30.0),
              ) : BoxDecoration(),
              child: Text(
                e,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                ),
              ),
            ),
          )).toList()
        ],
      ),
    );
  }

  Widget _buildListKeuangan(List<Financial> finances){
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
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
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: SubHeader(title: "List Keuangan  ",isLihatSemua: false,),
                  ),
                  Divider(thickness: 2.0,color: shadowColor,),
                  finances.length <= 0 ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Belum ada transaksi keuangan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0
                      ),
                    ),
                  ) : ListView.builder(
                    itemCount: finances.length,
                    shrinkWrap: true,
                    controller: ScrollController(keepScrollOffset: false),
                    itemBuilder: (context, index){
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    _tabIndex == 0
                                        ? Icon(
                                      Icons.add_circle,
                                      color: greenColor,
                                      size: 50.0,
                                    ) : Icon(
                                      Icons.remove_circle,
                                      color: redColor,
                                      size: 50.0,
                                    ),
                                    SizedBox(width: 15.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          finances[index].title,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(5.0)
                                          ),
                                          child: Text(
                                            DateFormat("dd MMMM yyyy").format(finances[index].createdAt),
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "${_tabIndex == 0 ? "+" : "-"} ${finances[index].money}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25.0,
                                      color: _tabIndex == 0 ? greenColor : redColor
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Divider(thickness: 2.0,color: shadowColor,),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
