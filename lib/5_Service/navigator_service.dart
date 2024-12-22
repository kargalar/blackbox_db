
// ? veri gönder
// Get.toNamed('/second', arguments: {
//   'name': 'Joseph Onalo',
//   'age': 24,
// });

// ? veri al
// class SecondScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final name = Get.arguments['name'];
//     final age = Get.arguments['age'];

// Get.to('/second');
// Get.to(()=>const SecondScreen());

// Get.back();

// Belirli bir rotaya gitme
// Get.offAllNamed('/first');

// Mevcut rotanın üzerine yeni bir rota itme
// Get.toNamed('/third');

// Bilinen mevcut rotanın üzerine yeni bir rota itme
// Get.toNamed('/second/third');

// Get.to(NextScreen());
// Navigate to new screen with name. See more details on named routes here

// Get.toNamed('/details');
// To close snackbars, dialogs, bottomsheets, or anything you would normally close with Navigator.pop(context);

// Get.back();
// To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens, etc.)

// Get.off(NextScreen());
// To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

// Get.offAll(NextScreen());