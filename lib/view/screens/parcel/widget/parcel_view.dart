import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/order_controller.dart';
import 'package:talabiapp/controller/parcel_controller.dart';
import 'package:talabiapp/data/model/response/address_model.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_button.dart';
import 'package:talabiapp/view/base/custom_snackbar.dart';
import 'package:talabiapp/view/base/custom_text_field.dart';
import 'package:talabiapp/view/base/footer_view.dart';
import 'package:talabiapp/view/base/my_text_field.dart';
import 'package:talabiapp/view/base/text_field_shadow.dart';
import 'package:talabiapp/view/screens/location/pick_map_screen.dart';
import 'package:talabiapp/view/screens/location/widget/serach_location_widget.dart';
import 'package:talabiapp/view/screens/parcel/widget/address_dialog.dart';

class ParcelView extends StatefulWidget {
  final bool isSender;
  final Widget bottomButton;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController houseController;
  final TextEditingController floorController;

  const ParcelView(
      {Key? key,
      required this.isSender,
      required this.nameController,
      required this.phoneController,
      required this.streetController,
      required this.houseController,
      required this.floorController,
      required this.bottomButton})
      : super(key: key);

  @override
  State<ParcelView> createState() => _ParcelViewState();
}

class _ParcelViewState extends State<ParcelView> {
  ScrollController scrollController = ScrollController();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }
  int nameLastLength = 0;
  int phneLastLength = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return
      Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(bottom: 5,right: 5,left: 5,top: 5),
              height: 100,
              decoration: BoxDecoration(

              ),
              child: InkWell(
                    onTap: () {
                              //   if(Get.find<AuthController>().isLoggedIn()) {
                              //   Get.dialog(AddressDialog(onTap: (AddressModel address) {
                              //     widget.streetController.text = address.streetNumber ?? '';
                              //     widget.houseController.text = address.house ?? '';
                              //     widget.floorController.text = address.floor ?? '';
                              //   }));
                              // }else {
                              //   showCustomSnackBar('you_are_not_logged_in'.tr);
                              // }
          try{
       Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                    fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) {
                    if(
                      // parcelController.isPickedUp==true
                      widget.isSender
                      ) {
                      parcelController.setPickupAddress(address, true);
                    }else {
                      parcelController.setDestinationAddress(address);
                    }
                  },
                  ));}catch(e){
                       print("this the error from getting address ${e} = ==  == =  =  = = =");
                  }

                     } ,
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[200],
                            ),
                            child: Icon(
                              Icons.flag_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                           widget.isSender? "الاستلام من":"التوصيل الى"
                            )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "اختر الموقع",
                            style: TextStyle(
                              color: Colors.blue[400],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            child: Icon(Icons.arrow_back_ios_new,
                                color: Colors.blue[400]),
                          ),
                        ],
                      )
                    ],
                  ),

Container(
  width: MediaQuery.of(context).size.width,
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Container(
                      margin: EdgeInsets.only(right: 20),
                      // width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomRight,
                      child: Text(
                       widget.isSender? "اختر مكان الاستلام":"اختر مكان التوصيل",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  GetBuilder<ParcelController>(builder:(controller) {
                    print("this the destination address ${controller.destinationAddress} = = = = =c = = =");
                    return Column(
                      children: [
                            if(
                              (widget.isSender&&controller.pickupAddress!=null)||
                            (!widget.isSender&&controller.destinationAddress!=null))

                        Container(
                               height: 25,
                               width: 25,

                               decoration: BoxDecoration(
                                color:
                                Theme.of(context).primaryColor

                                ,
                                border: Border.all(color: Colors.black

                                ),
                                shape: BoxShape.circle
                               ),
                               child: Icon(Icons.done,color: Colors.white,),
                        ),
                      ],
                    );
                  },)

  ],),
)
                ]),
              ),
            ),
          ),


      if(widget.isSender)
       Column(children: [

                Center(child: Text(parcelController.isSender ? 'sender_information'.tr : 'receiver_information'.tr, style: robotoMedium)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

               TextFieldShadow(
                  child: MyTextField(
                    hintText: parcelController.isSender ? 'sender_name'.tr : 'receiver_name'.tr,
                    inputType: TextInputType.name,
                    controller: widget.nameController,
                    focusNode: _nameNode,
                    nextFocus: _phoneNode,
                    // capitalization: TextCapitalization.words,
                    onChanged: (String data){
                        // widget.nameController.text=data;
                      if (!Platform.isLinux) return;
                      if (nameLastLength < data.length) {
                        var chr = data[0];
                        data = data.substring(1) + chr;
                        widget.nameController.text = data;
                      } else {
                        data = utf8.decode(data.codeUnits.reversed.toList());
                      }

                      nameLastLength = data.length;
                      setState(() {
                        widget.nameController.selection = TextSelection.fromPosition(TextPosition(offset: widget.nameController.text.length));

                      });
                        print(" this the data  $data");
                    },
                  ),
                ),




            // CustomTextField(
            //         controller: widget.nameController,
            //         hintText: parcelController.isSender ? 'sender_name'.tr : 'receiver_name'.tr,
            //   // maxLines: 3,
            //     focusNode: _nameNode,
            //         nextFocus: _phoneNode,
            //   inputType: TextInputType.multiline,
            //   inputAction: TextInputAction.done,
            //   capitalization: TextCapitalization.sentences,
            //   onChanged:  (String data){
            //           setState(() {
            //             widget.nameController.text=data;
            //           });
            //         },
            // ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TextFieldShadow(
                  child: MyTextField(
                    hintText: parcelController.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
                    inputType: TextInputType.phone,
                    focusNode: _phoneNode,
                    nextFocus: _streetNode,
                    controller: widget.phoneController,
                    onChanged: (String data){
                      if (!Platform.isLinux) return;
                      if (phneLastLength < data.length) {
                        var chr = data[0];
                        data = data.substring(1) + chr;
                        widget.nameController.text = data;
                      } else {
                        data = utf8.decode(data.codeUnits.reversed.toList());
                      }

                      phneLastLength = data.length;
                      setState(() {
                        widget.phoneController.selection = TextSelection.fromPosition(TextPosition(offset: widget.phoneController.text.length));

                      });


                    },
                  ),
                ),
            //                 CustomTextField(
            //          hintText: parcelController.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
            //         inputType: TextInputType.phone,
            //
            //         controller: widget.phoneController,
            //         onChanged: (String data){
            //           setState(() {
            //             widget.phoneController.text=data;
            //           });
            //         },
            // ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
/*
                 Center(child: Text(parcelController.isSender ? 'pickup_information'.tr : 'destination_information'.tr, style: robotoMedium)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TextFieldShadow(
                  child: MyTextField(
                    hintText: "${'street_number'.tr} (${'optional'.tr})",
                    inputType: TextInputType.streetAddress,
                    focusNode: _streetNode,
                    nextFocus: _houseNode,
                    controller: widget.streetController,
                     onChanged: (String data){
                      setState(() {
                        widget.streetController.text=data;
                      });
                    },

                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(children: [
                  Expanded(
                    child: TextFieldShadow(
                      child: MyTextField(
                        hintText: "${'house'.tr} (${'optional'.tr})",
                        inputType: TextInputType.text,
                        focusNode: _houseNode,
                        nextFocus: _floorNode,
                        controller: widget.houseController,
                         onChanged: (String data){
                      setState(() {
                        widget.houseController.text=data;
                      });
                    },
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: TextFieldShadow(
                      child: MyTextField(
                        hintText: "${'floor'.tr} (${'optional'.tr})",
                        inputType: TextInputType.text,
                        focusNode: _floorNode,
                        inputAction: TextInputAction.done,
                        controller: widget.floorController,
                          onChanged: (String data){
                      setState(() {
                        widget.floorController.text=data;
                      });
                    },
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),
            */

             ])

           ,if(widget.isSender==false)
              Column(children: [
      Center(child: Text(widget.isSender ? 'sender_information'.tr : 'receiver_information'.tr, style: robotoMedium)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TextFieldShadow(
                  child: MyTextField(
                    hintText: widget.isSender==false ?'receiver_name'.tr: 'sender_name'.tr,
                    inputType: TextInputType.name,
                    controller: widget.nameController,
                    focusNode: _nameNode,
                    nextFocus: _phoneNode,
                    capitalization: TextCapitalization.words,
                    onChanged: (String data){
                      if (!Platform.isLinux) return;
                      if (nameLastLength < data.length) {
                        var chr = data[0];
                        data = data.substring(1) + chr;
                        widget.nameController.text = data;
                      } else {
                        data = utf8.decode(data.codeUnits.reversed.toList());
                      }

                      nameLastLength = data.length;
                      setState(() {
                        widget.nameController.selection = TextSelection.fromPosition(TextPosition(offset: widget.nameController.text.length));

                      });


                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TextFieldShadow(
                  child: MyTextField(
                    hintText: widget.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
                    inputType: TextInputType.phone,
                    focusNode: _phoneNode,
                    nextFocus: _streetNode,
                    controller: widget.phoneController,
                    onChanged: (String data){
                      if (!Platform.isLinux) return;
                      if (phneLastLength < data.length) {
                        var chr = data[0];
                        data = data.substring(1) + chr;
                        widget.nameController.text = data;
                      } else {
                        data = utf8.decode(data.codeUnits.reversed.toList());
                      }

                      phneLastLength = data.length;
                      setState(() {
                        widget.phoneController.selection = TextSelection.fromPosition(TextPosition(offset: widget.phoneController.text.length));

                      });

                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                ]),



        ],
      );

   /*

   return SizedBox(width: Dimensions.webMaxWidth, child: GetBuilder<ParcelController>(builder: (parcelController) {

        return SingleChildScrollView(
          controller: ScrollController(),
          child: Center(child: FooterView(
            child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),

                SearchLocationWidget(
                  mapController: null,
                  pickedAddress: parcelController.isSender ? parcelController.pickupAddress!.address : parcelController.destinationAddress != null ? parcelController.destinationAddress!.address : '',
                  isEnabled: widget.isSender ? parcelController.isPickedUp : !parcelController.isPickedUp!,
                  isPickedUp: parcelController.isSender,
                  hint: parcelController.isSender ? 'pick_up'.tr : 'destination'.tr,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Expanded(flex: 4,
                    child: CustomButton(
                      buttonText: 'set_from_map'.tr,
                      onPressed: () => Get.toNamed(RouteHelper.getPickMapRoute('parcel', false), arguments: PickMapScreen(
                        fromSignUp: false, fromAddAddress: false, canRoute: false, route: '', onPicked: (AddressModel address) {
                        if(parcelController.isPickedUp!) {
                          parcelController.setPickupAddress(address, true);
                        }else {
                          parcelController.setDestinationAddress(address);
                        }
                      },
                      )),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(flex: 6,
                      child: InkWell(
                        onTap: (){
                          if(Get.find<AuthController>().isLoggedIn()) {
                            Get.dialog(AddressDialog(onTap: (AddressModel address) {
                              widget.streetController.text = address.streetNumber ?? '';
                              widget.houseController.text = address.house ?? '';
                              widget.floorController.text = address.floor ?? '';
                            }));
                          }else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Container(
                          height: ResponsiveHelper.isDesktop(context) ? 44 : 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
                          child: Center(child: Text('set_from_saved_address'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 14))),
                        ),
                      )
                  ),
                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                Column(children: [

                  Center(child: Text(parcelController.isSender ? 'sender_information'.tr : 'receiver_information'.tr, style: robotoMedium)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TextFieldShadow(
                    child: MyTextField(
                      hintText: parcelController.isSender ? 'sender_name'.tr : 'receiver_name'.tr,
                      inputType: TextInputType.name,
                      controller: widget.nameController,
                      focusNode: _nameNode,
                      nextFocus: _phoneNode,
                      capitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TextFieldShadow(
                    child: MyTextField(
                      hintText: parcelController.isSender ? 'sender_phone_number'.tr : 'receiver_phone_number'.tr,
                      inputType: TextInputType.phone,
                      focusNode: _phoneNode,
                      nextFocus: _streetNode,
                      controller: widget.phoneController,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ]),

                Column(children: [

                  Center(child: Text(parcelController.isSender ? 'pickup_information'.tr : 'destination_information'.tr, style: robotoMedium)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TextFieldShadow(
                    child: MyTextField(
                      hintText: "${'street_number'.tr} (${'optional'.tr})",
                      inputType: TextInputType.streetAddress,
                      focusNode: _streetNode,
                      nextFocus: _houseNode,
                      controller: widget.streetController,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(children: [
                    Expanded(
                      child: TextFieldShadow(
                        child: MyTextField(
                          hintText: "${'house'.tr} (${'optional'.tr})",
                          inputType: TextInputType.text,
                          focusNode: _houseNode,
                          nextFocus: _floorNode,
                          controller: widget.houseController,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: TextFieldShadow(
                        child: MyTextField(
                          hintText: "${'floor'.tr} (${'optional'.tr})",
                          inputType: TextInputType.text,
                          focusNode: _floorNode,
                          inputAction: TextInputAction.done,
                          controller: widget.floorController,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                ]),

                ResponsiveHelper.isDesktop(context) ? widget.bottomButton : const SizedBox(),

              ]),
            )),
          )),
        );
        }
      ),
    );


   */




    });
  }
}
