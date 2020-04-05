class DonationDto {
  final String senderName;
  final int price;
  final int index;
  final DateTime donatedDate;

  DonationDto({this.donatedDate, this.senderName, this.price, this.index});
}
