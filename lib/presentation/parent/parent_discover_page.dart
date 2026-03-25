import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/app_text_field.dart';

class ParentDiscoverPage extends ConsumerStatefulWidget {
  const ParentDiscoverPage({super.key});

  @override
  ConsumerState<ParentDiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<ParentDiscoverPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      appBar: AppBar(
        backgroundColor: ThemeColor.backgroundAquaBlue,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Find Coaches Near You',
          style: AppWidget.h2TextFieldStyle(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _searchController,
                    hintText: 'Search by name, sport or location...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ThemeColor.grey100,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ThemeColor.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: ThemeColor.black),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  Container(
                    height: 280,
                    width: double.infinity,
                    color: ThemeColor.lightGrey,
                    child: const Center(
                      child: Text(
                        'Map Image Placeholder\n(Replace with your map asset)',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: ThemeColor.white,
                      child: Icon(Icons.my_location, color: ThemeColor.grey100),
                    ),
                  ),
                  const Positioned(
                    top: 70,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: ThemeColor.white,
                      child: Icon(Icons.navigation, color: ThemeColor.grey100),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return _buildHorizontalCoachCard();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            24.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Nearby Certified Trainers',
                style: AppWidget.h2TextFieldStyle(),
              ),
            ),
            12.heightBox,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildVerticalTrainerCard();
              },
            ),
            30.heightBox,
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCoachCard() {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: ThemeColor.grey100,
                child: Icon(Icons.person, color: ThemeColor.white),
              ),
              12.widthBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coach Dave',
                    style: AppWidget.bodyLarge().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '1.2 km away',
                    style: AppWidget.bodySmall().copyWith(
                      color: ThemeColor.grey100,
                    ),
                  ),
                  4.heightBox,
                  Row(
                    children: [
                      const Icon(Icons.pool, size: 16),
                      4.widthBox,
                      const Icon(Icons.sports_soccer, size: 16),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(
                Icons.verified,
                color: ThemeColor.lightOrange,
                size: 18,
              ),
              8.widthBox,
              Text(
                'Autism Training Certified',
                style: AppWidget.bodySmall().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalTrainerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: ThemeColor.grey100,
                child: Icon(Icons.person, color: ThemeColor.white, size: 40),
              ),
              16.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Matches',
                          style: AppWidget.bodyLarge().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' 4.9',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    4.heightBox,
                    Text(
                      'Bio is surname sports in and traineer. Sported mis with Am...',
                      style: AppWidget.bodySmall().copyWith(
                        color: ThemeColor.grey100,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.heightBox,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.aquaBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Next: Wed, 10 AM',
                        style: AppWidget.bodySmall().copyWith(
                          color: ThemeColor.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.heightBox,
          Text(
            'Specialized Certifications',
            style: AppWidget.bodySmall().copyWith(color: ThemeColor.grey100),
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: ThemeColor.lightOrange.withValues(
                      alpha: 0.3,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 16,
                      color: ThemeColor.orange,
                    ),
                  ),
                  8.widthBox,
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: ThemeColor.aquaBlue,
                    child: Icon(
                      Icons.security,
                      size: 16,
                      color: ThemeColor.darkBlue,
                    ),
                  ),
                  8.widthBox,
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: ThemeColor.red.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.medical_services,
                      size: 16,
                      color: ThemeColor.negative,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColor.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Book Now',
                    style: AppWidget.bodyMedium().copyWith(
                      color: ThemeColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
