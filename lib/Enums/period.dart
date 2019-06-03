enum Period { demo, daily, weely, monthly }

getStringValue(Period period) {
  switch (period) {
    case Period.daily:
      return "daily";
    case Period.monthly:
      return "monthly";
    case Period.weely:
      return "weekly";
    default:
      return "";
  }
}
