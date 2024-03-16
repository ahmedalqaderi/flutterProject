import 'package:talabiapp/data/api/api_client.dart';
import 'package:talabiapp/data/model/body/review_body.dart';
import 'package:talabiapp/util/app_constants.dart';
import 'package:get/get.dart';

class ItemRepo extends GetxService {
  final ApiClient apiClient;
  ItemRepo({required this.apiClient});

  Future<Response> getPopularItemList(String type) async {
    return await apiClient.getData('${AppConstants.popularItemUri}?type=$type');
  }

  Future<Response> getReviewedItemList(String type) async {
    return await apiClient.getData('${AppConstants.reviewedItemUri}?type=$type');
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.reviewUri, reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.deliveryManReviewUri, reviewBody.toJson());
  }

  Future<Response> getItemDetails(int? itemID) async {
    return apiClient.getData('${AppConstants.itemDetailsUri}$itemID');
  }

  
}
