class AdmissionModel {
  final bool status;
  final String message;
  final List<Response> response;

  AdmissionModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory AdmissionModel.fromJson(Map<String, dynamic> json) {
    return AdmissionModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      response: (json['response'] as List<dynamic>?)
          ?.map((e) => Response.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'response': response.map((e) => e.toJson()).toList(),
    };
  }
}

class Response {
  final String registrationMainId;
  final String userCode;
  final String firstName;
  final String? middleName; // Nullable
  final String lastName;
  final String phoneNumber;
  final String phoneCountryCode;
  final String email;
  final String createdTime;

  Response({
    required this.registrationMainId,
    required this.userCode,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.phoneNumber,
    required this.phoneCountryCode,
    required this.email,
    required this.createdTime,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      registrationMainId: json['registration_main_id'] as String? ?? '',
      userCode: json['user_code'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      phoneCountryCode: json['phone_country_code'] as String? ?? '+91',
      email: json['email'] as String? ?? '',
      createdTime: json['created_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_main_id': registrationMainId,
      'user_code': userCode,
      'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'phone_country_code': phoneCountryCode,
      'email': email,
      'created_time': createdTime,
    };
  }
}