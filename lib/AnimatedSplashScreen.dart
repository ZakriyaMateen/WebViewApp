
import 'package:flutter/material.dart';
import 'Utils.dart';
import 'WebView.dart';

class AnimateSplashScreenMobile extends StatefulWidget {
  const AnimateSplashScreenMobile({Key? key}) : super(key: key);

  @override
  State<AnimateSplashScreenMobile> createState() => _AnimateSplashScreenMobileState();
}

class _AnimateSplashScreenMobileState extends State<AnimateSplashScreenMobile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    colorChange();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.9), end: Offset(0, 0)).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> colorChange() async {
    Future.delayed(Duration(milliseconds: 1300), () {
      screenTransition();
    });
  }


  Future<void> screenTransition() async {

    Future.delayed(Duration(milliseconds: 1500), () {
      try {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WebApp()));
         }
         catch(e){
        print(e.toString());
         }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 550 ? 0 : w * 0.25, vertical: w < 550 ? 0 : h * 0.015),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  child: Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: RotationTransition(
                            turns: _rotationAnimation,
                            child: Image.asset('assets/dstlogo.png', height: 120, width: 120),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            text('Digital Secure Trade', Colors.black87, FontWeight.bold, 16.5),
          ],
        ),
      ),
    );
  }
}
