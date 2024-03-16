import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talabiapp/controller/auth_controller.dart';
import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/controller/parcel_controller.dart';
import 'package:talabiapp/controller/user_controller.dart';
import 'package:talabiapp/data/model/response/address_model.dart';
import 'package:talabiapp/data/model/response/parcel_category_model.dart';
import 'package:talabiapp/helper/responsive_helper.dart';
import 'package:talabiapp/helper/route_helper.dart';
import 'package:talabiapp/util/dimensions.dart';
import 'package:talabiapp/util/images.dart';
import 'package:talabiapp/util/styles.dart';
import 'package:talabiapp/view/base/custom_app_bar.dart';
import 'package:talabiapp/view/base/custom_button.dart';
import 'package:talabiapp/view/base/custom_snackbar.dart';
import 'package:talabiapp/view/base/menu_drawer.dart';
import 'package:talabiapp/view/screens/home/widget/banner_view.dart';
import 'package:talabiapp/view/screens/parcel/widget/parcel_view.dart';

import '../home/widget/my_own_banner.dart';
import '../location/pick_map_screen.dart';

class ParcelLocationScreen extends StatefulWidget {
  final ParcelCategoryModel category;
  const ParcelLocationScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<ParcelLocationScreen> createState() => _ParcelLocationScreenState();
}

class _ParcelLocationScreenState extends State<ParcelLocationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _senderPhoneController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();
  final TextEditingController _senderStreetNumberController =
      TextEditingController();
  final TextEditingController _senderHouseController = TextEditingController();
  final TextEditingController _senderFloorController = TextEditingController();
  final TextEditingController _receiverStreetNumberController =
      TextEditingController();
  final TextEditingController _receiverHouseController =
      TextEditingController();
  final TextEditingController _receiverFloorController =
      TextEditingController();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    Get.find<ParcelController>().setPickupAddress(
        Get.find<LocationController>().getUserAddress(), false);
    Get.find<ParcelController>().setIsPickedUp(true, false);
    Get.find<ParcelController>().setIsSender(true, false);
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<LocationController>().addressList == null) {
      Get.find<LocationController>().getAddressList();
    }
    if (Get.find<AuthController>().isLoggedIn()) {
      if (Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
        _senderNameController.text = Get.find<UserController>().userInfoModel !=
                null
            ? '${Get.find<UserController>().userInfoModel!.fName!} ${Get.find<UserController>().userInfoModel!.lName!}'
            : '';
        _senderPhoneController.text =
            Get.find<UserController>().userInfoModel != null
                ? Get.find<UserController>().userInfoModel!.phone!
                : '';
      } else {
        _senderNameController.text =
            '${Get.find<UserController>().userInfoModel!.fName!} ${Get.find<UserController>().userInfoModel!.lName!}';
        _senderPhoneController.text =
            Get.find<UserController>().userInfoModel!.phone ?? '';
      }
    }

    _tabController?.addListener(() {
      // if(_tabController.index == 1) {
      //   _validateSender(true);
      // }
      Get.find<ParcelController>()
          .setIsPickedUp(_tabController!.index == 0, false);
      Get.find<ParcelController>()
          .setIsSender(_tabController!.index == 0, true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _senderStreetNumberController.dispose();
    _senderHouseController.dispose();
    _senderFloorController.dispose();
    _receiverStreetNumberController.dispose();
    _receiverHouseController.dispose();
    _receiverFloorController.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(title: 'parcel_location'.tr),
    //  floatingActionButton: Container(
    //   width: 150,child: _bottomButton(),
    //   height: 100,),
    //  floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        /*  GetBuilder<ParcelController>(builder: (parcelController) {
        return MaterialButton(
          color: Theme.of(context).secondaryHeaderColor,
          onPressed: () {
            if (_tabController!.index == 0) {
              _validateSender();
            } else {
              if (parcelController.destinationAddress == null) {
                showCustomSnackBar('select_destination_address'.tr);
              } else if (_receiverNameController.text.isEmpty) {
                showCustomSnackBar('enter_receiver_name'.tr);
              } else if (_receiverPhoneController.text.isEmpty) {
                showCustomSnackBar('enter_receiver_phone_number'.tr);
              } else {
                AddressModel destination = AddressModel(
                  address: parcelController.destinationAddress!.address,
                  additionalAddress:
                      parcelController.destinationAddress!.additionalAddress,
                  addressType: parcelController.destinationAddress!.addressType,
                  contactPersonName: _receiverNameController.text.trim(),
                  contactPersonNumber: _receiverPhoneController.text.trim(),
                  latitude: parcelController.destinationAddress!.latitude,
                  longitude: parcelController.destinationAddress!.longitude,
                  method: parcelController.destinationAddress!.method,
                  zoneId: parcelController.destinationAddress!.zoneId,
                  id: parcelController.destinationAddress!.id,
                  streetNumber: _receiverStreetNumberController.text.trim(),
                  house: _receiverHouseController.text.trim(),
                  floor: _receiverFloorController.text.trim(),
                );

                parcelController.setDestinationAddress(destination);

                Get.toNamed(RouteHelper.getParcelRequestRoute(
                  widget.category,
                  Get.find<ParcelController>().pickupAddress!,
                  Get.find<ParcelController>().destinationAddress!,
                ));
              }
            }
          },
          child: Text(
            "إرسال الطلب",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }),
    
    */
    
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<ParcelController>(builder: (parcelController) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  MyOwnBanner(isFeatured: true),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[500],
                                ),
                                Text("4.8",
                                    style: TextStyle(color: Colors.black45))
                              ],
                            ),
                            Row(
                              children: [
                                Text("مشاركات",
                                    style: TextStyle(color: Colors.black45)),
                                Text("1.47M",
                                    style: TextStyle(color: Colors.black45))
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey.shade400,
                            ),
                            Text(
                              "مفتوح",
                              style: TextStyle(color: Colors.black45),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                color: Colors.grey[200],
                // margin: EdgeInsets.only(right: 15,top: 30),
                height: 300,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "تفاصيل طلبك",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      // margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 5,
                        // cursorRadius: Radius.circular(15),

                        decoration: InputDecoration(
                            helperMaxLines: 20,
                            hintText:
                                "اكتب تفاصيل طلبك ونوصله لك من اي مكان لاي مكان",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            suffixIcon: Icon(Icons.camera),
                            suffixIconConstraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height,
                                maxWidth: 30)),
                      ),
                    ),
                  ],
                )),
            //   ResponsiveHelper.isDesktop(context) ? const SizedBox() : _bottomButton(),
         
         
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "عناوين التوصيل",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),

              height: 320,
              width: MediaQuery.of(context).size.width,
              child:

              ParcelView(
                isSender: true,
                nameController: _senderNameController,
                phoneController: _senderPhoneController,
                bottomButton: _bottomButton(),
                streetController: _receiverStreetNumberController,
                floorController: _receiverFloorController,
                houseController: _receiverHouseController,
              ),
            ),


            SizedBox(
              height: 20,
            ),
            Container(
        margin: EdgeInsets.symmetric(horizontal: 40),

              height: 320,
              width: MediaQuery.of(context).size.width,
              child:

              ParcelView(
                isSender: false,
                nameController: _receiverNameController,
                phoneController: _receiverPhoneController,
                bottomButton: _bottomButton(),
                streetController: _receiverStreetNumberController,
                floorController: _receiverFloorController,
                houseController: _receiverHouseController,
              ),
            ),


            _bottomButton()
          ]),
        );
      }),
    );
  }

  Widget _bottomButton() {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return CustomButton(
        margin: ResponsiveHelper.isDesktop(context)
            ? null
            : const EdgeInsets.all(Dimensions.paddingSizeSmall),
        buttonText:
            parcelController.isSender ? 'continue'.tr : 'save_and_continue'.tr,
        onPressed: () {
          if (_tabController!.index == 0) {
            _validateSender();
          } else {
            if (parcelController.destinationAddress == null) {
              showCustomSnackBar('select_destination_address'.tr);
            } else if (_receiverNameController.text.isEmpty) {
              showCustomSnackBar('enter_receiver_name'.tr);
            } else if (_receiverPhoneController.text.isEmpty) {
              showCustomSnackBar('enter_receiver_phone_number'.tr);
            } else {
              AddressModel destination = AddressModel(
                address: parcelController.destinationAddress!.address,
                additionalAddress:
                    parcelController.destinationAddress!.additionalAddress,
                addressType: parcelController.destinationAddress!.addressType,
                contactPersonName: _receiverNameController.text.trim(),
                contactPersonNumber: _receiverPhoneController.text.trim(),
                latitude: parcelController.destinationAddress!.latitude,
                longitude: parcelController.destinationAddress!.longitude,
                method: parcelController.destinationAddress!.method,
                zoneId: parcelController.destinationAddress!.zoneId,
                id: parcelController.destinationAddress!.id,
                streetNumber: _receiverStreetNumberController.text.trim(),
                house: _receiverHouseController.text.trim(),
                floor: _receiverFloorController.text.trim(),
              );
              AddressModel sender = AddressModel(
                address: parcelController.pickupAddress!.address,
                additionalAddress:
                parcelController.pickupAddress!.additionalAddress,
                addressType: parcelController.pickupAddress!.addressType,
                contactPersonName:_senderNameController .text.trim(),
                contactPersonNumber: _senderPhoneController.text.trim(),
                latitude: parcelController.pickupAddress!.latitude,
                longitude: parcelController.pickupAddress!.longitude,
                method: parcelController.pickupAddress!.method,
                zoneId: parcelController.pickupAddress!.zoneId,
                id: parcelController.pickupAddress!.id,
                streetNumber: _senderStreetNumberController.text.trim(),
                house: _senderHouseController.text.trim(),
                floor: _senderFloorController.text.trim(),
              );

              parcelController.setDestinationAddress(destination);
              parcelController.setPickupAddress(sender, true);

              Get.toNamed(RouteHelper.getParcelRequestRoute(
                widget.category,
                Get.find<ParcelController>().pickupAddress!,
                Get.find<ParcelController>().destinationAddress!,
              ));
            }
          }
        },
      );
    });
  }

  void _validateSender() {
    if (Get.find<ParcelController>().pickupAddress == null) {
      showCustomSnackBar('select_pickup_address'.tr);
      _tabController!.animateTo(0);
    } else if (_senderNameController.text.isEmpty) {
      showCustomSnackBar('enter_sender_name'.tr);
      _tabController!.animateTo(0);
    } else if (_senderPhoneController.text.isEmpty) {
      showCustomSnackBar('enter_sender_phone_number'.tr);
      _tabController!.animateTo(0);
    } else {
      AddressModel pickup = AddressModel(
        address: Get.find<ParcelController>().pickupAddress!.address,
        additionalAddress:
            Get.find<ParcelController>().pickupAddress!.additionalAddress,
        addressType: Get.find<ParcelController>().pickupAddress!.addressType,
        contactPersonName: _senderNameController.text.trim(),
        contactPersonNumber: _senderPhoneController.text.trim(),
        latitude: Get.find<ParcelController>().pickupAddress!.latitude,
        longitude: Get.find<ParcelController>().pickupAddress!.longitude,
        method: Get.find<ParcelController>().pickupAddress!.method,
        zoneId: Get.find<ParcelController>().pickupAddress!.zoneId,
        id: Get.find<ParcelController>().pickupAddress!.id,
        streetNumber: _senderStreetNumberController.text.trim(),
        house: _senderHouseController.text.trim(),
        floor: _senderFloorController.text.trim(),
      );
      Get.find<ParcelController>().setPickupAddress(pickup, true);
      _tabController!.animateTo(1);
    }
  }
}
