class InitiateTransaction {
  InitiateTransaction({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final String status;
  late final String message;
  late final String total;
  late final Data data;

  InitiateTransaction.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['status'] = status;
    itemData['message'] = message;
    itemData['total'] = total;
    itemData['data'] = data.toJson();
    return itemData;
  }
}

class Data {
  Data({
    required this.paymentMethod,
    required this.transactionId,
    required this.paymentBody,
    required this.checkSum,});

  late final String paymentMethod;
  late final String transactionId;
  late final String paymentBody;
  late final String checkSum;

  Data.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'].toString();
    transactionId = json['transaction_id'].toString();
    paymentBody = json['payment_body'].toString();
    checkSum = json['payment_checksum'].toString();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['payment_method'] = paymentMethod;
    itemData['transaction_id'] = transactionId;
    itemData['payment_body'] = paymentBody;
    itemData['payment_signature'] = checkSum;
    return itemData;
  }
}
