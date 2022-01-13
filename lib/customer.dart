import 'package:grocerysimulator/customertype.dart';

class Customer {

  CustomerType type;
  int itemCount;
  bool isWorking;
  int timeArrived;

  Customer(this.type, this.timeArrived, this.isWorking, this.itemCount);

  int serveItem() {
    return --itemCount;
  }

  CustomerType getType() {
    return type;
  }

  void setType(CustomerType type) {
    this.type = type;
  }

  bool getIsWorking() {
    return isWorking;
  }

  void setIsWorking(bool isWorking) {
    this.isWorking = isWorking;
  }

  int getTimeArrived() {
    return timeArrived;
  }

  int compareType(CustomerType t) {
    return type.index.compareTo(t.index);
  }

  int compareTo(Customer c) {
    int val = 0;

    val = itemCount.compareTo(c.itemCount);
    
    if (val == 0) {
      val = compareType(c.type);
    }
    
    return val;
  }
}
