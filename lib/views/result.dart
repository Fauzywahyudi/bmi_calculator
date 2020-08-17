import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Result extends StatefulWidget {
  final bool isMale;
  final double bb;
  final double tb;

  const Result({Key key, this.isMale, this.bb, this.tb}) : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final String _fileMale = "man.svg";
  final String _fileFemale = "woman.svg";
  Color get themeColor => widget.isMale ? Colors.purple : Colors.pinkAccent;
  String get fileSVG => widget.isMale ? _fileMale : _fileFemale;

  final resFormat = NumberFormat('###.0', 'en_US');

  double result;
  double resultBrosca;

  @override
  void initState() {
    result = widget.bb / pow((widget.tb / 100), 2);
    if (widget.isMale) {
      resultBrosca = ((widget.tb - 100) - (widget.tb - 100) * 0.1);
    } else {
      resultBrosca = ((widget.tb - 100) - (widget.tb - 100) * 0.15);
    }

    print(resFormat.format(result));
    print(resFormat.format(resultBrosca));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Hasil Perhitungan",
                  style: GoogleFonts.mcLaren(fontSize: 25, color: themeColor),
                ),
              ),
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? OrienPotrait(
                      isMale: widget.isMale,
                      file: fileSVG,
                      resultBMI: result,
                      resultBrosca: resultBrosca,
                    )
                  : OrienLandscape(
                      isMale: widget.isMale,
                      file: fileSVG,
                      resultBMI: result,
                      resultBrosca: resultBrosca,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrienLandscape extends StatelessWidget {
  final String file;
  final bool isMale;
  final double resultBMI;
  final double resultBrosca;

  const OrienLandscape(
      {Key key, this.file, this.isMale, this.resultBMI, this.resultBrosca})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: BuildImage(
              file: file,
              isMale: isMale,
            ),
          ),
          Expanded(
            child: BuildResult(
              isMale: isMale,
              resultBMI: resultBMI,
              resultBrosca: resultBrosca,
            ),
          )
        ],
      ),
    );
  }
}

class OrienPotrait extends StatelessWidget {
  final String file;
  final bool isMale;
  final double resultBMI;
  final double resultBrosca;

  const OrienPotrait(
      {Key key, this.file, this.isMale, this.resultBMI, this.resultBrosca})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: BuildImage(
            file: file,
            isMale: isMale,
          ),
        ),
        Expanded(
          child: BuildResult(
            isMale: isMale,
            resultBMI: resultBMI,
            resultBrosca: resultBrosca,
          ),
        )
      ],
    ));
  }
}

class BuildImage extends StatelessWidget {
  final String file;
  final bool isMale;

  const BuildImage({Key key, this.file, this.isMale}) : super(key: key);
  String get fileSVG => this.file;
  final String _dirImage = "assets/images/";
  Color get themeColor => isMale ? Colors.purple : Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.5
          : MediaQuery.of(context).size.height * 0.7,
      child: Hero(
        tag: fileSVG,
        child: SvgPicture.asset(
          _dirImage + fileSVG,
          color: themeColor,
        ),
      ),
    );
  }
}

class BuildResult extends StatelessWidget {
  final double resultBMI;
  final double resultBrosca;
  final bool isMale;

  BuildResult({Key key, this.resultBMI, this.resultBrosca, this.isMale})
      : super(key: key);

  get result => resultBMI;
  TextStyle styleBMI(Color color) {
    return GoogleFonts.mcLaren(color: color, fontSize: 20);
  }

  var resFormat = NumberFormat('###.0', 'en_US');
  Color get _colorStatus => _statusBMI().contains("Kurus")
      ? Colors.lime
      : _statusBMI().contains("Gemuk") ? Colors.red : Colors.green;

  String _statusBMI() {
    String res = "";
    if (result < 17) {
      res = "Sangat Kurus";
    } else if (result >= 17 && result <= 18.5) {
      res = "Kurus";
    } else if (result > 18.5 && result <= 25) {
      res = "Normal";
    } else if (result > 25 && result <= 27) {
      res = "Gemuk";
    } else if (result > 27) {
      res = "Sangat Gemuk";
    }
    return res;
  }

  Color get themeColor => isMale ? Colors.purple : Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: '',
                  style: GoogleFonts.comicNeue(),
                  children: <TextSpan>[
                    TextSpan(text: 'B', style: styleBMI(Colors.lightBlue)),
                    TextSpan(text: 'M', style: styleBMI(Colors.lightGreen)),
                    TextSpan(text: 'I ', style: styleBMI(Colors.pink)),
                    TextSpan(
                        text: '= ',
                        style: GoogleFonts.mcLaren(
                            fontSize: 25, color: Colors.black)),
                    TextSpan(
                        text: '${resFormat.format(result)} ',
                        style: styleBMI(_colorStatus ?? Colors.green)
                            .copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'kg/m', style: styleBMI(Colors.black)),
                  ],
                ),
              ),
              Text(
                "2",
                textScaleFactor: 0.7,
              ),
            ],
          ),
          Text(
            _statusBMI() ?? "",
            style: GoogleFonts.mcLaren(
                color: _colorStatus ?? Colors.green,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Berat Badan Ideal Anda Menurut Brosca",
            style: GoogleFonts.lato(fontSize: 17),
          ),
          SizedBox(
            height: 15,
          ),
          RichText(
            text: TextSpan(
              text: '',
              style: GoogleFonts.comicNeue(),
              children: <TextSpan>[
                TextSpan(
                    text: resFormat.format(resultBrosca),
                    style: GoogleFonts.mcLaren(
                        color: _colorStatus ?? Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                TextSpan(text: ' kg', style: styleBMI(Colors.black)),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.check_circle_outline, color: Colors.white),
                label: Text(
                  'Selesai',
                  style: TextStyle(color: Colors.white),
                ),
                color: themeColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
