class ActiveChatScreens {
  static final Map<int, bool> _activeConversations = {};

  static void setActive(int conversationId) {
    _activeConversations[conversationId] = true;
  }

  static void setInactive(int conversationId) {
    _activeConversations.remove(conversationId);
  }

  static bool isActive(int conversationId) {
    return _activeConversations[conversationId] ?? false;
  }
}
