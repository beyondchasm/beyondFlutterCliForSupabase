import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../providers/{{feature_name}}_provider.dart';

class {{feature_name.pascalCase()}}Screen extends ConsumerStatefulWidget {
  const {{feature_name.pascalCase()}}Screen({super.key});

  @override
  ConsumerState<{{feature_name.pascalCase()}}Screen> createState() => _{{feature_name.pascalCase()}}ScreenState();
}

class _{{feature_name.pascalCase()}}ScreenState extends ConsumerState<{{feature_name.pascalCase()}}Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read({{feature_name.camelCase()}}Provider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final {{feature_name.camelCase()}}State = ref.watch({{feature_name.camelCase()}}Provider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '{{feature_name.titleCase()}}',
            style: ThemeTextStyles.appBarTitle,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search functionality
                AppRouter.showSnackbar('Search functionality coming soon!');
              },
            ),
          ],
        ),
        body: {{feature_name.camelCase()}}State.when(
          data: (state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: ThemeColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: ThemeTextStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        style: ThemeTextStyles.bodyMedium.copyWith(
                          color: ThemeColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref.read({{feature_name.camelCase()}}Provider.notifier).loadAll(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: ThemeColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No {{feature_name.titleCase()}} Yet',
                        style: ThemeTextStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get started by creating your first {{feature_name.toLowerCase()}}',
                        style: ThemeTextStyles.bodyMedium.copyWith(
                          color: ThemeColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ref.read({{feature_name.camelCase()}}Provider.notifier).loadAll(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        item.name,
                        style: ThemeTextStyles.titleMedium,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Created: ${_formatDate(item.createdAt)}',
                          style: ThemeTextStyles.bodySmall,
                        ),
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: ThemeColors.error),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: ThemeColors.error)),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editItem(item);
                          } else if (value == 'delete') {
                            _deleteItem(context, item);
                          }
                        },
                      ),
                      onTap: () {
                        _viewItemDetails(item);
                      },
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: ThemeColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: ThemeTextStyles.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: ThemeTextStyles.bodyMedium.copyWith(
                      color: ThemeColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.read({{feature_name.camelCase()}}Provider.notifier).loadAll(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNewItem,
          child: const Icon(Icons.add),
        ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _createNewItem() {
    // TODO: Navigate to create screen
    AppRouter.showSnackbar('Create {{feature_name.titleCase()}} functionality coming soon!');
  }

  void _editItem(dynamic item) {
    // TODO: Navigate to edit screen
    AppRouter.showSnackbar('Edit functionality coming soon!');
  }

  void _viewItemDetails(dynamic item) {
    // TODO: Navigate to details screen
    AppRouter.showSnackbar('Details view coming soon!');
  }

  void _deleteItem(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete {{feature_name.titleCase()}}'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => AppRouter.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              AppRouter.pop();
              if (item.id != null) {
                ref.read({{feature_name.camelCase()}}Provider.notifier).delete(item.id!);
                AppRouter.showSnackbar('{{feature_name.titleCase()}} deleted successfully');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: ThemeColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}