import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../controller/app_controller.dart';
import '../utils/config.dart';
import '../widgets/common_loader_widget.dart';
import '../widgets/snackbar.dart';
import 'api_exception.dart';


class APIManager {
  static late AppController _appController;
  static late APIManager _apiManager;
  final LoaderService _loaderService = LoaderService();
  factory APIManager.init(AppController appController) {
    _appController = appController;
    _apiManager = APIManager._internal();
    return _apiManager;
  }

  factory APIManager() {
    return _apiManager;
  }

  static CancelToken cancelToken = CancelToken();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      baseUrl: Config.domainUrl,
    ),
  );

  APIManager._internal() {
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Content-Type'] = 'application/json';
          if (getAuthToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $getAuthToken';
          }

          return handler.next(options);
        },
      ),
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logResponseHeaders: false,
        logger: log,
      ),
    ]);
  }

  // Function to check & return if the token is valid
  String get getAuthToken {
    // return empty string when token is null to avoid 'Bearer null' headers
    return _appController.userToken ?? '';
  }

  // GET
  Future<dynamic> getAPICall({
    required String url,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 20,
  }) async {
    debugPrint("Internet Status ${_appController.connection.hasInternet}");

    // Check internet is on or not

    // if (showLoading) Loader.instance.showLoader();
    try {
      debugPrint('------------------ $url');
      queryParameters?.removeWhere((key, value) => value == null || value == 0);

      final response = await _dio
          .get(url, queryParameters: queryParameters, cancelToken: cancelToken)
          .timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          throw TimeoutException(message: 'Timeout');
        },
      );
      var responseJson = _response(response);
      return responseJson;
    } on TimeoutException {
      handleTimeoutException();
      return null;
    } on DioException catch (error) {
      handleDioError(error);
      return null;
    } finally {
      // Loader.instance.removeLoader();
    }
  }

  Future<dynamic> postFormAPICall({
    required String url,
    required Map<String, dynamic> params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 60,
  }) async {
    // Check internet is on or not
    if (_appController.connection.hasInternet) {
      if (showLoading) _loaderService.showLoader();
      try {
        final response = await _dio
            .post(
          url,
          data: FormData.fromMap(params),
          queryParameters: queryParameters,

          cancelToken: cancelToken,
        )
            .timeout(
          Duration(seconds: timeOut),
          onTimeout: () {
            throw TimeoutException(message: 'Timeout');
          },
        );
        var responseJson = _response(response);
        return responseJson;
      } on TimeoutException {
        handleTimeoutException();
        return null;
      } on DioException catch (error) {
        handleDioError(error);
        return null;
      } finally {
        debugPrint("finally in postFormAPICall");
        if (showLoading) _loaderService.hideLoader();

      }
    } else {
      handleNoInternet();
      return null;
    }
  }

  // POST
  Future<dynamic> postAPICall({
    required String url,
    required var params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 20,
  }) async {
    if (showLoading) _loaderService.showLoader();

    try {
      final response = await _dio
          .post(
        url,
        data: params,
        queryParameters: queryParameters,

        cancelToken: cancelToken,
      )
          .timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          throw TimeoutException(message: 'Timeout');
        },
      );

      debugPrint("URL  --> > >  + $url");

      var responseJson = _response(response);
      return responseJson;
    } on TimeoutException {
      handleTimeoutException();
      return null;
    } on DioException catch (error) {
      handleDioError(error);
      return null;
    } finally {
      if (showLoading) _loaderService.hideLoader();
    }
  }



  // Delete
  Future<dynamic> deleteAPICall({
    required String url,
    var params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 20,
  }) async {
    // Check internet is on or not
    if (_appController.connection.hasInternet) {
      // if (showLoading) Loader.instance.showLoader();

      try {
        final response = await _dio
            .delete(
          url,
          queryParameters: queryParameters,
          data: params,

          cancelToken: cancelToken,
        )
            .timeout(
          Duration(seconds: timeOut),
          onTimeout: () {
            throw TimeoutException(message: 'Timeout');
          },
        );
        var responseJson = _response(response);
        return responseJson;
      } on TimeoutException {
        handleTimeoutException();
        return null;
      } on DioException catch (error) {
        handleDioError(error);
        return null;
      } finally {}
    } else {
      handleNoInternet();
      return null;
    }
  }

  // PUT
  Future<dynamic> putAPICall({
    required String url,
    required var params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 20,
  }) async {
    // Check internet is on or not
    if (_appController.connection.hasInternet) {
      // showLoaderIfNeeded(showLoading);
      try {
        final response = await _dio
            .put(
          url,
          data: params,
          queryParameters: queryParameters,
          options: Options(headers: {'Content-Type': 'application/json'}),
          cancelToken: cancelToken,
        )
            .timeout(
          Duration(seconds: timeOut),
          onTimeout: () {
            throw TimeoutException(message: 'Timeout');
          },
        );
        var responseJson = _response(response);
        return responseJson;
      } on TimeoutException {
        handleTimeoutException();
        return null;
      } on DioException catch (error) {
        handleDioError(error);
        return null;
      } finally {
        debugPrint('finally');
        // Loader.instance.removeLoader();
      }
    } else {
      handleNoInternet();
      return null;
    }
  }

  // PATCH
  Future<dynamic> patchAPICall({
    required String url,
    required var params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 20,
  }) async {
    // Check internet is on or not
    if (_appController.connection.hasInternet) {
      // showLoaderIfNeeded(showLoading);
      try {
        final response = await _dio
            .patch(
          url,
          data: params,
          queryParameters: queryParameters,
          // options: Options(
          //   headers: {'Content-Type': 'application/json'},
          // ),
          cancelToken: cancelToken,
        )
            .timeout(
          Duration(seconds: timeOut),
          onTimeout: () {
            throw TimeoutException(message: 'Timeout');
          },
        );
        var responseJson = _response(response);
        return responseJson;
      } on TimeoutException {
        handleTimeoutException();
        return null;
      } on DioException catch (error) {
        handleDioError(error);
        return null;
      } finally {
        debugPrint('finally');
        // Loader.instance.removeLoader();
      }
    } else {
      handleNoInternet();
      return null;
    }
  }


// MULTIPART Post API call
  Future<dynamic> multipartPostAPICall({
    required String url,
    String? fileKey,
    File? file,
    required Map<String, dynamic> params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 60,
  }) async {
    if (showLoading) _loaderService.showLoader();

    try {
      // Clean params: remove null or empty strings
      final Map<String, dynamic> cleanedParams = Map.from(params)
        ..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

      // Create form map
      final Map<String, dynamic> formMap = Map.from(cleanedParams);

      // Add image if present
      if (fileKey != null && file != null) {
        // Extract file name WITHOUT using 'path' package
        final String fileName = file.path.split('/').last;

        formMap[fileKey] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio
          .post(
        url,
        data: formData,
        queryParameters: queryParameters,
        options: Options(
          // DO NOT manually set Content-Type; Dio handles multipart boundaries
          headers: {
            'Accept': 'application/json',
          },
        ),
        cancelToken: cancelToken,
      )
          .timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          throw TimeoutException(message: 'Timeout');
        },
      );

      var responseJson = _response(response);
      return responseJson;
    } on TimeoutException {
      handleTimeoutException();
      return null;
    } on DioException catch (error) {
      handleDioError(error);
      return null;
    } catch (e) {
      debugPrint("Unexpected multipart error: $e");
      return null;
    } finally {
      if (showLoading) _loaderService.hideLoader();
    }
  }



  //MULTIPART PUT API call
  Future<dynamic> multipartPutAPICall({
    required String url,
    String? fileKey,
    File? file,
    required Map<String, dynamic> params,
    Map<String, dynamic>? queryParameters,
    bool showLoading = true,
    int timeOut = 60,
    // Optional: provide a callback to receive upload progress (sent, total)
    void Function(int sent, int total)? onSendProgress,
  }) async {
    if (showLoading) _loaderService.showLoader();

    try {
      final formData = FormData.fromMap({
        ...params,
        if (fileKey != null && file != null)
          fileKey: await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      });

      final response = await _dio
          .put(
        url,
        data: formData,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      )
          .timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          throw TimeoutException(message: 'Timeout');
        },
      );

      var responseJson = _response(response);
      return responseJson;
    } on TimeoutException {
      handleTimeoutException();
      return null;
    } on DioException catch (error) {
      handleDioError(error);
      return null;
    } finally {
      if (showLoading) _loaderService.hideLoader();
    }
  }


  void cancelRequests() {
    cancelToken.cancel();
    cancelToken = CancelToken();
  }

  void handleNoInternet() {
    _appController.initializeConnectionServices();
  }

  void handleSessionExpired() {
    // JwtConfig.removeLocalUserToken();
    // Get.offAllNamed(Routes.LOGIN_SCREEN);
  }

  void handleDioError(DioException error) {
    _loaderService.hideLoader();
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        handleTimeoutException();
        break;
      case DioExceptionType.sendTimeout:
        handleTimeoutException();
        break;
      case DioExceptionType.receiveTimeout:
        handleTimeoutException();
        break;
      case DioExceptionType.badResponse:
        if (error.response != null) {
          _loaderService.hideLoader();
          switch (error.response?.statusCode) {
            case 400:
              handleBadRequest(error.response!.data);
              break;
            case 401:
              handleUnauthorized(error.response!.data);
              break;
            case 403:
              handleForbidden(error.response!.data);
              break;
            case 404:
              handleNotFound(error.response!.statusMessage ?? '');
              break;
            default:
              handleGenericBadResponse(
                error.response!.statusCode,
                error.response!.data,
              );
          }
        } else {
          throw FetchDataException(
            'Received invalid status code: ${error.response?.statusCode}',
          );
        }
        break;
      case DioExceptionType.cancel:
      // errorSnackBar(message: 'Request to API server was cancelled');
        throw FetchDataException('Request to API server was cancelled');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          // errorSnackBar(message: 'No Internet connection');
          throw FetchDataException('No Internet connection');
        } else {
          // errorSnackBar(message: 'Unexpected error occurred');
          throw FetchDataException('Unexpected error occurred');
        }
      default:
        handleGenericError(error, error.stackTrace);
        break;
    }
  }

  void handleTimeoutException() {
    throw TimeoutException(message: 'Timeout');
  }

  void handleBadRequest(dynamic data) {
    final message =
    data is Map<String, dynamic> && data.containsKey('message')
        ? data['message']
        : data;
    // errorSnackBar(message: '$message');
    CustomSnackBar.error(message: message);
    throw BadRequestException(message, 400);
  }

  void handleUnauthorized(dynamic data) {
    CustomSnackBar.error(
      message: "Please Contact Support ",
      title: data['message'] ?? "Something went wrong",
    );
    // JwtConfig.removeLocalUserToken();
    throw UnauthorizedException("Logout user", 401);
  }

  void handleForbidden(dynamic data) {
    final message =
    data is Map<String, dynamic> && data.containsKey('message')
        ? data['message']
        : data;
    throw UnauthorizedException(message, 403);
  }

  void handleNotFound(String message) {
    _loaderService.hideLoader();
    CustomSnackBar.error(message: "Try again later");
    throw FetchDataException(message, 404);
  }

  void handleGenericBadResponse(int? statusCode, dynamic data) {
    _loaderService.hideLoader();
    CustomSnackBar.error(
      title: 'Failed to perform action',
      message: data['message'],
    );

    log('\x1B[91m[Error Response ($statusCode)] => $data\x1B[0m');
    throw FetchDataException('Received invalid status code: $statusCode');
  }

  void handleGenericError(error, StackTrace stackTrace) {
    if (error.toString().contains('Connection closed while receiving data')) {
    } else if (error.toString().contains(
      'Connection closed before full header was received',
    )) {
      log('\x1B[91m[Handle Generic Error] => Request Canceled\x1B[0m');
    }
    throw FetchDataException('Server Error');
  }

  dynamic _response(Response response) async {
    switch (response.statusCode) {
    // Successfully get api response
      case 200:
      case 201:
      case 202:
        if (response.data is String) {
          debugPrint("---------------------");
          return jsonDecode(response.data);
        }
        return response.data;
    // No content
      case 204:
        log('\x1B[91m[No Content (204)] => ${response.data}\x1B[0m');
        return;
    // Bad request need to check url
      case 400:
        handleBadRequest(response.data);
        break;
    // Unauthorized
      case 401:
        handleUnauthorized(response.data);
        break;
    // Authorisation token invalid
      case 403:
        handleForbidden(response.data);
        break;
    // Not Found
      case 404:
        handleNotFound(response.data);
        log('\x1B[91m[Not Found (404)] => ${response.data}\x1B[0m');
        break;

      case 409:
        handleBadRequest(response.data);
        log('\x1B[91m[Conflict (409)] => ${response.data}\x1B[0m');
        break;
      case 500:
        Get.snackbar(
          "Please Fix Backend ",
          "Error Occurred due to poor backend ",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );

      default:
      // errorSnackBar(message: 'An error occurred while communicating to server with status code: ${response.statusCode}');
        log(
          '\x1B[91m[Internal Server Error (${response.statusCode})] => ${response.data}\x1B[0m',
        );
        throw FetchDataException(
          'Error occurred with code : ${response.statusCode}',
        );
    }
  }
}