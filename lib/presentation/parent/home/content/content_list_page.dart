import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/content/parent_content_provider.dart';
import '../../../../core/constant/color_constant.dart';
import '../../../../core/constant/textstyle_constant.dart';
import '../../../../core/extension/widget_ext.dart';
import '../../../../domain/models/content_model.dart';
import '../../../shared/app_text_field.dart';
import 'shared/content_card.dart';

@RoutePage()
class ContentListPage extends ConsumerStatefulWidget {
  const ContentListPage({super.key});

  @override
  ConsumerState<ContentListPage> createState() => _ContentListPageState();
}

class _ContentListPageState extends ConsumerState<ContentListPage> {
  String _searchQuery = '';
  ContentType? _selectedType;
  String _sortOrder = 'Newest';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(parentPublishedContentProvider);

    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.cream,
        title: Text('Resources', style: AppWidget.h2TextFieldStyle()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),

          Expanded(
            child: contentAsync.when(
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(
                      color: ThemeColor.darkBlue,
                    ),
                  ),
              error:
                  (err, _) =>
                      Center(child: Text('Failed to load content: $err')),
              data: (contents) {
                if (contents.isEmpty) {
                  return Center(
                    child: Text(
                      'No resources available yet.',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                  );
                }
                final filteredList =
                    contents.where((item) {
                        final matchesSearch = item.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );

                        final matchesType =
                            _selectedType == null || item.type == _selectedType;

                        return matchesSearch && matchesType;
                      }).toList()
                      ..sort((a, b) {
                        if (_sortOrder == 'Newest') {
                          return b.publishedAt.compareTo(a.publishedAt);
                        } else {
                          return a.publishedAt.compareTo(b.publishedAt);
                        }
                      });

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      'No matching resources found.',
                      style: AppWidget.bodyMedium().copyWith(
                        color: ThemeColor.grey100,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return buildContentCard(context, ref, filteredList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          AppTextField(
            controller: _searchController,
            hintText: 'Search by title...',
            prefixIcon: const Icon(Icons.search),
            iconColor: ThemeColor.grey100,
            fillColor: ThemeColor.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          12.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Type: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  8.widthBox,
                  DropdownButton<ContentType?>(
                    value: _selectedType,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem<ContentType?>(child: Text('All')),
                      DropdownMenuItem<ContentType?>(
                        value: ContentType.article,
                        child: Text('Article'),
                      ),
                      DropdownMenuItem<ContentType?>(
                        value: ContentType.video,
                        child: Text('Video'),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Date: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  8.widthBox,
                  DropdownButton<String>(
                    value: _sortOrder,
                    underline: const SizedBox(),
                    items:
                        ['Newest', 'Oldest'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _sortOrder = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
