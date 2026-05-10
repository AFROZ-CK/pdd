import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../models/dataset_model.dart';
import '../../theme/app_theme.dart';

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          indicatorColor: AppTheme.primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Datasets'),
            Tab(text: 'Data Viewer'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Import Dataset'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDatasetsTab(dataProvider),
          _buildDataViewerTab(dataProvider),
        ],
      ),
    );
  }

  Widget _buildDatasetsTab(DataProvider dataProvider) {
    final filtered = dataProvider.datasets
        .where((d) =>
            _searchQuery.isEmpty ||
            d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search datasets...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),

        // Stats row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _StatChip(
                  label: '${dataProvider.datasets.length} Datasets',
                  icon: Icons.storage_rounded,
                  color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              _StatChip(
                  label: '573K+ Rows',
                  icon: Icons.table_rows_rounded,
                  color: AppTheme.successColor),
              const SizedBox(width: 8),
              _StatChip(
                  label: '91.5 GB',
                  icon: Icons.disk_full_rounded,
                  color: AppTheme.warningColor),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Dataset list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _DatasetCard(
              dataset: filtered[i],
              onTap: () {
                dataProvider.selectDataset(filtered[i]);
                _tabController.animateTo(1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataViewerTab(DataProvider dataProvider) {
    final ds = dataProvider.selectedDataset ?? dataProvider.datasets.first;
    final rows = dataProvider.getTablePreview(ds.id);
    final columns = rows.isNotEmpty ? rows.first.keys.toList() : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dataset info header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.table_chart_rounded,
                  color: AppTheme.primaryColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ds.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppTheme.primaryColor)),
                    Text(
                        '${ds.formattedRowCount} rows • ${ds.columnCount} cols • ${ds.fileSize}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ds.qualityScore >= 90
                      ? AppTheme.successColor.withOpacity(0.15)
                      : AppTheme.warningColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ds.qualityLabel,
                  style: TextStyle(
                    color: ds.qualityScore >= 90
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Data table
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                    AppTheme.primaryColor.withOpacity(0.1)),
                columnSpacing: 20,
                dataRowMinHeight: 44,
                headingTextStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                dataTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                columns: columns
                    .map((c) => DataColumn(label: Text(c)))
                    .toList(),
                rows: rows.map((row) {
                  final hasMissing = row.values.any((v) => v == 'MISSING');
                  return DataRow(
                    color: WidgetStateProperty.resolveWith((states) {
                      if (hasMissing) return AppTheme.errorColor.withOpacity(0.05);
                      return null;
                    }),
                    cells: columns.map((c) {
                      final isMissing = row[c] == 'MISSING';
                      return DataCell(
                        Text(
                          row[c].toString(),
                          style: TextStyle(
                            color: isMissing ? AppTheme.errorColor : null,
                            fontWeight: isMissing ? FontWeight.w600 : null,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // Schema info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Schema Columns',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ds.columns
                    .map((col) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(col,
                              style: const TextStyle(
                                  color: AppTheme.primaryColor, fontSize: 11)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showUploadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Import Dataset',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ...[
              ('CSV File', Icons.description_outlined, '.csv, .txt'),
              ('JSON File', Icons.code_rounded, '.json, .jsonl'),
              ('Excel File', Icons.table_view_rounded, '.xlsx, .xls'),
              ('Database Connection', Icons.storage_rounded, 'PostgreSQL, MySQL'),
              ('API Endpoint', Icons.api_rounded, 'REST, GraphQL'),
            ].map((item) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.$2, color: AppTheme.primaryColor, size: 20),
                  ),
                  title: Text(item.$1),
                  subtitle: Text(item.$3, style: const TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.$1} import initiated')),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _DatasetCard extends StatelessWidget {
  final DatasetModel dataset;
  final VoidCallback onTap;

  const _DatasetCard({required this.dataset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final qualityColor = dataset.qualityScore >= 90
        ? AppTheme.successColor
        : dataset.qualityScore >= 75
            ? AppTheme.warningColor
            : AppTheme.errorColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.storage_rounded,
                      color: AppTheme.primaryColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataset.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(dataset.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(dataset.type,
                      style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoChip(Icons.table_rows_rounded, dataset.formattedRowCount, 'rows'),
                const SizedBox(width: 8),
                _InfoChip(Icons.view_column_rounded, '${dataset.columnCount}', 'cols'),
                const SizedBox(width: 8),
                _InfoChip(Icons.folder_rounded, dataset.fileSize, ''),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Quality',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 10)),
                    Text(
                      '${dataset.qualityScore.toStringAsFixed(1)}%',
                      style: TextStyle(
                          color: qualityColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Quality bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: dataset.qualityScore / 100,
                minHeight: 4,
                backgroundColor: qualityColor.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(qualityColor),
              ),
            ),
            const SizedBox(height: 10),
            // Tags
            Wrap(
              spacing: 6,
              children: dataset.tags
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('#$t',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 10)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _InfoChip(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
        const SizedBox(width: 4),
        Text(
          label.isNotEmpty ? '$value $label' : value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _StatChip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
