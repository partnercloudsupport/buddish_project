import 'package:buddish_project/constants.dart';
import 'package:buddish_project/ui/main/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(duration: Duration(seconds: 2), vsync: this)
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Navigator.of(context).pushReplacementNamed(MainScreen.route);
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: Image.asset(Asset.imageLoginBg, fit: BoxFit.cover)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120.0),
              Text(
                'ด้วยความร่วมมือจาก',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: AppColors.main, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Dimension.fieldVerticalMargin),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    Asset.logoCmu,
                    width: MediaQuery.of(context).size.width * .2,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    Asset.logoCamt,
                    width: MediaQuery.of(context).size.width * .24,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    Asset.logoMed,
                    width: MediaQuery.of(context).size.width * .24,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    Asset.lgoMjr,
                    width: MediaQuery.of(context).size.width * .2,
                    fit: BoxFit.cover,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
