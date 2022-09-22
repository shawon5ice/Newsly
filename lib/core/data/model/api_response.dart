import '../../utils/status.dart';

class Response<T> {
  Status? status;
  ValidationStatus? validationStatus;
  T? data;
  String? message;
  int? statusCode;

  Response.loading() : status =  Status.loading;
  Response.error(this.message, this.statusCode) : status =  Status.failed;
  Response.validation(this.message, {this.validationStatus = ValidationStatus.none}) : status = Status.validation;
  Response.success(this.data) : status =  Status.success;
}

enum Status {
  success,
  failed,
  loading,
  validation
}