enum UserType { adult, child, individual }

String userTypeDecode(UserType type) {
  switch (type) {
    case UserType.adult:
      return "adult";
      break;
    case UserType.child:
      return "child";
      break;
    case UserType.individual:
      return "individual";
      break;
    default:
      return "individual";
      break;
  }
}
