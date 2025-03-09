import 'package:flutter/material.dart';

class OrderProgressPage extends StatefulWidget {
  @override
  _OrderProgressPageState createState() => _OrderProgressPageState();
}

class _OrderProgressPageState extends State<OrderProgressPage> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Progress'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: currentStep,
              onStepTapped: (step) {
                setState(() {
                  currentStep = step;
                });
              },
              steps: [
                Step(
                  title: Text('Vendor Order Confirmed'),
                  content: Text('Your order has been confirmed by the vendor.'),
                  isActive: currentStep >= 0,
                  state: currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Vendor Processing'),
                  content: Text('The vendor is preparing your order.'),
                  isActive: currentStep >= 1,
                  state: currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Rider on the Way'),
                  content: Text('Your order is on the way.'),
                  isActive: currentStep >= 2,
                  state: currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStep -= 1;
                      });
                    },
                    child: Text('Previous'),
                  ),
                if (currentStep < 2)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStep += 1;
                      });
                    },
                    child: Text('Next'),
                  ),
                if (currentStep == 2)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Order Completed Successfully!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Complete'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
