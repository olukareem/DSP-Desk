import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/header.dart';
import '../../components/side_nav.dart';
import '../../theme/buttons.dart';
import 'fleet overview/add_new_fleet_screen.dart';
import 'fleet overview/fleet_details_screen.dart';

class FleetOverviewScreen extends StatefulWidget {
  const FleetOverviewScreen({super.key});

  @override
  State<FleetOverviewScreen> createState() => _FleetOverviewScreenState();
}

class _FleetOverviewScreenState extends State<FleetOverviewScreen> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  Map<String, List<String>>? activeFilters;
  String? _currentSortField;
  bool _isAscending = true;
  static const int itemsPerPage = 3;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _currentSortField = 'ID';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        _showSearch = false;
        _searchController.clear();
        _searchQuery = '';
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  int _calculateTotalPages(int totalItems) {
    return (totalItems / itemsPerPage).ceil();
  }

  List<QueryDocumentSnapshot> _getPaginatedItems(
      List<QueryDocumentSnapshot> items) {
    final startIndex = (_currentPage - 1) * itemsPerPage;
    final endIndex = min(startIndex + itemsPerPage, items.length);
    return items.sublist(startIndex, endIndex);
  }

  bool _matchesSearch(Map<String, dynamic> vehicle, String query) {
    if (query.isEmpty) return true;

    final searchableFields = [
      vehicle['name']?.toString().toLowerCase() ?? '',
      vehicle['operator']?.toString().toLowerCase() ?? '',
      vehicle['license']?.toString().toLowerCase() ?? '',
      vehicle['vin']?.toString().toLowerCase() ?? '',
      vehicle['type']?.toString().toLowerCase() ?? '',
      vehicle['make']?.toString().toLowerCase() ?? '',
      vehicle['model']?.toString().toLowerCase() ?? '',
      vehicle['group']?.toString().toLowerCase() ?? '',
      vehicle['status']?.toString().toLowerCase() ?? '',
    ];

    return searchableFields.any((field) => field.contains(query.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: SideNav(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: const Color.fromRGBO(249, 250, 252, 1),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fleet List',
                    style: GoogleFonts.spectral(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.54,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_showSearch)
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE4E2E6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              hintText: '',
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  width: 12,
                                  height: 12,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF8D8D8D),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _showSearch = false;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                          ),
                        ),
                      )
                    else
                      SearchButton(onPressed: _toggleSearch),
                    if (!_showSearch) ...[
                      const SizedBox(width: 28),
                      SortByButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => FleetSortDialog(
                              currentSortField: _currentSortField,
                              isAscending: _isAscending,
                              onApplySort: (field, isAscending) {
                                setState(() {
                                  _currentSortField = field;
                                  _isAscending = isAscending;
                                });
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 28),
                      FilterButton(onPressed: _showFilterDialog),
                      const SizedBox(width: 28),
                      AppButton(
                        text: '+ Add New',
                        variant: ButtonVariant.primary,
                        isFullWidth: false,
                        size: ButtonSize.medium,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEditFleetScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('fleets')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No fleets found.'));
                    }

                    final allFleets = snapshot.data!.docs;
                    final filteredFleets = allFleets.where((doc) {
                      final vehicleData = doc.data() as Map<String, dynamic>;
                      return _matchesSearch(vehicleData, _searchQuery) &&
                          _matchesFilters(vehicleData);
                    }).toList();

                    filteredFleets.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;

                      dynamic fieldA;
                      dynamic fieldB;

                      switch (_currentSortField) {
                        case 'ID':
                          fieldA = dataA['fleetId'];
                          fieldB = dataB['fleetId'];
                          break;
                        case 'Status':
                          fieldA = dataA['status'];
                          fieldB = dataB['status'];
                          break;
                        case 'Location':
                          fieldA = dataA['state'];
                          fieldB = dataB['state'];
                          break;
                        case 'Mileage':
                          fieldA = dataA['miles'];
                          fieldB = dataB['miles'];
                          break;
                        case 'Fuel Level':
                          fieldA = dataA['fuel'];
                          fieldB = dataB['fuel'];
                          break;
                        case 'Health Status':
                          fieldA = dataA['maintenanceStatus'];
                          fieldB = dataB['maintenanceStatus'];
                          break;
                        default:
                          fieldA = dataA['fleetId'];
                          fieldB = dataB['fleetId'];
                      }

                      if (fieldA is String && fieldB is String) {
                        return _isAscending
                            ? fieldA.compareTo(fieldB)
                            : fieldB.compareTo(fieldA);
                      } else if (fieldA is num && fieldB is num) {
                        return _isAscending
                            ? fieldA.compareTo(fieldB)
                            : fieldB.compareTo(fieldA);
                      } else {
                        return 0;
                      }
                    });

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                _getPaginatedItems(filteredFleets).length,
                            itemBuilder: (context, index) {
                              final vehicle =
                                  _getPaginatedItems(filteredFleets)[index]
                                      .data() as Map<String, dynamic>;

                              final String name =
                                  vehicle['name'] ?? 'Unknown Vehicle';
                              final String driver = vehicle['driver'] ?? 'N/A';
                              final String fuel = '${vehicle['fuel'] ?? 0}%';
                              final String license =
                                  vehicle['license'] ?? 'N/A';
                              final String alert = vehicle['alert'] ?? 'None';
                              final String miles =
                                  '${vehicle['miles'] ?? 0} miles';
                              final String vin = vehicle['vin'] ?? 'N/A';
                              final String status =
                                  vehicle['status'] ?? 'No Status';

                              Color badgeColor;
                              Color textColor;
                              Color dotColor;

                              switch (status) {
                                case 'Active':
                                  badgeColor = const Color(0xFFECFDF3);
                                  textColor = const Color(0xFF027A48);
                                  dotColor = const Color(0xFF12B76A);
                                  break;
                                case 'Break':
                                  badgeColor = const Color(0xFFECEFFF);
                                  textColor = const Color(0xFF1C4A97);
                                  dotColor = const Color(0xFF1C4A97);
                                  break;
                                case 'Unavailable':
                                  badgeColor = const Color(0xFFFFEDED);
                                  textColor = const Color(0xFFC40A0A);
                                  dotColor = const Color(0xFFC40A0A);
                                  break;
                                default:
                                  badgeColor =
                                      const Color.fromRGBO(249, 250, 252, 1);
                                  textColor =
                                      const Color.fromRGBO(102, 112, 133, 1);
                                  dotColor =
                                      const Color.fromRGBO(155, 154, 160, 1);
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FleetDetailsScreen(
                                        fleetId: filteredFleets[index].id,
                                        fleetData: vehicle,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xFFECECEC)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _editVehicle(context, vehicle,
                                                    filteredFleets[index].id);
                                              } else if (value == 'delete') {
                                                _deleteVehicle(context,
                                                    filteredFleets[index].id);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                            icon: const Icon(Icons.more_horiz,
                                                size: 16,
                                                color: Color(0xFF8D8D8D)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _buildSpanText('Driver:', driver),
                                          _buildDot(),
                                          _buildSpanText('Fuel:', fuel),
                                          _buildDot(),
                                          _buildSpanText('License:', license),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _buildSpanText('Alert:', alert),
                                          const SizedBox(width: 8),
                                          Text(
                                            miles,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF667085),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildSpanText('VIN:', vin),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: badgeColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: dotColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  status,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (filteredFleets.length > itemsPerPage)
                          FleetPagination(
                            currentPage: _currentPage,
                            totalPages:
                                _calculateTotalPages(filteredFleets.length),
                            onPageChanged: (page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpanText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: '$label ',
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF667085),
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color(0xFF9B9AA0),
        shape: BoxShape.circle,
      ),
    );
  }

  void _editVehicle(
      BuildContext context, Map<String, dynamic> vehicle, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditFleetScreen(
          fleetData: vehicle,
          fleetId: id,
        ),
      ),
    );
  }

  void _deleteVehicle(BuildContext context, String id) {
    FirebaseFirestore.instance.collection('fleets').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fleet deleted successfully')),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.only(
          top: 40,
          left: 13,
          right: 13,
          bottom: 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: 364,
          ),
          child: FleetFilter(
            activeFilters: activeFilters,
            onApplyFilters: (selectedFilters) {
              setState(() {
                activeFilters = selectedFilters;
              });
            },
          ),
        ),
      ),
    );
  }

  bool _matchesFilters(Map<String, dynamic> vehicle) {
    if (activeFilters == null || activeFilters!.isEmpty) return true;

    for (var entry in activeFilters!.entries) {
      switch (entry.key) {
        case 'STATUS':
          if (!entry.value.contains(vehicle['status']?.toString())) {
            return false;
          }
          break;
        case 'LOCATION':
          if (!entry.value.contains(vehicle['state']?.toString())) {
            return false;
          }
          break;
        case 'FLEET':
          if (!entry.value.contains(vehicle['type']?.toString())) {
            return false;
          }
          break;
        case 'MAINTENANCE':
          if (!entry.value.contains(vehicle['maintenanceStatus']?.toString())) {
            return false;
          }
          break;
      }
    }
    return true;
  }

  bool isMaintenanceDue(Map<String, dynamic> vehicle) {
    // Implement your maintenance due logic here
    // For example, check the last maintenance date against the current date
    final lastMaintenance = vehicle['lastMaintenanceDate'] as Timestamp?;
    if (lastMaintenance == null) return true;

    final daysSinceLastMaintenance =
        DateTime.now().difference(lastMaintenance.toDate()).inDays;
    return daysSinceLastMaintenance >
        90; // Assuming maintenance is due every 90 days
  }
}

class FilterOption {
  final String label;
  bool isSelected;

  FilterOption({required this.label, this.isSelected = false});
}

class FleetFilter extends StatefulWidget {
  final Function(Map<String, List<String>>) onApplyFilters;
  final Map<String, List<String>>? activeFilters;

  const FleetFilter({
    super.key,
    required this.onApplyFilters,
    this.activeFilters,
  });

  @override
  State<FleetFilter> createState() => _FleetFilterState();
}

class _FleetFilterState extends State<FleetFilter> {
  Map<String, List<FilterOption>> filterCategories = {
    'STATUS': [],
    'LOCATION': [],
    'FLEET': [],
    'MAINTENANCE': [],
  };

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

  Future<void> _loadFilterOptions() async {
    final QuerySnapshot fleets =
        await FirebaseFirestore.instance.collection('fleets').get();

    Set<String> statuses = {};
    Set<String> locations = {};
    Set<String> fleetTypes = {};
    Set<String> maintenanceStatuses = {};

    for (var doc in fleets.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['status'] != null) statuses.add(data['status'].toString());
      if (data['state'] != null) locations.add(data['state'].toString());
      if (data['type'] != null) fleetTypes.add(data['type'].toString());
      if (data['maintenanceStatus'] != null) {
        maintenanceStatuses.add(data['maintenanceStatus'].toString());
      }
    }

    setState(() {
      filterCategories['STATUS'] = statuses
          .map((s) => FilterOption(
                label: s,
                isSelected:
                    widget.activeFilters?['STATUS']?.contains(s) ?? false,
              ))
          .toList();

      filterCategories['LOCATION'] = locations
          .map((l) => FilterOption(
                label: l,
                isSelected:
                    widget.activeFilters?['LOCATION']?.contains(l) ?? false,
              ))
          .toList();

      filterCategories['FLEET'] = fleetTypes
          .map((f) => FilterOption(
                label: f,
                isSelected:
                    widget.activeFilters?['FLEET']?.contains(f) ?? false,
              ))
          .toList();

      filterCategories['MAINTENANCE'] = maintenanceStatuses
          .map((m) => FilterOption(
                label: m,
                isSelected:
                    widget.activeFilters?['MAINTENANCE']?.contains(m) ?? false,
              ))
          .toList();

      // Set maintenance filters if they were previously selected
      if (widget.activeFilters?['MAINTENANCE'] != null) {
        for (var option in filterCategories['MAINTENANCE']!) {
          option.isSelected =
              widget.activeFilters!['MAINTENANCE']!.contains(option.label);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -2,
            color: const Color(0x10101828),
          ),
          BoxShadow(
            offset: const Offset(0, 12),
            blurRadius: 16,
            spreadRadius: -4,
            color: const Color(0x1A101828),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Filters',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
            width: double.infinity,
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...filterCategories.entries
                        .map((category) => _buildFilterSection(
                              category.key,
                              category.value,
                            )),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  text: 'Clear',
                  variant: ButtonVariant.outline,
                  size: ButtonSize.medium,
                  onPressed: _clearFilters,
                ),
                const SizedBox(width: 12),
                AppButton(
                  text: 'Apply',
                  variant: ButtonVariant.primary,
                  size: ButtonSize.medium,
                  onPressed: _applyFilters,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<FilterOption> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF667085),
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) => _buildFilterChip(option)).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterChip(FilterOption option) {
    return FilterChip(
      label: Text(
        option.label,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          color: option.isSelected
              ? const Color.fromRGBO(1, 107, 228, 1)
              : const Color.fromRGBO(102, 112, 133, 1),
        ),
      ),
      selected: option.isSelected,
      onSelected: (selected) {
        setState(() {
          option.isSelected = selected;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: option.isSelected
              ? Color.fromRGBO(1, 107, 228, 1)
              : const Color.fromRGBO(234, 236, 240, 1),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      for (var options in filterCategories.values) {
        for (var option in options) {
          option.isSelected = false;
        }
      }
    });
  }

  void _applyFilters() {
    Map<String, List<String>> selectedFilters = {};
    for (var entry in filterCategories.entries) {
      final selectedOptions = entry.value
          .where((option) => option.isSelected)
          .map((option) => option.label)
          .toList();
      if (selectedOptions.isNotEmpty) {
        selectedFilters[entry.key] = selectedOptions;
      }
    }
    widget.onApplyFilters(selectedFilters);
    Navigator.pop(context);
  }
}

class FleetSortDialog extends StatefulWidget {
  final Function(String, bool) onApplySort;
  final String? currentSortField;
  final bool isAscending;

  const FleetSortDialog({
    super.key,
    required this.onApplySort,
    this.currentSortField,
    this.isAscending = true,
  });

  @override
  _FleetSortDialogState createState() => _FleetSortDialogState();
}

class _FleetSortDialogState extends State<FleetSortDialog> {
  String? _selectedSortField;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _selectedSortField = widget.currentSortField ?? 'ID';
    _isAscending = widget.isAscending;
  }

  void _onFieldSelected(String field) {
    setState(() {
      _selectedSortField = field;
    });
    widget.onApplySort(_selectedSortField!, _isAscending);
  }

  void _toggleOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
    widget.onApplySort(_selectedSortField!, _isAscending);
  }

  void _clearFilters() {
    setState(() {
      _selectedSortField = 'ID';
      _isAscending = true;
    });
    widget.onApplySort(_selectedSortField!, _isAscending);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(
        top: 40,
        left: 44,
        right: 30,
        bottom: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 301,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Container(
          width: 301,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -2,
                color: const Color(0x03101828),
              ),
              BoxShadow(
                offset: const Offset(0, 12),
                blurRadius: 16,
                spreadRadius: -4,
                color: const Color(0x08101828),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Sort By',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212429),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: const Color(0xFFEAECF0),
                width: double.infinity,
              ),
              // Sort Options
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSortOption('ID'),
                      _buildSortOption('Status'),
                      _buildSortOption('Location'),
                      _buildSortOption('Mileage'),
                      _buildSortOption('Fuel Level'),
                      _buildSortOption('Health Status'),
                      const SizedBox(height: 16),
                      // Order
                      InkWell(
                        onTap: _toggleOrder,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                'Order:',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF555555),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isAscending ? 'Ascending' : 'Descending',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF555555),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                color: const Color(0xFFEAECF0),
                width: double.infinity,
              ),
              // Clear Filters
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: _clearFilters,
                  child: Text(
                    'Clear Filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(28, 74, 151, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String field) {
    return InkWell(
      onTap: () => _onFieldSelected(field),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              padding: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: _selectedSortField == field
                    ? const Color(0xFFF9F5FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedSortField == field
                      ? const Color(0xFF016BE4)
                      : const Color(0xFFEAECF0),
                ),
              ),
              child: _selectedSortField == field
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Color(0xFF016BE4),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              field,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FleetPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const FleetPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: const Color(0x0F101828),
          ),
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 3,
            color: const Color(0x1A101828),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPaginationButton(
            icon: 'assets/icons/arrow-left.svg',
            onPressed:
                currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          const SizedBox(width: 20),
          Text(
            'Page $currentPage of $totalPages',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: const Color(0xFF667085),
            ),
          ),
          const SizedBox(width: 20),
          _buildPaginationButton(
            icon: 'assets/icons/arrow-right.svg',
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required String icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
        ),
        border: Border.all(
          color: const Color(0xFFE4E2E6),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: const Color(0x0D101828),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 11.67,
              height: 11.67,
              colorFilter: ColorFilter.mode(
                onPressed != null
                    ? const Color(0xFF8D8D8D)
                    : const Color(0xFFD0D5DD),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
