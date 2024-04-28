// To parse this JSON data, do
//
//     final trackOrderModel = trackOrderModelFromJson(jsonString);

import 'dart:convert';

TrackOrderModel trackOrderModelFromJson(String str) =>
    TrackOrderModel.fromJson(json.decode(str));

String trackOrderModelToJson(TrackOrderModel data) =>
    json.encode(data.toJson());

class TrackOrderModel {
  final int status;
  final String message;
  final int total;
  final List<ListTrackingData> data;

  TrackOrderModel({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  factory TrackOrderModel.fromJson(Map<String, dynamic> json) =>
      TrackOrderModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        data: List<ListTrackingData>.from(
            json["data"].map((x) => ListTrackingData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ListTrackingData {
  final TrackingData trackingData;

  ListTrackingData({
    required this.trackingData,
  });

  factory ListTrackingData.fromJson(Map<String, dynamic> json) =>
      ListTrackingData(
        trackingData: TrackingData.fromJson(json["tracking_data"]),
      );

  Map<String, dynamic> toJson() => {
        "tracking_data": trackingData.toJson(),
      };
}

class TrackingData {
  final int trackStatus;
  final int shipmentStatus;
  final List<ShipmentTrack> shipmentTrack;
  final List<ShipmentTrackActivity> shipmentTrackActivities;
  final String trackUrl;
  final DateTime etd;
  final QcResponse qcResponse;

  TrackingData({
    required this.trackStatus,
    required this.shipmentStatus,
    required this.shipmentTrack,
    required this.shipmentTrackActivities,
    required this.trackUrl,
    required this.etd,
    required this.qcResponse,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) => TrackingData(
        trackStatus: json["track_status"],
        shipmentStatus: json["shipment_status"],
        shipmentTrack: List<ShipmentTrack>.from(
            json["shipment_track"].map((x) => ShipmentTrack.fromJson(x))),
        shipmentTrackActivities: List<ShipmentTrackActivity>.from(
            json["shipment_track_activities"]
                .map((x) => ShipmentTrackActivity.fromJson(x))),
        trackUrl: json["track_url"],
        etd: DateTime.parse(json["etd"]),
        qcResponse: QcResponse.fromJson(json["qc_response"]),
      );

  Map<String, dynamic> toJson() => {
        "track_status": trackStatus,
        "shipment_status": shipmentStatus,
        "shipment_track":
            List<dynamic>.from(shipmentTrack.map((x) => x.toJson())),
        "shipment_track_activities":
            List<dynamic>.from(shipmentTrackActivities.map((x) => x.toJson())),
        "track_url": trackUrl,
        "etd": etd.toIso8601String(),
        "qc_response": qcResponse.toJson(),
      };
}

class QcResponse {
  final String qcImage;
  final String qcFailedReason;

  QcResponse({
    required this.qcImage,
    required this.qcFailedReason,
  });

  factory QcResponse.fromJson(Map<String, dynamic> json) => QcResponse(
        qcImage: json["qc_image"],
        qcFailedReason: json["qc_failed_reason"],
      );

  Map<String, dynamic> toJson() => {
        "qc_image": qcImage,
        "qc_failed_reason": qcFailedReason,
      };
}

class ShipmentTrack {
  final int id;
  final String awbCode;
  final int courierCompanyId;
  final int shipmentId;
  final int orderId;
  final DateTime pickupDate;
  final DateTime deliveredDate;
  final String weight;
  final int packages;
  final String currentStatus;
  final String deliveredTo;
  final String destination;
  final String consigneeName;
  final String origin;
  final dynamic courierAgentDetails;
  final String courierName;
  final dynamic edd;
  final String pod;
  final String podStatus;
  final String rtoDeliveredDate;

  ShipmentTrack({
    required this.id,
    required this.awbCode,
    required this.courierCompanyId,
    required this.shipmentId,
    required this.orderId,
    required this.pickupDate,
    required this.deliveredDate,
    required this.weight,
    required this.packages,
    required this.currentStatus,
    required this.deliveredTo,
    required this.destination,
    required this.consigneeName,
    required this.origin,
    required this.courierAgentDetails,
    required this.courierName,
    required this.edd,
    required this.pod,
    required this.podStatus,
    required this.rtoDeliveredDate,
  });

  factory ShipmentTrack.fromJson(Map<String, dynamic> json) => ShipmentTrack(
        id: json["id"],
        awbCode: json["awb_code"],
        courierCompanyId: json["courier_company_id"],
        shipmentId: json["shipment_id"],
        orderId: json["order_id"],
        pickupDate: DateTime.parse(json["pickup_date"]),
        deliveredDate: DateTime.parse(json["delivered_date"]),
        weight: json["weight"],
        packages: json["packages"],
        currentStatus: json["current_status"],
        deliveredTo: json["delivered_to"],
        destination: json["destination"],
        consigneeName: json["consignee_name"],
        origin: json["origin"],
        courierAgentDetails: json["courier_agent_details"],
        courierName: json["courier_name"],
        edd: json["edd"],
        pod: json["pod"],
        podStatus: json["pod_status"],
        rtoDeliveredDate: json["rto_delivered_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "awb_code": awbCode,
        "courier_company_id": courierCompanyId,
        "shipment_id": shipmentId,
        "order_id": orderId,
        "pickup_date": pickupDate.toIso8601String(),
        "delivered_date": deliveredDate.toIso8601String(),
        "weight": weight,
        "packages": packages,
        "current_status": currentStatus,
        "delivered_to": deliveredTo,
        "destination": destination,
        "consignee_name": consigneeName,
        "origin": origin,
        "courier_agent_details": courierAgentDetails,
        "courier_name": courierName,
        "edd": edd,
        "pod": pod,
        "pod_status": podStatus,
        "rto_delivered_date": rtoDeliveredDate,
      };
}

class ShipmentTrackActivity {
    final DateTime date;
    final String status;
    final String activity;
    final String location;
    final String srStatus;
    final String srStatusLabel;

    ShipmentTrackActivity({
        required this.date,
        required this.status,
        required this.activity,
        required this.location,
        required this.srStatus,
        required this.srStatusLabel,
    });

    factory ShipmentTrackActivity.fromJson(Map<String, dynamic> json) => ShipmentTrackActivity(
        date: DateTime.parse(json["date"]),
        status: json["status"],
        activity: json["activity"],
        location: json["location"],
        srStatus: json["sr-status"],
        srStatusLabel: json["sr-status-label"],
    );

    Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "status": status,
        "activity": activity,
        "location": location,
        "sr-status": srStatus,
        "sr-status-label": srStatusLabel,
    };
}
