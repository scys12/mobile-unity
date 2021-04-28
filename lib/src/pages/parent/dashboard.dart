import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/news.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/parent/child_task.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/child_tile.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DashboardParent extends StatefulWidget {
  @override
  _DashboardParentState createState() => _DashboardParentState();
}

class _DashboardParentState extends State<DashboardParent> {
  List<Child> children;
  final AuthService _authService = AuthService();
  int _currentIndex = 0;
  ChildProvider _childProvider;
  Parent user;
  Wish _wish;
  List<Financial> financials = [];
  bool _loading = true;
  List<Financial> _filteredFinancials = [];
  List<News> _news;
  int _income = 0;
  int _outcome = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<Parent>(context, listen: false);
    _childProvider = Provider.of<ChildProvider>(context, listen: false);
    _childProvider.getCurrentChild(parentId: user.uid);
  }

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
  Widget build(BuildContext context) {
    user = Provider.of<Parent>(context);
    children = Provider.of<List<Child>>(context);
    _childProvider = Provider.of<ChildProvider>(context);
    _wish = Provider.of<Wish>(context);
    financials = Provider.of<List<Financial>>(context);
    _news = Provider.of<List<News>>(context);
    _news = _news.take(5).toList();

    if (financials != null) {
      setState(() {
        _loading = false;
      });
      _checkWishReminder();
    }

    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          _buildProfile(),
          SizedBox(
            height: 15.0,
          ),
          _buildInformasiKeuangan(),
          _buildAktivitasAnak(),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: _buildReminder(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: _buildArticleHeader(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: _news.length > 0
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
          ),
        ],
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

  Widget _buildArticleHeader(){
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artikel Edukasi Finansial',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
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

  Widget _buildAktivitasAnak(){
    return Padding(
      padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
      child: SubHeader(isLihatSemua: false, title: "Aktivitas",),
    );
  }

  Widget _buildInformasiKeuangan(){
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondaryColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: _childProvider.selectedChild == null
            ? Text(
          "Anda belum menambahkan si kecil",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontFamily: 'Poppins',
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Text(
                  "Total Uang",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rp ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${_childProvider.selectedChild.income - _childProvider.selectedChild.outcome}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(
                        Colors.white),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10.0)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/parent/transactions');
                  },
                  child: Row(
                    children: [
                      Text(
                        "Histori Keuangan",
                        style: TextStyle(
                          color: secondaryColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: secondaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Point",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "${_childProvider.selectedChild.totalPoint}pts",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget _buildProfile(){
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60.0),
                bottomRight: Radius.circular(60.0)),
          ),
          margin: EdgeInsets.only(bottom: 50),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 30.0, bottom: 50.0, left: 20.0, right: 20.0),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        user.isProfileFilled
                            ? Text(
                          user.name,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        )
                            : TextButton(
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
                                context, '/parent/change_profile');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  thirdColor,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0)),
              ),
              onPressed: () {
                _addChildButtonPressed(_childProvider.selectedChild);
              },
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: _childProvider.selectedChild == null
                          ? Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Tambahkan anak",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5,
                              fontSize: 17.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          _childProvider.selectedChild.imageUrl.length > 0
                              ? ClipRRect(
                            child: Image.network(
                              _childProvider.selectedChild.imageUrl,
                              fit: BoxFit.fill,
                              height: 30,
                              width: 30,
                            ),borderRadius: BorderRadius.circular(20.0),)
                              : Icon(
                            Icons.account_circle,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            _childProvider.selectedChild.name,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5,
                              fontSize: 17.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 30.0,
                      color: Colors.black,
                    )
                  ],
                ),
              ]),
            ),
          ),
        )
      ],
    );
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
            "${_childProvider.selectedChild.name} sudah berhasil menabung sebanyak ${_income-_outcome} untuk impian ${_wish.title} pada ${type} ini",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          )
              : Text(
            "Tabungan ${_childProvider.selectedChild.name}  untuk memenuhi impian pada ${type} ini masih belum tercapai. ${_childProvider.selectedChild.name} baru menabung sebanyak Rp ${_income-_outcome} dari Rp ${_wish.expectedMoney}.",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          )
              : Text(
            "${_childProvider.selectedChild.name} belum ada menabung pada ${type} ini untuk impian ${_wish.title}. ${_childProvider.selectedChild.name} harus menabung sebanyak Rp ${_wish.expectedMoney}",
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
            _childProvider.selectedChild == null ? "Anda belum menambahkan si kecil" : "${_childProvider.selectedChild.name} belum membuat satu impian",
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

  int _countIncomeOutcome(String type, List<Financial> finances){
    return finances.where((element) => element.type == type).toList().fold(0, (previous, current) => previous + current.money);
  }

  _checkWishReminder(){
    if (_wish != null) {
      var expectedMoney = _wish.expectedMoney;
      var frekuensi = _wish.frekuensi;
      _filteredFinancials = filterFinancial(frekuensi, _wish.createdAt);
      _outcome = _countIncomeOutcome("outcome", _filteredFinancials);
      _income = _countIncomeOutcome("income", _filteredFinancials);
    }
  }

  void _addChildButtonPressed(Child child) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0XFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    children.length > 0
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ...children
                                  .asMap()
                                  .map((idx, val) => MapEntry(
                                      idx,
                                      ChildTile(
                                        childIndex: val,
                                        idx: idx,
                                      )))
                                  .values
                                  .toList()
                            ],
                          )
                        : ListTile(
                            title: Text(
                              'Belum menambahkan si kecil',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            trailing: Icon(
                              Icons.indeterminate_check_box,
                              color: primaryColor,
                            ),
                            onTap: () {},
                          ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/parent/add_child');
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        elevation: MaterialStateProperty.all<double>(0.0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            "Tambahkan anak",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
