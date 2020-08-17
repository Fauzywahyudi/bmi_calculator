import 'package:calculator_bmi/views/result.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

class Home extends StatefulWidget {
  static const routeName = '/Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController tecBB = TextEditingController();
  TextEditingController tecTB = TextEditingController();

  final String _dirImage = "assets/images/";
  bool isMale = true;
  bool isShowForm = false;

  Color get themeColor => isMale ? Colors.purple : Colors.pinkAccent;
  Color get colorSecondaryMale => isMale ? Colors.white : Colors.purple;
  Color get colorSecondaryFemale => !isMale ? Colors.white : Colors.pink;
  Color get colorSelectedMale => isMale ? Colors.purple : Colors.white;
  Color get colorSelectedFemale => !isMale ? Colors.pinkAccent : Colors.white;

  String get _fabText => isShowForm ? "Proses" : "Pilih";
  Icon get _fabIcon => isShowForm ? Icon(Icons.play_arrow) : Icon(Icons.check);

  double get _fontSizeTitle => isShowForm ? 15 : 25;
  double get _fontSizeGender => isShowForm ? 10 : 20;
  double get _opacityForm => isShowForm ? 1 : 0;
  double get _bb => double.parse(tecBB.text);
  double get _tb => double.parse(tecTB.text);

  bool get validasi => tecBB.text.isNotEmpty && tecTB.text.isNotEmpty;
  bool get isPotrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  void _onPressFAB() {
    if (isShowForm) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Result(
                    isMale: isMale,
                    bb: _bb,
                    tb: _tb,
                  )));
    } else {
      setState(() {
        isShowForm = !isShowForm;
      });
    }
  }

  _selectMale() {
    setState(() {
      if (!isMale) isMale = !isMale;
    });
  }

  _selectFemale() {
    setState(() {
      if (isMale) isMale = !isMale;
    });
  }

  Future<bool> _dialog()async{
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Exit',
      desc: 'Yakin Keluar Aplikasi',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
    )..show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    if (isShowForm) {
      setState(() {
        isShowForm = false;
      });
      return false;
    } else {
      _dialog();
    }
  }



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: themeColor,
      floatingActionButton: !isShowForm || validasi ? _buildFAB() : null,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            color: Colors.white,
            height: media.size.height,
            width: media.size.width,
            child: SingleChildScrollView(
              child: isPotrait ? _orienPotrait() : _orienLandscape(),
            )
          ),
        ),
      ),
    );
  }

  Widget _orienPotrait() {
    return Column(
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: GoogleFonts.mcLaren(
              fontSize: _fontSizeTitle, color: Colors.purple),
          duration: Duration(milliseconds: 500),
          child: Text("Select Gender"),
        ),
        _buildSelectGender(),
        _buildForm(),
        SizedBox(height: 60,)
      ],
    );
  }

  Widget _orienLandscape() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Column(
          children: <Widget>[
            AnimatedDefaultTextStyle(
              style: GoogleFonts.mcLaren(
                  fontSize: 15, color: Colors.purple),
              duration: Duration(milliseconds: 500),
              child: Text("Select Gender"),
            ),
            _buildSelectGender(),
          ],
        )),
        Expanded(child: _buildForm()),
      ],
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _onPressFAB(),
      backgroundColor: themeColor,
      label: AnimatedDefaultTextStyle(
          style: TextStyle(),
          duration: Duration(milliseconds: 500),
          child: Text(_fabText)),
      icon: _fabIcon,
    );
  }

  Widget _buildSelectGender() {
    var media = MediaQuery.of(context);
    return AnimatedContainer(
      height: isShowForm && isPotrait
          ? media.size.height * 0.3
          : !isShowForm && isPotrait
              ? media.size.height * 0.6
              : media.size.height - 50,
      duration: Duration(milliseconds: 600),
      child: Card(
        elevation: 3,
        shadowColor: themeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildGender("man.svg", colorSelectedMale, colorSecondaryMale,"Male"),
            _buildGender(
                "woman.svg", colorSelectedFemale, colorSecondaryFemale, "Female"),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return AnimatedOpacity(
      opacity: _opacityForm,
      duration: Duration(milliseconds: 600),
      child: Column(

        children: <Widget>[
          !isPotrait ? AnimatedDefaultTextStyle(
            style: GoogleFonts.mcLaren(
                fontSize: 15, color: Colors.purple),
            duration: Duration(milliseconds: 500),
            child: Text(""),
          ) :Container(),
          Card(
            elevation: 3,
            shadowColor: themeColor,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedContainer(
                    decoration: BoxDecoration(
                        color: themeColor, borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      "Silahkan Masukkan Berat Badan dan Tinggi Badan Anda",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mcLaren(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  AnimatedContainer(
                    decoration: BoxDecoration(
                        color: themeColor, borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    duration: Duration(milliseconds: 500),
                    child: Row(
                      children: <Widget>[
                        _label("Berat Badan"),
                        _textField("kg", tecBB),
                        _label("Tinggi Badan"),
                        _textField("cm", tecTB),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String label) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.mcLaren(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixText: label,
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget _buildGender(
      String fileName, Color colorSelected, Color colorSecondary, String gender) {
    return Expanded(
      child: AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: colorSelected, borderRadius: BorderRadius.circular(20)),
          duration: Duration(milliseconds: 500),
          child: InkWell(
            onTap: () {
              if (fileName == "man.svg") {
                _selectMale();
              } else {
                _selectFemale();
              }
            },
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Hero(
                  tag: fileName,
                  child: SvgPicture.asset(_dirImage + fileName,
                      color: colorSecondary),
                )),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 500),
                    style: GoogleFonts.mcLaren(
                        fontSize: _fontSizeGender, color: colorSecondary),
                    child: Text(
                      gender,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
