class User{
  String address;
//  String phoneNumber;

  User(this.address);
//  User(this.address, this.phoneNumber);

  Map<String, dynamic> toJson() => {
    'address': address,
//    'phoneNumber': phoneNumber
  };
}
