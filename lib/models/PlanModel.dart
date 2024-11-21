class PlanModel {
  final int idPlan;
  final String name;
  final String clientType;
  final double amount;
  final String frequencyPlan;

  PlanModel(
      {required this.idPlan,
      required this.name,
      required this.clientType,
      required this.amount,
      required this.frequencyPlan});

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
        idPlan: json['idPlan'],
        name: json['name'],
        clientType: json['clientType'],
        amount: json['amount'],
        frequencyPlan: json['frequencyPlan']);
  }
}
