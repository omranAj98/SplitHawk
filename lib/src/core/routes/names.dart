library;

class AppRoutesName {
  static const String init = 'initial';
  static const String signin = 'signin';
  static const String signup = 'signup';
  static const String resetPassword = '/reset_password';

  static const String home = '/home';
  static const String friendExpenses = 'home/friend_expenses';
  static const String expenesDetails = '$friendExpenses/expense_details';

  static const String main = '/main';
  static const String splash = 'splash';
  static const String addFriend = '/main/home/add_friend';
  static const String addNewFriend = '$addFriend/add_new_friend';
  static const String verifyFriendInfo = '$addFriend/verify_friend_info';
  static const String editContactInfo = '$verifyFriendInfo/edit_contact_info';
  static const String account = 'main/account';
  static const String accountLinking = '$account/linking';

  static const String addExpense = 'main/home/add_expense';
  static const String splitOptions = '$addExpense/split_options';
  static const String splitOptionsEqual = '$splitOptions/equal';
  static const String splitOptionsUnequal = '$splitOptions/unequal';
}
