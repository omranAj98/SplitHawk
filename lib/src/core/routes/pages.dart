library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/contact/contact_cubit.dart';
import 'package:splithawk/src/blocs/expense/expense_cubit.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/blocs/user/user_cubit.dart';
import 'package:splithawk/src/core/cubit/menu_cubit.dart';
import 'package:splithawk/src/core/services/service_locator.dart';
import 'package:splithawk/src/core/widgets/not_found_page.dart';
import 'package:splithawk/src/models/contact_model.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/views/contacts/add_friend_screen.dart';
import 'package:splithawk/src/views/contacts/add_new_friend_screen.dart';
import 'package:splithawk/src/views/contacts/edit_contact_info_screen.dart';
import 'package:splithawk/src/views/contacts/verify_contact_info_screen.dart';
import 'package:splithawk/src/views/home/expense_details_screen.dart';
import 'package:splithawk/src/views/new_expense/expense_split_options_screen.dart';
import 'package:splithawk/src/views/main_page.dart';
import 'package:splithawk/src/views/new_expense/add_expense_screen.dart';
import 'package:splithawk/src/views/reset_password_screen.dart';
import 'package:splithawk/src/views/signin_page.dart';
import 'package:splithawk/src/views/signup/signup_screen.dart';
import 'package:splithawk/src/views/splash_page.dart';
import 'package:splithawk/src/views/account/account_linking/account_linking_screen.dart';
import 'package:splithawk/src/views/home/friend_expenses_screen.dart';
import 'routes.dart';

final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _addExpenseNavigatorKey = GlobalKey<NavigatorState>();
final _addFriendNavigatorKey = GlobalKey<NavigatorState>();
final _friendNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',

  routes: [
    ShellRoute(
      navigatorKey: _rootNavigatorKey,
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<UserCubit>.value(value: locator<UserCubit>()),
            BlocProvider<FriendCubit>.value(value: locator<FriendCubit>()),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: AppRoutesName.init,
          builder:
              (context, state) => PopScope(canPop: false, child: SplashPage()),
          routes: [
            GoRoute(
              path: 'signin',
              name: AppRoutesName.signin,

              builder: (context, state) {
                final email = state.uri.queryParameters['email'];
                // locator.reset;
                return PopScope(
                  canPop: false,
                  child: SigninPage(initEmail: email ?? ''),
                  
                );
              },
            ),
            ShellRoute(
              navigatorKey: _shellNavigatorKey,
              builder: (context, state, child) {
                return PopScope(
                  canPop: false,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<ExpenseCubit>.value(
                        value: locator<ExpenseCubit>(),
                      ),
                    ],
                    child: child,
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: "main",
                  name: AppRoutesName.main,
                  builder: (context, state) {
                    return BlocProvider<MenuCubit>.value(
                      value: locator<MenuCubit>(),
                      child: MainPage(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'home',
                      name: AppRoutesName.home,
                      builder: (context, state) {
                        context.read<FriendCubit>().updateSearchText('');
                        return BlocProvider<MenuCubit>.value(
                          value: locator<MenuCubit>(),
                          child: MainPage(),
                        );
                      },
                      routes: [
                        ShellRoute(
                          navigatorKey: _addExpenseNavigatorKey,
                          builder: (context, state, child) {
                            return BlocProvider(
                              create: (context) => locator<ContactCubit>(),
                              child: child,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: 'add_expense',
                              name: AppRoutesName.addExpense,
                              builder: (context, state) {
                                context.read<FriendCubit>().updateSearchText(
                                  '',
                                );
                                final extra =
                                    state.extra as Map<String, dynamic>?;
                                final friendsList =
                                    extra?['friendsList']
                                        as List<FriendDataModel>? ??
                                    [];
                                return AddExpenseScreen(
                                  friendsList: friendsList,
                                );
                              },
                            ),
                            GoRoute(
                              path: 'split_options',
                              name: AppRoutesName.splitOptions,
                              builder: (context, state) {
                                final extra =
                                    state.extra as Map<String, dynamic>?;
                                return ExpenseSplitOptionsScreen(
                                  amount: extra?['amount'] ?? '',
                                  selectedFriends:
                                      extra?['selectedFriends'] ?? '',
                                );
                              },
                            ),
                            ShellRoute(
                              navigatorKey: _addFriendNavigatorKey,
                              builder: (context, state, child) {
                                child;
                                return child;
                              },
                              routes: [
                                GoRoute(
                                  path: 'add_friend',
                                  name: AppRoutesName.addFriend,
                                  builder: (context, state) {
                                    return AddFriendScreen();
                                  },
                                  routes: [
                                    GoRoute(
                                      path: 'add_new_friend',
                                      name: AppRoutesName.addNewFriend,
                                      builder: (context, state) {
                                        return AddNewFriendScreen();
                                      },
                                    ),
                                    GoRoute(
                                      path: 'verify_friend_info',
                                      name: AppRoutesName.verifyFriendInfo,
                                      builder: (context, state) {
                                        return VerifyContactInfoScreen();
                                      },
                                      routes: [
                                        GoRoute(
                                          path: "edit_contact_info",
                                          name: AppRoutesName.editContactInfo,
                                          builder: (context, state) {
                                            final contact =
                                                state.extra as ContactModel;
                                            return EditContactInfoScreen(
                                              contact: contact,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            ShellRoute(
                              navigatorKey: _friendNavigatorKey,
                              builder: (context, state, child) {
                                return child;
                              },
                              routes: [
                                GoRoute(
                                  path: 'friend_expenses',
                                  name: AppRoutesName.friendExpenses,
                                  parentNavigatorKey: _friendNavigatorKey,
                                  builder: (context, state) {
                                    final extra =
                                        state.extra as Map<String, dynamic>?;
                                    return BlocProvider<MenuCubit>.value(
                                      value: locator<MenuCubit>(),
                                      child: FriendExpensesScreen(
                                        friend: extra?['friend'] ?? '',
                                        selfUserRef:
                                            extra?['selfUserRef'] ?? '',
                                      ),
                                    );
                                  },
                                  routes: [
                                    GoRoute(
                                      path: 'expense_details',
                                      name: AppRoutesName.expenesDetails,
                                      parentNavigatorKey: _friendNavigatorKey,
                                      builder: (context, state) {
                                        final extra =
                                            state.extra
                                                as Map<String, dynamic>?;
                                        return ExpenseDetailsScreen(
                                          expenseData:
                                              extra?['expenseData'] ?? '',
                                          friend: extra?['friend'] ?? '',
                                          selfUserRef:
                                              extra?['selfUserRef'] ?? '',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    GoRoute(
                      path: 'account',
                      name: AppRoutesName.account,
                      builder: (context, state) {
                        return PopScope(canPop: false, child: MainPage());
                      },
                      routes: [
                        GoRoute(
                          path: 'linking',
                          name: AppRoutesName.accountLinking,
                          builder: (context, state) {
                            return AccountLinkingScreen();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'reset_password',
              name: AppRoutesName.resetPassword,
              builder: (context, state) {
                final email = state.uri.queryParameters['email'];
                return ResetPasswordScreen(initEmail: email);
              },
            ),
            GoRoute(
              path: 'signup',
              name: AppRoutesName.signup,
              builder: (context, state) {
                final email = state.uri.queryParameters['email'];
                return SignupScreen(initEmail: email ?? '');
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder:
      (context, state) => const NotFoundPage(), // Handles unknown routes
);
