class MedicineInfoModel {
  final String id;
  final String name;
  final String item_seq;
  final String company_name;
  final String description;
  final String usage;
  final String effect;
  final String side_effect;
  final String caution;
  final String warning;
  final String interaction;
  final String keep_method;
  final String appearance;
  final String color_class1;
  final String color_class2;
  final String pill_image;
  final String class_name;
  final String otc_name;
  final String form_code_name;

  MedicineInfoModel({
    required this.id,
    required this.name,
    required this.item_seq,
    required this.company_name,
    required this.description,
    required this.usage,
    required this.effect,
    required this.side_effect,
    required this.caution,
    required this.warning,
    required this.interaction,
    required this.keep_method,
    required this.appearance,
    required this.color_class1,
    required this.color_class2,
    required this.pill_image,
    required this.class_name,
    required this.otc_name,
    required this.form_code_name,
  });

  factory MedicineInfoModel.fromJson({required Map<String, dynamic> json}) {
    return MedicineInfoModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        item_seq: json['item_seq'] ?? '',
        company_name: json['company_name'] ?? '',
        description: json['description'] ?? '',
        usage: json['usage'] ?? '',
        effect: json['effect'] ?? '',
        side_effect: json['side_effect'] ?? '',
        caution: json['caution'] ?? '',
        warning: json['warning'] ?? '',
        interaction: json['interaction'] ?? '',
        keep_method: json['keep_method'] ?? '',
        appearance: json['appearance'] ?? '',
        color_class1: json['color_class1'] ?? '',
        color_class2: json['color_class2'] ?? '',
        pill_image: json['pill_image'] ?? '',
        class_name: json['class_name'] ?? '',
        otc_name: json['otc_name'] ?? '',
        form_code_name: json['form_code_name'] ?? '');
  }
}
