import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../providers/test_feature_provider.dart';

class TestFeatureScreen extends StatefulWidget {
  const TestFeatureScreen({super.key});

  @override
  State<TestFeatureScreen> createState() => _TestFeatureScreenState();
}

class _TestFeatureScreenState extends State<TestFeatureScreen> {
  late TestFeatureProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = TestFeatureProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadAll();
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Test Feature',
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
        body: Consumer<TestFeatureProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error != null) {
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
                        provider.error!,
                        style: ThemeTextStyles.bodyMedium.copyWith(
                          color: ThemeColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => provider.loadAll(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (provider.items.isEmpty) {
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
                        'No Test Feature Yet',
                        style: ThemeTextStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get started by creating your first ',
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
              onRefresh: provider.loadAll,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNewItem,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _createNewItem() {
    // TODO: Navigate to create screen
    AppRouter.showSnackbar('Create Test Feature functionality coming soon!');
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
        title: const Text('Delete Test Feature'),
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
                _provider.deleteTestFeature(item.id!);
                AppRouter.showSnackbar('Test Feature deleted successfully');
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