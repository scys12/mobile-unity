import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/provider/challenge_provider.dart';
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

  @override
  void initState() {
    super.initState();
    initData();
  }
  initData() async{
    _challengeProvider = Provider.of<ChallengeProvider>(context, listen: false);
    await _challengeProvider.getChallenge(challengeId: widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    _challengeProvider = Provider.of<ChallengeProvider>(context);
    _teenager = Provider.of<Teenager>(context);

    if (_challengeProvider.selectedChallenge != null && _challengeProvider.selectedChallenge.uid == widget.uid) {
      _challenge = _challengeProvider.selectedChallenge;
      _loading = false;
    }

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
              _challenge.key == "login" ? _buildLoginChallenge() : _challenge.key == "tabung" ? _buildTabungChallenge() : Container(),
            ],
          ) : Container()
        ]
      )
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
        "Kamu baru menabung dari ${_teenager.totalLogin} hari selama 7 hari",
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
