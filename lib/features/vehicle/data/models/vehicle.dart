import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final int id;
  final String make;
  final String model;
  final String externalId;
  final int price;
  final bool? positiveCustomerFeedback;
  final String? feedback;
  final DateTime valuatedAt;
  final DateTime requestedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? inspectorRequestedAt;
  final String origin;
  final String estimationRequestId;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.externalId,
    required this.price,
    this.positiveCustomerFeedback,
    this.feedback,
    required this.valuatedAt,
    required this.requestedAt,
    required this.createdAt,
    required this.updatedAt,
    this.inspectorRequestedAt,
    required this.origin,
    required this.estimationRequestId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      make: json['make'],
      model: json['model'],
      externalId: json['externalId'],
      price: json['price'] as int,
      positiveCustomerFeedback: json['positiveCustomerFeedback'],
      feedback: json['feedback'],
      valuatedAt: DateTime.parse(json['valuatedAt']),
      requestedAt: DateTime.parse(json['requestedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      inspectorRequestedAt: json['inspectorRequestedAt'],
      origin: json['origin'],
      estimationRequestId: json['estimationRequestId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'externalId': externalId,
      'price': price,
      'positiveCustomerFeedback': positiveCustomerFeedback,
      'feedback': feedback,
      'valuatedAt': valuatedAt.toIso8601String(),
      'requestedAt': requestedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'inspectorRequestedAt': inspectorRequestedAt,
      'origin': origin,
      'estimationRequestId': estimationRequestId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        make,
        model,
        externalId,
        price,
        positiveCustomerFeedback,
        feedback,
        valuatedAt,
        requestedAt,
        createdAt,
        updatedAt,
        inspectorRequestedAt,
        origin,
        estimationRequestId,
      ];
}
