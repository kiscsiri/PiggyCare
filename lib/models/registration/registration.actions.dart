class SetPrice {
  final int price;

  SetPrice(this.price);
}

class SetPhoneNumber {
  final String phoneNumber;

  SetPhoneNumber(this.phoneNumber);
}

class SetItem {
  final String item;

  SetItem(this.item);
}

class ClearRegisterState {
}

class InitRegistration {
  final String item;
  final String phoneNumber;
  final String price;

  InitRegistration(this.item, this.phoneNumber, this.price);
}