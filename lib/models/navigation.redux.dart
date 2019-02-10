class NavigationState {
  int index;

  NavigationState({ this.index });
}

NavigationState navigationReducer(NavigationState state, dynamic action) {
  if(action is SetNavigationIndex)
  {
    return setIndex(state, action);
  } else {
    return NavigationState(index: 0);
  }
}

NavigationState setIndex(NavigationState state, SetNavigationIndex action)
{
    return NavigationState(index: action.index);
}


class SetNavigationIndex {
  final int index;

  SetNavigationIndex({this.index});
}