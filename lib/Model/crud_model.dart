class CrudModel {
  CrudModel({
    required this.Price,
    required this.Name,
    required this.SubName,
  });
  late final int Price;
  late final String Name;
  late final String SubName;
  
  CrudModel.fromJson(Map<String, dynamic> json){
    Price = json['Price'];
    Name = json['Name'];
    SubName = json['SubName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Price'] = Price;
    _data['Name'] = Name;
    _data['SubName'] = SubName;
    return _data;
  }
}