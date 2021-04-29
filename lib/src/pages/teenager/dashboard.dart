import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/kid/detail_task.dart';
import 'package:mobile_unity/src/provider/finance_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DashboardTeenager extends StatefulWidget {
  @override
  _DashboardTeenagerState createState() => _DashboardTeenagerState();
}

class _DashboardTeenagerState extends State<DashboardTeenager> {
  Teenager user;
  List<Task> tasks = [];
  Wish _wish;
  FinancialProvider _financialProvider;
  List<Financial> financials = [];
  bool _loading = true;
  List<Financial> _filteredFinancials = [];
  int _income = 0;
  int _outcome = 0;
  final List<String> frekuensi = [
    "hari",
    "minggu",
    "bulan"
  ];

  List<Financial> filterFinancial(int _currentType, DateTime wishCreatedAt){
    List<Financial> filtered = [];
    var now = DateTime.now();
    var weekDay = now.weekday;
    var startDate = now.subtract(Duration(days: weekDay-1));

    if (_currentType == 0) {
      filtered = financials.where((element) => element.createdAt.difference(now).inDays == 0 && element.createdAt.difference(wishCreatedAt).inSeconds > 0).toList();
    }else if (_currentType == 1) {
      filtered = financials.where((element) => (startDate.difference(element.createdAt).inDays <=0 && startDate.difference(element.createdAt).inDays >=-6) && element.createdAt.difference(wishCreatedAt).inSeconds > 0).toList();
    }else if(_currentType == 2) {
      filtered = financials.where((element) => element.createdAt.month == now.month && element.createdAt.year == now.year && element.createdAt.difference(wishCreatedAt).inSeconds > 0).toList();
    }
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<Teenager>(context, listen: false);
    _financialProvider = Provider.of(context, listen: false);
    initData();
  }

  initData() async{
    await _financialProvider.getFinancialBasedChildId(childId: user.uid);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<Teenager>(context);
    _financialProvider = Provider.of(context);
    _wish = Provider.of<Wish>(context);
    if (_financialProvider.financials != null) {
      setState(() {
        _loading = false;
      });
      financials = _financialProvider.financials;
      _checkWishReminder();
    }
    return _loading ? Loading() :  Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          _buildHeader(),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                SubHeader(
                  title: 'Catat Keuanganku',
                  isLihatSemua: false,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _buildCatatanKeuangan(),
                SizedBox(
                  height: 15.0,
                ),
                SubHeader(
                  title: 'Reminder',
                  isLihatSemua: false,
                ),
                SizedBox(
                  height: 15.0,
                ),
                _buildReminder(),
                SizedBox(
                  height: 10.0,
                ),
                _buildReminderIncomeOutcome(),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        _buildWelcomeInformation(),
        _buildTransactionInformation(),
      ],
    );
  }

  Widget _buildReminderIncomeOutcome(){
    return Column(
      children: [
        user.incomeFrekuensi > 0
          ? _buildReminderIncome()
          : Container(),
        SizedBox(height: 10.0,),
        user.outcomeFrekuensi > 0
          ? _buildReminderOutcome()
          : Container(),
      ],
    );
  }

  Widget _buildReminderOutcome(){
    List<Financial> filteredFinancials = filterFinancial(user.outcomeFrekuensi-1, user.outcomeDate);
    int outcome = _countIncomeOutcome("outcome", filteredFinancials);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: filteredFinancials.length >= 0 ? outcome < user.outcomeMoney ? greenColor : redColor : redColor,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        children: [
          Icon(Icons.notifications, color: Colors.white,),
          SizedBox(height: 10.0,),
          Text(
            outcome < user.outcomeMoney
                ? "Yeay, pengeluaranmu masih sedikit"
                : "Yahh, pengeluaranmu melebihi yang kamu inginkan",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0,),
          Text(
            outcome < user.outcomeMoney
                ? "Pengeluaran kamu untuk ${frekuensi[user.outcomeFrekuensi-1]} ini berupa Rp ${outcome} dari Rp ${user.outcomeMoney}"
                : "Pengeluaran kamu melebihi yang kamu inginkan pada ${frekuensi[user.outcomeFrekuensi-1]} ini. Pengeluaran kamu sebanyak Rp ${outcome} dari Rp ${user.outcomeMoney}",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderIncome(){
    List<Financial> filteredFinancials = filterFinancial(user.incomeFrekuensi-1, user.incomeDate);
    int outcome = _countIncomeOutcome("outcome", filteredFinancials);
    int income = _countIncomeOutcome("income", filteredFinancials);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: filteredFinancials.length > 0 ? income-outcome > user.incomeMoney ? greenColor : redColor : redColor,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        children: [
          Icon(Icons.notifications, color: Colors.white,),
          SizedBox(height: 10.0,),
          Text(
            income-outcome < user.incomeMoney
                ? "Yahh, kamu belum mencapai target pemasukan yang kamu inginkan"
                : "Yeay, pemasukanmu sesuai dengan yang kamu inginkan",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0,),
          Text(
            income-outcome < user.incomeMoney
              ? "Kamu baru berhasil menabung sebanyak Rp ${income-outcome} dari Rp ${user.incomeMoney} untuk pemasukan pada ${frekuensi[user.incomeFrekuensi-1]} ini"
              : "Kamu sudah berhasil menabung sebanyak ${income-outcome} untuk pemasukan pada ${frekuensi[user.incomeFrekuensi-1]} ini",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeInformation() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60.0),
            bottomRight: Radius.circular(60.0)),
      ),
      margin: EdgeInsets.only(bottom: 100),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 80.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                user.imageUrl.length > 0
                    ? ClipRRect(
                  child: Image.network(
                    user.imageUrl,
                    fit: BoxFit.fill,
                    height: 40,
                    width: 40,
                  ),borderRadius: BorderRadius.circular(20.0),) : Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 15,
                ),
                user.isProfileFilled
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo ${user.name},',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Selamat Menabung',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Lengkapi Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w700),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          primary: primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 15.0)),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/teenager/change_profile');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInformation() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondaryColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Total Uang",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        "${user.income - user.outcome}",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 28.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Pointku",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        "${user.totalPoint} pts",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(whiteOpColor),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 10.0)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/teenager/transactions');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Riwayat",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget _buildCatatanKeuangan() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: thirdColor),
                    color: Colors.white
                  ),
                  child: _buildCatatanIcon(Icons.add_circle_outline, greenColor, "Pemasukan", () async{
                    final result = await Navigator.pushNamed(context, '/teenager/new_income');
                    if (result != null) successMessage(context, result);
                  }),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: thirdColor),
                    color: Colors.white
                ),child: _buildCatatanIcon(
                    Icons.remove_circle_outline, redColor, "Pengeluaran", () async {
                  Navigator.pushNamed(context, '/teenager/new_outcome');
                }),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: thirdColor),
                    color: Colors.white
                ),child: _buildCatatanIcon(
                    Icons.analytics_outlined, secondaryColor, "Ringkasan", () async {
                  Navigator.pushNamed(context, '/teenager/transactions');
                }),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                    border: Border.all(color: thirdColor),
                    color: Colors.white
                ),child: _buildCatatanIcon(
                    Icons.alarm_add, primaryColor, "Reminder", () async {
                  Navigator.pushNamed(context, '/teenager/reminder');
                }),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCatatanIcon(IconData iconData, Color iconColor, String content, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 40.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            content,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14.0),
          )
        ],
      ),
    );
  }

  Widget _buildCard(int idx, Task task) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailTaskKid(taskId: task.uid,)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: (idx < tasks.length-1) ? EdgeInsets.only(right: 10.0) : EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(1, 2),
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
                // Container(
                //   padding: EdgeInsets.all(8.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(7)),
                //     color: redColor,
                //   ),
                //   child: Text(
                //     DateFormat("dd MMMM yyyy").format(task.deadline).toString(),
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontFamily: 'Poppins',
                //         fontSize: 15.0,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),
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
                        '+${task.point}',
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
            SizedBox(
              height: 10.0,
            ),
            Text(
              task.title,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              DateFormat("dd MMMM yyyy").format(task.deadline).toString(),
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: thirdColor,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: greenColor,
              ),
              child: Text(
                task.category,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _countIncomeOutcome(String type, List<Financial> finances){
    return finances.where((element) => element.type == type).toList().fold(0, (previous, current) => previous + current.money);
  }

  _checkWishReminder(){
    if (_wish != null) {
      var frekuensi = _wish.frekuensi;
      _filteredFinancials = filterFinancial(frekuensi, _wish.createdAt);
      _outcome = _countIncomeOutcome("outcome", _filteredFinancials);
      _income = _countIncomeOutcome("income", _filteredFinancials);
    }
  }

  Widget _buildReminder(){
    var type;
    if (_wish != null) {
      type = _wish.frekuensi == 0 ? "hari" : _wish.frekuensi == 1 ? "minggu" : "bulan";
    } else {
      type = "";
    }
    return _wish != null
        ? Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: _filteredFinancials.length > 0 ? _income-_outcome > _wish.expectedMoney ? primaryColor : redColor : redColor,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.notifications, color: Colors.white,),
          SizedBox(height: 10.0,),
          _filteredFinancials.length > 0
              ? _income-_outcome >= _wish.expectedMoney
              ? Text(
            "Kamu sudah berhasil menabung sebanyak ${_income-_outcome} untuk impian ${_wish.title} pada ${type} ini",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          )
              : Text(
            "Tabunganmu untuk memenuhi impian pada ${type} ini masih belum tercapai. Kamu baru menabung sebanyak Rp ${_income-_outcome} dari Rp ${_wish.expectedMoney}.",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          )
              : Text(
            "Kamu belum ada menabung pada ${type} ini untuk impian ${_wish.title}. Kamu harus menabung sebanyak Rp ${_wish.expectedMoney}",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          )
        ],
      ),
    )
        : Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.notifications, color: Colors.white,),
          SizedBox(height: 10.0,),
          Text(
            "Kamu belum membuat satu impian",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.circular(5.0)
      ),
    );
  }
}
