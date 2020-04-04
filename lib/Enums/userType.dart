enum UserType { business, donator }

String userTypeDecode(UserType type) {
  switch (type) {
    case UserType.business:
      return "business";
      break;
    case UserType.donator:
      return "donator";
      break;
    default:
      return "donator";
      break;
  }
}
