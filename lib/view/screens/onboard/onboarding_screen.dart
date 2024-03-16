import 'package:talabiapp/controller/onboarding_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_button.dart';
import 'package:talabiapp/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    Get.find<OnBoardingController>().getOnBoardingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      body: SafeArea(
        child: GetBuilder<OnBoardingController>(
          builder: (onBoardingController) => onBoardingController.onBoardingList.isNotEmpty ? SafeArea(
            child: SizedBox(width: Dimensions.webMaxWidth, child: Column(children: [

              Expanded(child: PageView.builder(
                itemCount: onBoardingController.onBoardingList.length,
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    // color: Colors.black45,
                    height: MediaQuery.of(context).size.height,
                    // color: Colors.green,
                    child: Column(
                        // mainAxisAlignment:index==0? MainAxisAlignment.end:MainAxisAlignment.center
                        // ,
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // if(index==2)
                      Container(
                        // color:index= Colors.green,
                        height: MediaQuery.of(context).size.height*0.6,
                        padding: EdgeInsets.only(top: 80),
                        alignment: Alignment.bottomCenter,
                        child:
                        // index==2||index==0?
                        Column(
                          children: [
                            Image.asset(onBoardingController.onBoardingList[index].imageUrl, height:300, fit: BoxFit.cover,),
                          ],
                        )
                        // :SizedBox(),
                      ),
                   // if(index==2)
                   //    Image.asset(onBoardingController.onBoardingList[index].imageUrl, height: context.height*0.4),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22),

                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          onBoardingController.onBoardingList[index].title,
                          style: robotoMedium.copyWith(fontSize: 15,
                          color: Theme.of(context).secondaryHeaderColor),
                          textAlign:index==1?TextAlign.start:TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 1),
                   if(index>1)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        // alignment:,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          onBoardingController.onBoardingList[index].description,
                          style: robotoRegular.copyWith(fontSize: 15, color:index==1? Theme.of(context).primaryColor:
                          Theme.of(context).secondaryHeaderColor),
                          textAlign:index==1?TextAlign.start: TextAlign.center,
                        ),
                      ),

                    ]),
                  );
                },
                onPageChanged: (index) {
                  onBoardingController.changeSelectIndex(index);
                },
              )),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: _pageIndicators(onBoardingController, context),
              // ),
              // SizedBox(height: context.height*0.05),

              // onBoardingController.selectedIndex==1? SizedBox(): 
                Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                     onBoardingController.selectedIndex == 1||onBoardingController.selectedIndex == 2 ? const SizedBox() : Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color:  Theme.of(context).secondaryHeaderColor,
                         borderRadius: BorderRadius.circular(10)
                      ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                      child: CustomButton(
                        transparent: true,
                        onPressed: () {
                          Get.find<SplashController>().disableIntro();
                          Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                              //  Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());

                        },
                        buttonText: 'skip'.tr,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      buttonText: onBoardingController.selectedIndex != 2 ? 'next'.tr : 'get_started'.tr,
                      onPressed: () {
                        if(onBoardingController.selectedIndex != 2) {
                          _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                        }else {
                          Get.find<SplashController>().disableIntro();
                         Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                             Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());

                        }
                      },
                    ),
                  ),
                ]),
              ),

            ])),
          ) : const SizedBox(),
        ),
      ),
    );
  }

  List<Widget> _pageIndicators(OnBoardingController onBoardingController, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingController.onBoardingList.length; i++) {
      indicators.add(
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: i == onBoardingController.selectedIndex ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            borderRadius: i == onBoardingController.selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return indicators;
  }
}
