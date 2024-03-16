import 'package:talabiapp/controller/location_controller.dart';
import 'package:talabiapp/data/api/api_checker.dart';
import 'package:talabiapp/data/model/response/banner_model.dart';
import 'package:talabiapp/data/model/response/zone_response_model.dart';
import 'package:talabiapp/data/repository/banner_repo.dart';
import 'package:get/get.dart';
import 'package:talabiapp/helper/responsive_helper.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});

  List<String?>? _bannerImageList;
  List<String?>? _taxiBannerImageList;
  List<String?>? _featuredBannerList;
   List<String?>? _featuredBannerListt;
  List<dynamic>? _bannerDataList;
  List<dynamic>? _taxiBannerDataList;
  List<dynamic>? _featuredBannerDataList;
   List<dynamic>? _featuredBannerDataListt;


    List<dynamic>? _featuredBannerDatarigthtList;
     List<String?>? _featuredBannerrightList;

  List<dynamic>? _featuredBannerDataliftList;
     List<String?>? _featuredBannerliftList;




  int _currentIndex = 0;

  List<String?>? _featuredBannerListOne;
  List<dynamic>? _bannerImageListOne;
    List<String?>? _featuredBannerListTwo;
  List<dynamic>? _bannerImageListTwo;

  
  List<dynamic?>? get bannerImageListOne => _bannerImageListOne;
  List<String?>? get featuredBannerListOne => _featuredBannerListOne;
  List<dynamic?>? get bannerImageListTwo => _bannerImageListTwo;
  List<String?>? get featuredBannerListTwo => _featuredBannerListTwo;



  List<String?>? get bannerImageList => _bannerImageList;
  List<String?>? get featuredBannerList => _featuredBannerList;
   List<String?>? get featuredBannerListt => _featuredBannerListt;
  List<dynamic>? get bannerDataList => _bannerDataList;
  List<dynamic>? get featuredBannerDataList => _featuredBannerDataList;

 List<dynamic>? get featuredBannerDataListt => _featuredBannerDataListt;

  List<dynamic>? get featuredBannerDatarigthtList => _featuredBannerDatarigthtList;
    List<String?>? get featuredBannerrightList => _featuredBannerrightList ;



      List<dynamic>? get featuredBannerDataliftList => _featuredBannerDataliftList;
    List<String?>? get featuredBannerliftList => _featuredBannerliftList ;

  int get currentIndex => _currentIndex;
  List<String?>? get taxiBannerImageList => _taxiBannerImageList;
  List<dynamic>? get taxiBannerDataList => _taxiBannerDataList;

  Future<void> getFeaturedBanner() async {
    Response response = await bannerRepo.getFeaturedBannerList();
    if (response.statusCode == 200) {
      _featuredBannerList = [];
      _featuredBannerDataList = [];

         _featuredBannerListt = [];
      _featuredBannerDataListt = [];


        _featuredBannerDatarigthtList = [];
      _featuredBannerrightList = [];



        _featuredBannerDataliftList = [];
      _featuredBannerliftList = [];


      BannerModel bannerModel = BannerModel.fromJson(response.body);
      List<int?> moduleIdList = [];
      for (ZoneData zone in Get.find<LocationController>().getUserAddress()!.zoneData!) {
        for (Modules module in zone.modules ?? []) {
          moduleIdList.add(module.id);
        }
      }
      for (var campaign in bannerModel.campaigns!) {


        _featuredBannerList!.add(campaign.image);
        _featuredBannerDataList!.add(campaign);



                _featuredBannerListt!.add(campaign.image);
        _featuredBannerDataListt!.add(campaign);




                    _featuredBannerrightList!.add(campaign.image);
        _featuredBannerDatarigthtList!.add(campaign);



                    _featuredBannerliftList!.add(campaign.image);
        _featuredBannerDataliftList!.add(campaign);


      }
      for (var banner in bannerModel.banners!) {
if(banner.type_banner==1){
        _featuredBannerList!.add(banner.image);
        if(banner.item != null && moduleIdList.contains(banner.item!.moduleId)) {
          _featuredBannerDataList!.add(banner.item);
        }else if(banner.store != null && moduleIdList.contains(banner.store!.moduleId)) {
          _featuredBannerDataList!.add(banner.store);
        }else if(banner.type == 'default') {
          _featuredBannerDataList!.add(banner.link);
        }else{
          _featuredBannerDataList!.add(null);
        }
}

else if(banner.type_banner==2)
{

          _featuredBannerListt!.add(banner.image);
        if(banner.item != null && moduleIdList.contains(banner.item!.moduleId)) {
          _featuredBannerDataListt!.add(banner.item);
        }else if(banner.store != null && moduleIdList.contains(banner.store!.moduleId)) {
          _featuredBannerDataListt!.add(banner.store);
        }else if(banner.type == 'default') {
          _featuredBannerDataListt!.add(banner.link);
        }else{
          _featuredBannerDataListt!.add(null);
        }


}



else if(banner.type_banner==3)
{

        _featuredBannerrightList!.add(banner.image);
        if(banner.item != null && moduleIdList.contains(banner.item!.moduleId)) {
          _featuredBannerDatarigthtList!.add(banner.item);
        }else if(banner.store != null && moduleIdList.contains(banner.store!.moduleId)) {
          _featuredBannerDatarigthtList!.add(banner.store);
        }else if(banner.type == 'default') {
          _featuredBannerDatarigthtList!.add(banner.link);
        }else{
          _featuredBannerDatarigthtList!.add(null);
        }



}




else if(banner.type_banner==4)
{

        _featuredBannerliftList!.add(banner.image);
        if(banner.item != null && moduleIdList.contains(banner.item!.moduleId)) {
          _featuredBannerDataliftList!.add(banner.item);
        }else if(banner.store != null && moduleIdList.contains(banner.store!.moduleId)) {
          _featuredBannerDataliftList!.add(banner.store);
        }else if(banner.type == 'default') {
          _featuredBannerDataliftList!.add(banner.link);
        }else{
          _featuredBannerDataliftList!.add(null);
        }



}




      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getBannerList(bool reload) async {
    if(_bannerImageList == null || reload) {
      _bannerImageList = null;
      Response response = await bannerRepo.getBannerList();
      if (response.statusCode == 200) {
        _bannerImageList = [];
        _bannerDataList = [];
        BannerModel bannerModel = BannerModel.fromJson(response.body);
        for (var campaign in bannerModel.campaigns!) {
          _bannerImageList!.add(campaign.image);
          _bannerDataList!.add(campaign);
        }
        for (var banner in bannerModel.banners!) {
          _bannerImageList!.add(banner.image);
          if(banner.item != null) {
            _bannerDataList!.add(banner.item);
          }else if(banner.store != null){
            _bannerDataList!.add(banner.store);
          }else if(banner.type == 'default'){
            _bannerDataList!.add(banner.link);
          }else{
            _bannerDataList!.add(null);
          }
        }
        if(ResponsiveHelper.isDesktop(Get.context) && _bannerImageList!.length % 2 != 0){
          _bannerImageList!.add(_bannerImageList![0]);
          _bannerDataList!.add(_bannerDataList![0]);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getTaxiBannerList(bool reload) async {
    if(_taxiBannerImageList == null || reload) {
      _taxiBannerImageList = null;
      Response response = await bannerRepo.getTaxiBannerList();
      if (response.statusCode == 200) {
        _taxiBannerImageList = [];
        _taxiBannerDataList = [];
        BannerModel bannerModel = BannerModel.fromJson(response.body);
        for (var campaign in bannerModel.campaigns!) {
          _taxiBannerImageList!.add(campaign.image);
          _taxiBannerDataList!.add(campaign);
        }
        for (var banner in bannerModel.banners!) {
          _taxiBannerImageList!.add(banner.image);
          if(banner.item != null) {
            _taxiBannerDataList!.add(banner.item);
          }else if(banner.store != null){
            _taxiBannerDataList!.add(banner.store);
          }else if(banner.type == 'default'){
            _taxiBannerDataList!.add(banner.link);
          }else{
            _taxiBannerDataList!.add(null);
          }
        }
        if(ResponsiveHelper.isDesktop(Get.context) && _taxiBannerImageList!.length % 2 != 0){
          _taxiBannerImageList!.add(_taxiBannerImageList![0]);
          _taxiBannerDataList!.add(_taxiBannerDataList![0]);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}
