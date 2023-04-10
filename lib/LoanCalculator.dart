import 'dart:math';

import 'package:appartement/MyFooter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoanCalculator extends StatefulWidget {
  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  int _loanAmount = 50000;
  double _interestRate = 3.3;
  double _insuranceRate = 0.3;
  int _loanTerm = 20;
  double _monthlyPayment = 0.0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _calculateMonthlyPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _loanAmount.toString(),
                decoration: InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _loanAmount = int.parse(value);
                  }

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _calculateMonthlyPayment();
                  }
                },
              ),
              TextFormField(
                initialValue: _interestRate.toString(),
                decoration: InputDecoration(labelText: 'Interest Rate'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _interestRate = double.parse(value);
                  }
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _calculateMonthlyPayment();
                  }
                },
              ),
              TextFormField(
                initialValue: _insuranceRate.toString(),
                decoration: InputDecoration(labelText: 'Insurance Rate'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _insuranceRate = double.parse(value);
                  }
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _calculateMonthlyPayment();
                  }
                },
              ),
              TextFormField(
                initialValue: _loanTerm.toString(),
                decoration: InputDecoration(labelText: 'Loan Term (years)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _loanTerm = int.parse(value);
                  }
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _calculateMonthlyPayment();
                  }
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Monthly Payment: \$${_monthlyPayment.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyFooter(),
    );
  }

  void _calculateMonthlyPayment() {
    double monthlyInterestRate = _interestRate / 1200.0;
    double monthlyInsuranceRate = _insuranceRate / 1200.0;
    int numberOfPayments = _loanTerm * 12;
    // double monthlyPayment = (_loanAmount * monthlyInterestRate) /
    //     (1 - pow(1 + monthlyInterestRate, -numberOfPayments));
    double monthlyPayment = (_loanAmount *
            monthlyInterestRate *
            pow(1 + monthlyInterestRate, numberOfPayments)) /
        (pow(1 + monthlyInterestRate, numberOfPayments) - 1);

    double insurancePayment = (_loanAmount * monthlyInsuranceRate);
    setState(() {
      _monthlyPayment = monthlyPayment + insurancePayment;
    });
  }
}
