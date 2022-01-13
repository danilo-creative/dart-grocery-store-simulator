import 'dart:collection';

import 'package:grocerysimulator/customer.dart';

class Register {

  Queue<Customer> customerQueue = Queue();
  int index;

  Register(this.index);
}
