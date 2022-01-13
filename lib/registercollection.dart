import 'dart:collection';

import 'package:grocerysimulator/customer.dart';
import 'package:grocerysimulator/customertype.dart';
import 'package:grocerysimulator/register.dart';

class RegisterCollection {

  List<Register> registers = [];

  RegisterCollection(length) {
    for (var i = 0; i < length; i++) {
      registers.add(Register(i));
    }
  }

  Register findRegisterA() {
    List<Register> sortedList = <Register>[];
        
    for (Register register in registers) {
      sortedList.add(register);
    }

    sortedList.sort((a, b) => a.customerQueue.length.compareTo(b.customerQueue.length));

    return sortedList[0];
  }

  Register? findRegisterB() {
    Map<Customer,Register> customerMap = HashMap<Customer,Register>();

    List<Register> emptyList = <Register>[];
    List<Customer> listWithItems = <Customer>[];

    for (Register register in registers) {
      if (register.customerQueue.isEmpty) {
        emptyList.add(register);
      } else {
        Customer? lastCustomer = getLastElement(register.customerQueue);

        if (lastCustomer != null) {
          customerMap[lastCustomer] = register;
          listWithItems.add(lastCustomer);
        }
      }
    }

    if (emptyList.isNotEmpty) {
      emptyList.sort((a, b) => a.index.compareTo(b.index));

      return emptyList[0];
    } else {
      listWithItems.sort((a, b) => a.compareTo(b));

      return customerMap[listWithItems[0]];
    }
  }

  Customer? getLastElement(var customerList) {
    Customer? lastCustomer;
    Iterator<Customer> iterator= customerList.iterator;

    while (iterator.moveNext()) {
      lastCustomer=iterator.current;
    }
    
    return lastCustomer;
  }
    
  void serviceCustomer(List<Customer> customerList) {
    for (var customer in customerList) {
      if (customer.getType() == CustomerType.A) {
        Register registerA = findRegisterA();
        
        registerA.customerQueue.add(customer);
      } else {
        Register? registerB = findRegisterB();

        if (registerB != null) {
          registerB.customerQueue.add(customer);
        }
      }
    }
  }
    
  bool isRegisterinService() {
    for (var register in registers) {
      if (register.customerQueue.isNotEmpty) {
        return true;
      }
    }

    return false;
  }
}
