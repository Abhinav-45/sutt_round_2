import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Provider/provider.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);
    return ChangeNotifierProvider(
      create: (context) => SplashScreenModel(goRouter),
      builder: (context, _) {
        return _SplashScreenContent();
      },
    );
  }
}

class _SplashScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final splashScreenModel = Provider.of<SplashScreenModel>(context);
    splashScreenModel.initiateTask();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.movie_filter_outlined,
              size: screenHeight*0.15,
            ),
          ),
          SizedBox(height: screenHeight*0.05),
          CircularProgressIndicator(
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
