// @dart = 2.9

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('Testing App Performance', () {
    // don't know if I should put all declarations here or each one should be in its test

    final getStartedButton = find.text("Get Started");
    final getLoginButton = find.text("Login");
    final getUsernameField = find.byValueKey("UsernameField");
    final getPasswordField = find.byValueKey("PasswordField");
    final getProductButton = find.byValueKey("addProductButton");
    final nameTextField = find.byValueKey("nameField");
    final expirationDateTextField = find.byValueKey("expirationDateField");
    final datePicker = find.byValueKey("datePicker");
    final datePickerOk = find.byValueKey("datePickerOk");
    final quantityTextField = find.byValueKey("quantityField");
    final priceTextField = find.byValueKey("priceField");
    final saveProduct = find.text("Save");
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();

    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('Pass welcome page', () async {
      await driver.tap(getStartedButton);
      await sleep();
    });
    test('Log in with credentials', () async {
      await driver.tap(getUsernameField);
      await driver.enterText("hello@gmail.com");

      await driver.tap(getPasswordField);
      await driver.enterText("robert2020");
      await sleep();

      await driver.tap(getLoginButton);
    });

    test('Press add product button, fill in the fields and save', () async {

      await driver.tap(getProductButton);
      await driver.tap(expirationDateTextField);
      await driver.scroll(datePicker, 0, 50, Duration(milliseconds: 50));

      await driver.tap(quantityTextField);
      await driver.enterText("quantityTest");

      await driver.tap(nameTextField);
      await driver.enterText("productTest");

      await driver.tap(quantityTextField);
      await driver.enterText("quantityTest");

      await driver.tap(priceTextField);
      await driver.enterText("priceTest");

      await driver.tap(saveProduct);
    });


  });
}

Future sleep() {
  return new Future.delayed(const Duration(seconds: 2), () => "1");
}