import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/anchorwise/chat_models.dart';
import '../blocs/anchorwise/anchorwise_bloc.dart';
import '../blocs/anchorwise/anchorwise_event.dart';
import '../blocs/anchorwise/anchorwise_state.dart';

class ConversationHistoryDialog extends StatelessWidget {
  const ConversationHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Text(
                  'Conversation History',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<AnchorWiseBloc, AnchorWiseState>(
                builder: (context, state) {
                  if (state.isLoadingConversations) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.conversations.isEmpty) {
                    return const Center(child: Text('No conversations found'));
                  }

                  return ListView.builder(
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      return _ConversationTile(
                        conversation: conversation,
                        onTap: () {
                          context.read<AnchorWiseBloc>().add(
                            AnchorWiseSelectConversation(
                              conversation.conversationId,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationItem conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.chat, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(
          conversation.title,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () {
            _showDeleteConfirmation(context, conversation);
          },
          icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
          tooltip: 'Delete conversation',
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ConversationItem conversation,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: Text(
            'Are you sure you want to delete "${conversation.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AnchorWiseBloc>().add(
                  AnchorWiseDeleteConversation(conversation.conversationId),
                );
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
