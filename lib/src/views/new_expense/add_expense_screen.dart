import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:splithawk/src/blocs/friend/friend_cubit.dart';
import 'package:splithawk/src/core/localization/l10n/app_localizations.dart';
import 'package:splithawk/src/core/widgets/app_safe_area.dart';
import 'package:splithawk/src/models/friend_data_model.dart';
import 'package:splithawk/src/views/new_expense/expense_details.dart';
import 'package:splithawk/src/views/home/widgets/friends_item.dart';
import 'package:splithawk/src/views/new_expense/selected_friends_list.dart';

class AddExpenseScreen extends StatefulWidget {
  final List<FriendDataModel> friendsList;
  const AddExpenseScreen({super.key, required this.friendsList});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  final FocusNode searchFocusNode = FocusNode(debugLabel: 'searchFocusNode');
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Add this flag to control list visibility
  bool _showFriendsList = true;
  final TextEditingController _searchController = TextEditingController();

  // Use a GlobalKey to access the ExpenseDetails state
  final GlobalKey<ExpenseDetailsState> _expenseDetailsKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Setup animation for smooth transitions
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    searchFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    // Only update state if the focus state actually changes the UI
    if (mounted && searchFocusNode.hasFocus != _showFriendsList) {
      setState(() {
        _showFriendsList = searchFocusNode.hasFocus;
      });
    }
  }

  void _navigateToExpenseDetails() {
    setState(() {
      _showFriendsList = false;
    });
    _animationController.forward();
    FocusScope.of(context).unfocus();
  }

  void _handleFriendSelection(FriendDataModel friend) {
    context.read<FriendCubit>().selectFriendToExpense(friend);

    // Keep focus on search field for continuous selection
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(searchFocusNode);
        // Clear search text after selection for better UX
        _searchController.clear();
        context.read<FriendCubit>().updateSearchText('');
      }
    });
  }

  @override
  void dispose() {
    searchFocusNode.removeListener(_handleFocusChange);
    searchFocusNode.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(),
      body: AppSafeArea(
        child: Column(
          children: [
            _buildSearchAndSelectedFriendsArea(),
            Expanded(
              child: Stack(
                children: [
                  // Always keep ExpenseDetails in the widget tree but control visibility
                  Positioned.fill(
                    child: Visibility(
                      visible:
                          !_showFriendsList &&
                          context
                              .watch<FriendCubit>()
                              .state
                              .selectedFriends!
                              .isNotEmpty,
                      maintainState: true, // Important: Keep the widget state
                      child: FadeTransition(
                        opacity: _animation,
                        child: ExpenseDetails(key: _expenseDetailsKey),
                      ),
                    ),
                  ),

                  // Show friends list when needed
                  Positioned.fill(
                    child: Visibility(
                      visible:
                          _showFriendsList ||
                          context
                              .watch<FriendCubit>()
                              .state
                              .selectedFriends!
                              .isEmpty,
                      child: _buildFriendsList(
                        context.watch<FriendCubit>().state,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      title: Text(AppLocalizations.of(context)!.addExpense),
      actions: [
        _showFriendsList
            ? TextButton(
              onPressed: _navigateToExpenseDetails,
              child: Text(AppLocalizations.of(context)!.next),
            )
            : TextButton(
              onPressed: () => _expenseDetailsKey.currentState?.submitExpense(),
              child: Text(AppLocalizations.of(context)!.done),
            ),
      ],
    );
  }

  Widget _buildSearchAndSelectedFriendsArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: [
          BlocBuilder<FriendCubit, FriendState>(
            buildWhen:
                (previous, current) =>
                    previous.selectedFriends != current.selectedFriends,
            builder: (context, state) {
              return SelectedFriendsList(
                friendsList: state.selectedFriends ?? [],
              );
            },
          ),

          // Search field
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: double.maxFinite,
            ),
            child: Focus(
              focusNode: searchFocusNode,
              onFocusChange: (hasFocus) {
                if (hasFocus && !_showFriendsList) {
                  _animationController.reverse();
                  setState(() {
                    _showFriendsList = true;
                  });
                }
              },
              child: TextField(
                controller: _searchController,
                autofocus: true,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withAlpha(30),
                ),
                onChanged:
                    (value) =>
                        context.read<FriendCubit>().updateSearchText(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildMainContent() {
  //   return BlocBuilder<FriendCubit, FriendState>(
  //     builder: (context, friendState) {
  //       return Stack(
  //         children: [
  //           // Always keep ExpenseDetails in the widget tree but control visibility
  //           Positioned.fill(
  //             child: Visibility(
  //               visible:
  //                   !_showFriendsList &&
  //                   friendState.selectedFriends!.isNotEmpty,
  //               maintainState: true, // Important: Keep the widget state
  //               child: FadeTransition(
  //                 opacity: _animation,
  //                 child: ExpenseDetails(key: _expenseDetailsKey),
  //               ),
  //             ),
  //           ),
  //           // Show friends list when needed
  //           if (_showFriendsList || friendState.selectedFriends!.isEmpty)
  //             _buildFriendsList(friendState),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildFriendsList(FriendState friendState) {
    final friends = friendState.filteredFriends ?? widget.friendsList;

    if (friends.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noSearchResults,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      // shrinkWrap: true,
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final isSelected =
            friendState.selectedFriends?.contains(friend) ?? false;

        return Card(
          elevation: 0,
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primaryContainer.withAlpha(40)
                  : null,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleFriendSelection(friend),
            child: FriendItem(friend: friend),
          ),
        );
      },
    );
  }
}
