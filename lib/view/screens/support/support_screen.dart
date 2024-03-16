import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/data/model/response/social_media.dart';
import 'package:talabiapp/data/model/response/social_media.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_app_bar.dart';
import 'package:talabiapp/view/base/custom_snackbar.dart';
import 'package:talabiapp/view/base/footer_view.dart';
import 'package:talabiapp/view/base/menu_drawer.dart';
import 'package:talabiapp/view/screens/support/widget/support_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/view/screens/support/widget/support_button2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import '../../../controller/splash_controllerS.dart';
import '../../../data/model/response/social_media.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportScreen extends StatefulWidget {
 
  const SupportScreen({Key? key}) : super(key: key);
   


  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
List<Concat> concat=[];
final String whasta="";
  @override
  Widget build(BuildContext context) {
    SplashControllerS controllerS =Get.put(SplashControllerS());
    return Scaffold(
      appBar: CustomAppBar(title: 
      // "تواصل معنا"
      'help_and_support'.tr
      ),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: 

      FutureBuilder(
        future: getDtat(),
        
        builder: (context, snapshot) 
        {

          if(snapshot.hasData){


            

          

 
return   Scrollbar(child: SingleChildScrollView(
        padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.all(Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        child: Center(child: FooterView(
          child: SizedBox(width: Dimensions.webMaxWidth, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Image.asset(Images.supportImage, height: 120),
            // const SizedBox(height: 30),

            // Image.asset(Images.logo, width: 200),
            // const SizedBox(height: Dimensions.paddingSizeSmall),
            /*Text(AppConstants.APP_NAME, style: robotoBold.copyWith(
              fontSize: 20, color: Theme.of(context).primaryColor,
            )),*/
            // const SizedBox(height: 30),
            Text("كيف يمكننا مساعدتك", style: robotoBold.copyWith(
              fontSize: 16, color: Theme.of(context).primaryColor,
            )),

              Text("فريقنا جاهز لاستقبال استفساراتكم وحل\n مشاكلكم طوال أيام الأسبوع", style: robotoBold.copyWith(
              fontSize: 14, color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal
            )),
SizedBox(height: 30,),
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("للحصول على رد سريع في الحال:", style: robotoBold.copyWith(
              fontSize: 16, color: Theme.of(context).primaryColor,
            )),

Row(children: [

Container(
  height: 20,width: 
  20,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.green)
  ),child: Icon(Icons.done,color: Colors.green,size: 12,)),
  SizedBox(width: 8,)
       ,Text("تعديل الطلب", style: robotoBold.copyWith(
               fontSize: 14, color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal
            )),
],)

,Row(children: [

Container(
  height: 20,width: 
  20,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.green)
  ),child: Icon(Icons.done,color: Colors.green,size: 12,)),
  SizedBox(width: 8,)
       ,Text( "وجهتك مشكلة", style: robotoBold.copyWith(
              fontSize: 14, color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal
            )),
],)

                  

                          ],
                        ),

           
SizedBox(height: 50,),

       Row(

        mainAxisAlignment: MainAxisAlignment.center,children: [

            //  SupportButton(
            //   icon: Icons.location_on,
            //   //  title: 'address'.tr, 
            //    color: Colors.blue,
            //   // info: Get.find<SplashController>().configModel!.address,
            //   onTap: () {},
            // ),
            // const SizedBox(height: Dimensions.paddingSizeSmall),

            SupportButton(
              icon: Icons.call,
              // , title: 'call'.tr, 
              color: Colors.red,
              // info: Get.find<SplashController>().configModel!.phone,
              onTap: () async {
                if(await canLaunchUrlString('tel:${Get.find<SplashController>().configModel!.phone}')) {
                  launchUrlString('tel:${Get.find<SplashController>().configModel!.phone}');
                }else {
                  showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel!.phone}');
                }
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SupportButton(
              icon: Icons.mail_outline,
              // , title: 'email_us'.tr, 
              color: Color.fromARGB(255, 10, 111, 226),
              // info: Get.find<SplashController>().configModel!.email,
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: Get.find<SplashController>().configModel!.email,
                );
                launchUrlString(emailLaunchUri.toString());
              },
            ),


                 SupportButton(
              icon: Icons.facebook,
              // , title: 'email_us'.tr, 
              color: Color.fromARGB(255, 0, 17, 255),
              // info: Get.find<SplashController>().configModel!.email,
              onTap: () async{
            // final Uri whatsappLaunchUri = Uri.parse('whatsapp://send?phone=+967777639112');//https://www.facebook.com/profile.pnp?ip=61554082190952
           // await launchUrl(Uri.parse(data[2]["link"]));
            await launchUrl( Uri.parse(data[2]["link"]), mode: LaunchMode.externalApplication);
            // await launchUrl(Uri.parse('https://www.facebook.com/profile.pnp?ip=61554082190952'));

            print("=======================") ;

              getDtat() ; 
              },
            ),




                            SupportButtons(
                FontAwesomeIcons:FontAwesomeIcons.whatsapp,
          
              color: Colors.green,
              onTap: () async{
            //await launchUrl(Uri.parse(data[3]["link"]));
            await launchUrl( Uri.parse(data[3]["link"]), mode: LaunchMode.externalApplication);
              
              }, 
            ),

                SupportButtons(
                FontAwesomeIcons:FontAwesomeIcons.twitter,
          
              color: Color.fromARGB(255, 2, 156, 216),
              onTap: () async{
           // await launchUrl(Uri.parse(data[1]["link"]));
              await launchUrl( Uri.parse(data[1]["link"]), mode: LaunchMode.externalApplication);
         
              
              }, 
            ),


          


            
             
       ],),

        Row(

 mainAxisAlignment: MainAxisAlignment.center,children: [

                            SupportButtons(
                FontAwesomeIcons:FontAwesomeIcons.instagram,
          
              color: Colors.orange,
              onTap: () async{
           // await launchUrl(Uri.parse(data[1]["link"]));
              await launchUrl( Uri.parse(data[0]["link"]), mode: LaunchMode.externalApplication);
         
              
              }, 
            ),


            ],),











        
          
          ]
          )
          ),
        )),


      ));



        
          }
          else{
              return Center(child: CircularProgressIndicator());
          }



        
      },)




    
    );

    


    





  }
var data;
  Future<List<Concat>>getDtat() async{
    final response=await http.get(Uri.parse("https://talabi-ye.com/api/v1/contact-us"));
     data=jsonDecode(response.body.toString());
    print("=============== Data ============= ") ;
    print(data) ;
    print(data[1]["link"]);
    print("=============== Data ============= ") ;
    if(response.statusCode==200){
      for(Map<String,dynamic>index in data){
        concat.add(Concat.fromJson(index));

        


      }
      return concat;

     
    }

    else{
      return concat;
    }
  }





}



class testwidget extends StatelessWidget {
  const testwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
