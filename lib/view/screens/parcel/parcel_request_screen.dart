import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/controller/order_controller.dart';
import 'package:talabiapp/controller/parcel_controller.dart';
import 'package:talabiapp/controller/splash_controller.dart';
import 'package:talabiapp/controller/user_controller.dart';
import 'package:talabiapp/data/model/body/place_order_body.dart';
import 'package:talabiapp/data/model/response/address_model.dart';
import 'package:talabiapp/data/model/response/parcel_category_model.dart';
import 'package:talabiapp/data/model/response/zone_response_model.dart';
import 'package:talabiapp/helper/price_converter.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/app_constants.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_app_bar.dart';
import 'package:talabiapp/view/base/custom_button.dart';
import 'package:talabiapp/view/base/custom_image.dart';
import 'package:talabiapp/view/base/custom_snackbar.dart';
import 'package:talabiapp/view/base/custom_text_field.dart';
import 'package:talabiapp/view/base/footer_view.dart';
import 'package:talabiapp/view/base/menu_drawer.dart';
import 'package:talabiapp/view/base/not_logged_in_screen.dart';
import 'package:talabiapp/view/screens/checkout/widget/condition_check_box.dart';
import 'package:talabiapp/view/screens/checkout/widget/payment_button.dart';
import 'package:talabiapp/view/screens/checkout/widget/tips_widget.dart';
import 'package:talabiapp/view/screens/parcel/widget/card_widget.dart';
import 'package:talabiapp/view/screens/parcel/widget/details_widget.dart';
import 'package:universal_html/html.dart' as html;

import '../checkout/widget/payment_button_new.dart';

class ParcelRequestScreen extends StatefulWidget {
  final ParcelCategoryModel parcelCategory;
  final AddressModel pickedUpAddress;
  final AddressModel destinationAddress;
  const ParcelRequestScreen({Key? key, required this.parcelCategory, required this.pickedUpAddress, required this.destinationAddress}) : super(key: key);

  @override
  State<ParcelRequestScreen> createState() => _ParcelRequestScreenState();
}

class _ParcelRequestScreenState extends State<ParcelRequestScreen> {
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _jawaliCode = TextEditingController();
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
  bool? _isCashOnDeliveryActive = false;
  bool? _isDigitalPaymentActive = false;
  bool? _isJwali = false;

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall(){
    if(_isLoggedIn) {
      Get.find<ParcelController>().getDistance(widget.pickedUpAddress, widget.destinationAddress);
      Get.find<ParcelController>().setPayerIndex(0, false);
      for(ZoneData zData in Get.find<LocationController>().getUserAddress()!.zoneData!){
        if(zData.id ==  Get.find<LocationController>().getUserAddress()!.zoneId){
          _isCashOnDeliveryActive = zData.cashOnDelivery! && Get.find<SplashController>().configModel!.cashOnDelivery!;
          _isDigitalPaymentActive = zData.digitalPayment! && Get.find<SplashController>().configModel!.digitalPayment!;
          if(Get.find<ParcelController>().payerIndex == 0) {
            Get.find<ParcelController>().setPaymentIndex(_isCashOnDeliveryActive! ? 0 : _isDigitalPaymentActive! ? 1 : 2, false);
          }else{
            Get.find<ParcelController>().setPaymentIndex(0, false);
          }

        }
      }
      if (Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      Get.find<OrderController>().updateTips(
        Get.find<AuthController>().getDmTipIndex().isNotEmpty ? int.parse(Get.find<AuthController>().getDmTipIndex()) : 0, notify: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

   OrderController orderController = Get.find();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          appBar: CustomAppBar(title: 'parcel_request'.tr),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: GetBuilder<ParcelController>(builder: (parcelController) {
            double charge = -1;
            if(parcelController.distance != -1 && _isLoggedIn && parcelController.extraCharge != null) {
              double parcelPerKmShippingCharge = widget.parcelCategory.parcelPerKmShippingCharge! > 0 ? widget.parcelCategory.parcelPerKmShippingCharge!
                  : Get.find<SplashController>().configModel!.parcelPerKmShippingCharge!;
              double parcelMinimumShippingCharge = widget.parcelCategory.parcelMinimumShippingCharge! > 0 ? widget.parcelCategory.parcelMinimumShippingCharge!
                  : Get.find<SplashController>().configModel!.parcelMinimumShippingCharge!;
              charge = parcelController.distance! * parcelPerKmShippingCharge;
              if(charge < parcelMinimumShippingCharge) {
                charge = parcelMinimumShippingCharge;
              }

              if(parcelController.extraCharge != null){
                charge = charge + parcelController.extraCharge!;
              }
            }


            return _isLoggedIn ? Column(children: [

              Expanded(child: SingleChildScrollView(
                padding: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  CardWidget(child: Row(children: [

                    Container(
                      height: 50, width: 50, alignment: Alignment.center,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.3), shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.parcelCategoryImageUrl}'
                              '/${widget.parcelCategory.image}',
                          height: 40, width: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.parcelCategory.name!, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                      Text(
                        widget.parcelCategory.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                      ),
                    ])),

                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CardWidget(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    DetailsWidget(title: 'sender_details'.tr, address: widget.pickedUpAddress),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    DetailsWidget(title: 'receiver_details'.tr, address: widget.destinationAddress),
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CardWidget(child: Row(children: [
                    Expanded(child: Row(children: [
                      Image.asset(Images.distance, height: 30, width: 30),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('distance'.tr, style: robotoRegular),
                        Text(
                          parcelController.distance == -1 ? 'calculating'.tr : '${parcelController.distance!.toStringAsFixed(2)} ${'km'.tr}',
                          style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ]),
                    ])),
                    Expanded(child: Row(children: [
                      Image.asset(Images.delivery, height: 30, width: 30),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('delivery_fee'.tr, style: robotoRegular),
                        Text(
                          parcelController.distance == -1 ? 'calculating'.tr : PriceConverter.convertPrice(charge),
                          style: robotoBold.copyWith(color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                        ),
                      ]),
                    ]))
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  (Get.find<SplashController>().configModel!.dmTipsStatus == 1) ?
                  GetBuilder<OrderController>(builder: (orderController) {
                      return Container(
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeSmall),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('delivery_man_tips'.tr, style: robotoMedium),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            height: (orderController.selectedTips == AppConstants.tips.length-1) && orderController.canShowTipsField ? 0 : 40,
                            child: (orderController.selectedTips == AppConstants.tips.length-1) && orderController.canShowTipsField ? const SizedBox() : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: AppConstants.tips.length,
                              itemBuilder: (context, index) {
                                return TipsWidget(
                                  title: (index != 0 && index != AppConstants.tips.length -1) ? PriceConverter.convertPrice(double.parse(AppConstants.tips[index].toString()), forDM: true) : AppConstants.tips[index].tr,
                                  isSelected: orderController.selectedTips == index,
                                  onTap: () {
                                    orderController.updateTips(index);
                                    if(orderController.selectedTips != 0 && orderController.selectedTips != AppConstants.tips.length-1){
                                      orderController.addTips(double.parse(AppConstants.tips[index]));
                                    }
                                    if(orderController.selectedTips == AppConstants.tips.length-1){
                                      orderController.showTipsField();
                                    }
                                    _tipController.text = orderController.tips.toString();
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: (orderController.selectedTips == AppConstants.tips.length-1) && orderController.canShowTipsField ? Dimensions.paddingSizeExtraSmall : 0),

                          orderController.selectedTips == AppConstants.tips.length-1 ? const SizedBox() : ListTile(
                            onTap: () => orderController.toggleDmTipSave(),
                            leading: Checkbox(
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              activeColor: Theme.of(context).primaryColor,
                              value: orderController.isDmTipSave,
                              onChanged: (bool? isChecked) => orderController.toggleDmTipSave(),
                            ),
                            title: Text('save_for_later'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                            contentPadding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            horizontalTitleGap: 0,
                          ),
                          SizedBox(height: orderController.selectedTips == AppConstants.tips.length-1 ? Dimensions.paddingSizeDefault : 0),

                          orderController.selectedTips == AppConstants.tips.length-1 ? Row(children: [
                            Expanded(
                              child: CustomTextField(
                                titleText: 'enter_amount'.tr,
                                controller: _tipController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.number,
                                onSubmit: (value) {
                                  if(value.isNotEmpty){
                                    if(double.parse(value) >= 0){
                                      orderController.addTips(double.parse(value));
                                    }else{
                                      showCustomSnackBar('tips_can_not_be_negative'.tr);
                                    }
                                  }else{
                                    orderController.addTips(0.0);
                                  }
                                },
                                onChanged: (String value) {
                                  if(value.isNotEmpty){
                                    if(double.parse(value) >= 0){
                                      orderController.addTips(double.parse(value));
                                    }else{
                                      showCustomSnackBar('tips_can_not_be_negative'.tr);
                                    }
                                  }else{
                                    orderController.addTips(0.0);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            InkWell(
                              onTap: (){
                                orderController.updateTips(0);
                                orderController.showTipsField();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: const Icon(Icons.clear),
                              ),
                            ),

                          ]) : const SizedBox(),

                        ]),
                      );
                    }
                  ) : const SizedBox.shrink(),
                  SizedBox(height: (Get.find<SplashController>().configModel!.dmTipsStatus == 1) ? Dimensions.paddingSizeExtraSmall : 0),

                  Text('charge_pay_by'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(children: [
                    Expanded(child: InkWell(
                      onTap: () => parcelController.setPayerIndex(0, true),
                      child: Row(children: [
                        Radio<String>(
                          value: parcelController.payerTypes[0],
                          groupValue: parcelController.payerTypes[parcelController.payerIndex],
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (String? payerType) => parcelController.setPayerIndex(0, true),
                        ),
                        Text(parcelController.payerTypes[0].tr, style: robotoRegular),
                      ]),
                    )),
                    _isCashOnDeliveryActive! ? Expanded(child: InkWell(
                      onTap: () => parcelController.setPayerIndex(1, true),
                      child: Row(children: [
                        Radio<String>(
                          value: parcelController.payerTypes[1],
                          groupValue: parcelController.payerTypes[parcelController.payerIndex],
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (String? payerType) => parcelController.setPayerIndex(1, true),
                        ),
                        Text(parcelController.payerTypes[1].tr, style: robotoRegular),
                      ]),
                    )) : const SizedBox(),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  _isCashOnDeliveryActive! ? PaymentButton(
                    icon: Images.cashOnDelivery,
                    title: 'cash_on_delivery'.tr,
                    subtitle: 'pay_your_payment_after_getting_item'.tr,
                    isSelected: parcelController.paymentIndex == 0,
                    onTap: () => parcelController.setPaymentIndex(0, true),
                  ) : const SizedBox(),
                  (_isDigitalPaymentActive! && parcelController.payerIndex == 0) ? PaymentButton(
                    icon: Images.digitalPayment,
                    title: 'digital_payment'.tr,
                    subtitle: 'faster_and_safe_way'.tr,
                    isSelected: parcelController.paymentIndex == 1,
                    onTap: () => parcelController.setPaymentIndex(1, true),
                  ) : const SizedBox(),
                  (Get.find<SplashController>().configModel!.customerWalletStatus == 1 && parcelController.payerIndex == 0) ? PaymentButton(
                    icon: Images.wallet,
                    title: 'wallet_payment'.tr,
                    subtitle: 'pay_from_your_existing_balance'.tr,
                    isSelected: parcelController.paymentIndex == 2,
                    onTap: () => parcelController.setPaymentIndex(2, true),
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  
        PaymentButton(
                    icon: Images.jwali,
                    isJwali: _phoneNumber.text.isNotEmpty&&_jawaliCode.text.isNotEmpty,
                    title: 'jwali'.tr,
                    subtitle: "",
                    isSelected:_phoneNumber.text.isNotEmpty&&_jawaliCode.text.isNotEmpty&&parcelController.paymentIndex == 3,
                    onTap: () {

                      // orderController.setPaymentMethod(3);
                      parcelController.setPaymentIndex(3, true);
                      // setState(() {
                      //   _isJwali=true;
                      // });
                      // Get.back();


 Alert( 
            
				context: context, 
        closeFunction: null,
        style: AlertStyle(isCloseButton: false),
        // closeIcon:cancelButton,
     
     


             
        
      
      
       
				title: "جوالي ", 
				content: Column( 
					children: <Widget>[ 

            TextField(
              
              keyboardType: TextInputType.number, 
             obscureText:false,
						decoration: InputDecoration( 
             
              label: Text("ادخل رقم الهاتف المرتبط بحساب جوالي "),
						icon: Icon(Icons.phone), 
    
						
            
            
						), 
                     
                     onChanged: ((value) {
                      setState(() {
                          _phoneNumber.text=value;
                      });
                    }),
                  
					), 
       
					TextField( 
             obscureText: false,
						decoration: InputDecoration( 
						icon: Icon(Icons.payment), 
           
              label: Text("ادخل رمز الشراء الذي تم توليده من تطبيق جوالي"),
    

            
            
						), 
                     
                     onChanged: ((value) {
                      setState(() {
                          _jawaliCode.text=value;
                      });
                    }),
                  
					), 
		
					], 
				), 

                              buttons: [ 
                        DialogButton( 
                          child: Text( 
                            "تاكيد", 
                            style: TextStyle(color: Colors.white, fontSize: 20), 
                          ), 
                          onPressed: () {
                            if(_jawaliCode.text.isNotEmpty&&_phoneNumber.text.isNotEmpty){
                              //_cash=2;
                           Navigator.pop(context);
                          orderController.setPaymentMethod(3);
                          }
                          }
                        ), 
                        DialogButton( 
                          child: Text( 
                            "الغاء", 
                            style: TextStyle(color: Colors.white, fontSize: 20), 
                          ), 
                          onPressed: () { 
                            
                            Navigator.pop(context);
                            //_cash = 0;
                             _phoneNumber.text="";
                             _jawaliCode.text="";

                          parcelController.setPaymentIndex(0, true);
                          
                          }
                        ) 
                      ], 
// 				buttons: [ 
// 					DialogButton( 
// 					onPressed: (){
//           //  openDialog();
//  if(_krimiCode.text.isNotEmpty){
// Navigator.pop(context);
//   orderController.setPaymentMethod(3);
//  }
         
//           }, 
// 					child: Text( 
// 						"موافق", 
// 						style: TextStyle(color: Colors.white, fontSize: 20), 
// 					), 
// 					) 
// 				]
        ).show();


                    },
                  ),



            //       orderController.loading?Center(child: CircularProgressIndicator()):
            //    Container(
            //     height: 57,
            //      child: PaymentButtonNew(        
            //   icon: 'assets/image/scash.png',
            //  // icon: const Icon(Icons.clear, size: 18.0),
            //   title: 'فلوسك',
            //   isJawali: true,
            //   isSelected: orderController.paymentMethodIndex == 4,
            //   onTap: () async{
            //     orderController.loadingMethod(context);


            //         //  widget.showingJwaliForm;
            //      // orderController.setPaymentMethod(4);
            //       // print("this the order change state${orderController.sh}")
            //       // Get.back();
            //        /// orderController.changeIsShwoingJwalii(true);
                    

            //   },
            // ),
            //    ), 





//الدفع 



      orderController.loading==true?const Center(child: CircularProgressIndicator()): 
      // orderController.loading==true?Center(child: Text("looding......",style: TextStyle(fontSize: 20),),):
      
       
       Container(
        
         child: PaymentButton(
                      icon: Images.jwali,
                      isJwali: _phoneNumber.text.isNotEmpty&&_jawaliCode.text.isNotEmpty,
                      title: 'فلوسك',
                      subtitle: "",
                      isSelected:_phoneNumber.text.isNotEmpty&&_jawaliCode.text.isNotEmpty&&parcelController.paymentIndex == 4,
                      onTap: ()async {
                          orderController.loading = false;
                          orderController.update();    
                        orderController.loadingMethod(context);
                        
                        parcelController.setPaymentIndex(4, true);
                        // orderController.setPaymentMethod(3);
                        print("=================aloading======================");
                        print(orderController.loading);
                        print("===============================================");
                    
                        setState(() {
                        //  _isJwali=true;
                        });  
                        // Get.back();
                      },
                    ),
       ),

                  CheckoutCondition(orderController: Get.find<OrderController>(), parcelController: parcelController, isParcel: true),

                  SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
                  ResponsiveHelper.isDesktop(context) ? _bottomButton(parcelController, charge) : const SizedBox(),

                ]))),
              )),

              ResponsiveHelper.isDesktop(context) ? const SizedBox() : _bottomButton(parcelController, charge),

            ]) : NotLoggedInScreen(callBack: (value) {
              initCall();
              setState(() {});
            });
          }),
        ),
     
       
   if(_isJwali==true)
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black54,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(top: 10  ),
          height: 440,
          width: MediaQuery.of(context).size.width*0.7,
          decoration: BoxDecoration(
                      color: Colors.white,

            borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                IconButton(onPressed: (){
                  setState(() {
                    _isJwali=false;
                  });
                }, icon: Icon(Icons.clear)),
                Container(
                  width: MediaQuery.of(context).size.width,alignment: Alignment.center,child: Image.asset(Images.jwali,height: 100,width: 100,)),
                SizedBox(height: 10,),
                 Padding(
                   padding: const EdgeInsets.only(right: 15,left: 15),
                   child: Text("ادخل رقم الهاتف"),
                 ),
                               SizedBox(height: 10,),
            
                 Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                   child: TextFormField(
                    // isPhone: true,
                    controller: _phoneNumber,
                           inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                    ,decoration: InputDecoration(
                    
 focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  )),


                    ),
                    onChanged: ((value) {
                      setState(() {
                        _phoneNumber.text=value;
                      });
                    }),
            
                   ),
                 ),

            
                   Padding(
  padding: const EdgeInsets.only(right: 15,left: 15),                   
    child: Text("ادخل كود الشراء المولد من تطبيق جوالي"),
                   ),
                               SizedBox(height: 10,),
            
                 Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                   child: TextFormField(
                     onChanged: ((value) {
                      setState(() {
                        _jawaliCode.text=value;
                      });
                    }),
                    // isPhone: true,
                    controller: _jawaliCode,
                           inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                    ,decoration: InputDecoration(
                    
 focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  )),


                    ),
            
                   ),
                 ),
                SizedBox(height: 15,),
                CustomButton(buttonText: "تاكيد",onPressed: (){
                if(_jawaliCode.text.isNotEmpty&&_phoneNumber.text.isNotEmpty){
                      // Navigator.of(context).pop();
                      setState(() {
                        _isJwali=false;
                      });
                }

                },)
            
              ],),
            ),
        ),
        )
    
    
    
    
     
      ],
    );
  }

  void orderCallback(bool isSuccess, String? message, String orderID, int? zoneID, double orderAmount, double? maxCodAmount) {
    Get.find<ParcelController>().startLoader(false);

 

    if(isSuccess) {
      _phoneNumber.text="";
_jawaliCode.text="";
      if(Get.find<OrderController>().isDmTipSave){
        Get.find<AuthController>().saveDmTipIndex(Get.find<OrderController>().selectedTips.toString());
      }
      if(Get.find<ParcelController>().paymentIndex == 1) {
        if(GetPlatform.isWeb) {
          Get.back();
          String? hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl = '${AppConstants.baseUrl}/payment-mobile?order_id=$orderID&&customer_id=${Get.find<UserController>()
              .userInfoModel!.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&status=';
          html.window.open(selectedUrl,"_self");
        } else{
          Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel!.id, 'parcel', orderAmount, _isCashOnDeliveryActive));
        }
      }else {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID));
      }
      Get.find<OrderController>().updateTips(-1, notify: false);
    }else {
      showCustomSnackBar(message);
    }
  }

  Widget _bottomButton(ParcelController parcelController, double charge) {
    return CustomButton(
      buttonText: 'confirm_parcel_request'.tr,
      isLoading: parcelController.isLoading,
      margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      onPressed: parcelController.acceptTerms ? () {
 

        if(parcelController.distance == -1) {
          showCustomSnackBar('delivery_fee_not_set_yet'.tr);
        }else if(_tipController.text.isNotEmpty && double.parse(_tipController.text.trim()) < 0) {
          showCustomSnackBar('tips_can_not_be_negative'.tr);
        }else {
          Get.find<ParcelController>().startLoader(true);
          Get.find<OrderController>().placeOrder(PlaceOrderBody(
            phoneNumber: _phoneNumber.text,
            paymen_type: _phoneNumber.text.isNotEmpty&&_jawaliCode.text.isNotEmpty?1:null,
            code: _jawaliCode.text,
            cart: [], couponDiscountAmount: null, distance: parcelController.distance, scheduleAt: null,
            orderAmount: charge, orderNote: '', orderType: 'parcel', receiverDetails: widget.destinationAddress,
            paymentMethod:_phoneNumber.text.isNotEmpty&&_jawaliCode.text.isNotEmpty&&parcelController.paymentIndex==3?'cash_on_delivery': parcelController.paymentIndex == 0 ? 'cash_on_delivery' : parcelController.paymentIndex == 1 ? 'digital_payment' : 'wallet',
            couponCode: null, storeId: null, address: widget.pickedUpAddress.address, latitude: widget.pickedUpAddress.latitude,
            longitude: widget.pickedUpAddress.longitude, addressType: widget.pickedUpAddress.addressType,
            contactPersonName: widget.pickedUpAddress.contactPersonName ?? '',
            contactPersonNumber: widget.pickedUpAddress.contactPersonNumber ?? '',
            streetNumber: widget.pickedUpAddress.streetNumber ?? '', house: widget.pickedUpAddress.house ?? '',
            floor: widget.pickedUpAddress.floor ?? '',
            discountAmount: 0, taxAmount: 0, parcelCategoryId: widget.parcelCategory.id.toString(),
            chargePayer: parcelController.payerTypes[parcelController.payerIndex], dmTips: _tipController.text.trim(),
            cutlery: 0, unavailableItemNote: '', deliveryInstruction: ''
          ), widget.pickedUpAddress.zoneId, orderCallback, 0, 0);
        }
      } : null,
    );
  }

}
