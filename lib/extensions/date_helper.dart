extension DateTimeHelper on DateTime {
  
  DateTime getNextMonth() {
    DateTime date = this;
    while (date.month == this.month) {
      date = date.add(Duration(days: 20));
    }
    return date;
  }

  DateTime getPreviousMonth() {
    DateTime date = this;
    while (date.month == this.month) {
      date = date.subtract(Duration(days: 20));
    }
    return date;
  }
}
