import '../api/api_manager.dart';

class AuthRepository {
  AuthRepository._();
  static APIManager apiManager = APIManager();


  // static Future<RegisterApiResponseModel> registerApiCall({required Map<String, dynamic> params, bool showLoading = false}) async {
  //   try {
  //     var response = await apiManager.postAPICall(
  //       url: 'signup',
  //       params: params,
  //       showLoading: showLoading,
  //     );
  //     RegisterApiResponseModel registerApiResponseModel = RegisterApiResponseModel.fromJson(response);
  //     return registerApiResponseModel;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }
}