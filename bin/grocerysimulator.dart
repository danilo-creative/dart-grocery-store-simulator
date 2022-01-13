import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:grocerysimulator/customer.dart';
import 'package:grocerysimulator/customertype.dart';
import 'package:grocerysimulator/registercollection.dart';

Queue<Customer> customerQueue = Queue();
late RegisterCollection registerCollection;

void main(List<String> arguments) {
  initCustomers('./' + arguments[0]);
}

CustomerType typeFromString(var s) {
  return s == 'A' ? CustomerType.A : CustomerType.B;
}

void initCustomers(var fileName) {
  int currentLine = 0;

  File(fileName).openRead().transform(utf8.decoder).transform(const LineSplitter()).forEach((line) {
    if (currentLine == 0) {
      int registerCount = int.parse(line);

      registerCollection = RegisterCollection(registerCount);
    } else {
      Customer? customer = createCustomer(line);

      customerQueue.add(customer);
    }

    currentLine++;
  }).then((_) {
    int totalTime = calculateTime();

    print('Finished at: t=' + totalTime.toString() + ' minutes');
  }).catchError((err) {
    print('Exception thrown while reading file $err');
  });
}
    
Customer createCustomer(String line) {
  List<String> items = line.split(" ");

  if(items.length != 3){
    print('Error reading line ' + line);
            
    exit(1);
  }

  if (items[0] == 'A' || items[0] == 'B') {
    return Customer(typeFromString(items[0]), int.parse(items[1]), false, int.parse(items[2]));
  } else {
    print('Error reading customer data');

    exit(1);
  }
}

void getConcurrentCustomers(List<Customer> concurrentCustomers, int time) {
  if (concurrentCustomers.isEmpty) {
    return;
  }

  Customer customer = customerQueue.first;

  while (customer.getTimeArrived() == time) {
    concurrentCustomers.add(customerQueue.removeFirst());

    customer = customerQueue.first;
  }
}

void employeeServe(Queue<Customer> customers) {
  if (customers.isEmpty) {
    return;
  }

  Customer c = customers.first;

  if (c.serveItem() == 0) {
    customers.removeFirst();
  }
}

void traineeServe(Queue<Customer> customers) {
  if (customers.isEmpty) {
    return;
  }

  Customer c = customers.first;
    
  if (!c.getIsWorking()) {
    c.setIsWorking(true);
  } else {
    if (c.serveItem() == 0) {
      customers.removeFirst();
    } else {
      c.setIsWorking(false);
    }
  }
}

int calculateTime() {
  int time = 1;

  while ((customerQueue.isNotEmpty || registerCollection.isRegisterinService())) {
    List<Customer> concurrentCustomers = <Customer>[];

    try {
      Customer customer = customerQueue.first;

      while (customer.getTimeArrived() == time) {
        concurrentCustomers.add(customerQueue.removeFirst());

        customer = customerQueue.first;
      }
    } on StateError catch (_) {}

    concurrentCustomers.sort((a, b) => a.compareTo(b));

    registerCollection.serviceCustomer(concurrentCustomers);

    int index = 0;

    while (index < registerCollection.registers.length) {
      var customer = registerCollection.registers[index].customerQueue;

      if (index == registerCollection.registers.length - 1) {
        traineeServe(customer);
      } else {
        employeeServe(customer);
      }

      index++;
    }
      
    time++;
  }

  return time;
}
