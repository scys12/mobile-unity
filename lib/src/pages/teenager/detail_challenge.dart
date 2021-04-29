import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/provider/challenge_provider.dart';
import 'package:mobile_unity/src/provider/finance_provider.dart';
import 'package:mobile_unity/src/services/challenge_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class DetailChallenge extends StatefulWidget {
  final String uid;
  DetailChallenge({this.uid});
  @override
  _DetailChallengeState createState() => _DetailChallengeState();
}

class _DetailChallengeState extends State<DetailChallenge> {
  Challenge _challenge;
  ChallengeProvider _challengeProvider;
  bool _loading = true;
  Teenager _teenager;
  FinancialProvider _financialProvider;
  List<Financial> financials = [];
  List<Financial> _filteredFinancials = [];
  int _income = 0;
  int _outcome = 0;
  final Set<int> date = {};

  List<Financial> filterFinancial(){
    List<Financial> filtered = [];
    var now = DateTime.now();
    var startDate = now.subtract(Duration(days: 6));
    filtered = financials.where((element) => (startDate.difference(element.createdAt).inDays <=0 && startDate.difference(element.createdAt).inDays >=-5)).toList();
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    initData();
  }
  initData() async{
    _teenager = Provider.of<Teenager>(context, listen: false);
    _challengeProvider = Provider.of<ChallengeProvider>(context, listen: false);
    await _challengeProvider.getChallenge(challengeId: widget.uid);
    _financialProvider = Provider.of<FinancialProvider>(context, listen: false);
    await _financialProvider.getFinancialBasedChildId(childId: _teenager.uid);
  }

  int _countIncomeOutcome(String type, List<Financial> finances){
    return finances.where((element) => element.type == type).toList().fold(0, (previous, current) => previous + current.money);
  }

  @override
  Widget build(BuildContext context) {
    _challengeProvider = Provider.of<ChallengeProvider>(context);
    _teenager = Provider.of<Teenager>(context);
    _financialProvider = Provider.of<FinancialProvider>(context);
    if (_challengeProvider.selectedChallenge != null && _challengeProvider.selectedChallenge.uid == widget.uid && _financialProvider.financials != null) {
      _challenge = _challengeProvider.selectedChallenge;
      _loading = false;
      financials = _financialProvider.financials;
    }

    _filteredFinancials = filterFinancial();
    _filteredFinancials.forEach((element) {
      if (element != null) {
        date.add(element.createdAt.day);
      }
    });
    _outcome = _countIncomeOutcome("outcome", _filteredFinancials);
    _income = _countIncomeOutcome("income", _filteredFinancials);

    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Detail Tantangan"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: [
          Icon(Icons.local_activity, size: 80.0, color: secondaryColor,),
          SizedBox(height: 10.0,),
          _buildTantanganProfile("Nama Tantangan"),
          SizedBox(height: 10.0,),
          Divider(height: 1.0, color: Colors.black,),
          SizedBox(height: 20.0,),
          _buildField(_challenge.title),
          SizedBox(height: 10.0,),
          _buildTantanganProfile("Deskripsi"),
          SizedBox(height: 10.0,),
          Divider(height: 1.0, color: Colors.black,),
          SizedBox(height: 20.0,),
          _buildField(_challenge.description),
          SizedBox(height: 10.0,),
          _buildTantanganProfile("Status"),
          SizedBox(height: 10.0,),
          Divider(height: 1.0, color: Colors.black,),
          SizedBox(height: 20.0,),
          _buildStatusField(),
          SizedBox(height: 20.0,),
          !_challenge.isDone ? Column(
            children: [
              _buildTantanganProfile("Progress"),
              SizedBox(height: 10.0,),
              Divider(height: 1.0, color: Colors.black,),
              SizedBox(height: 20.0,),
              _challenge.key == "login" ? _buildLoginChallenge() : _challenge.key == "tabung" ? _buildTabungChallenge() : _buildKumpulChallenge(),
            ],
          ) : Container()
        ]
      )
    );
  }

  Widget _buildKumpulChallenge(){
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        "Kamu baru mengumpulkan uang sebesar Rp ${_income-_outcome} dari ${date.length} hari selama 7 hari",
        style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontFamily: "Poppins"
        ),
      ),
    );
  }

  Widget _buildTabungChallenge(){
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        "Kamu baru menabung dari ${date.length} hari selama 7 hari",
        style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontFamily: "Poppins"
        ),
      ),
    );
  }

  Widget _buildLoginChallenge(){
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        "Login ${_teenager.totalLogin} hari dari 7 hari",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontFamily: "Poppins"
        ),
      ),
    );
  }

  Widget _buildStatusField(){
    return Container(
      decoration: BoxDecoration(
        color: _challenge.isDone ? greenColor : redColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.white),
        title: Text(
          _challenge.isDone ? "Sudah Selesai" : "Belum Selesai",
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget _buildTantanganProfile(String name){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20.0,
              color: shadowColor,
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  Widget _buildField(String field){
    return Text(
      field,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
    );
  }
}
