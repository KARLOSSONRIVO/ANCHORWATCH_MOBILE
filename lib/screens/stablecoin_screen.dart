import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Stablecoin screen for cryptocurrency and stablecoin analysis
class StablecoinScreen extends StatefulWidget {
  const StablecoinScreen({super.key});

  @override
  State<StablecoinScreen> createState() => _StablecoinScreenState();
}

class _StablecoinScreenState extends State<StablecoinScreen> {
  bool _isLoading = false;
  String _selectedPeriod = '7D';

  final List<String> _periods = ['24H', '7D', '30D', '1Y'];

  // Sample stablecoin data
  final List<StablecoinData> _stablecoins = [
    StablecoinData(
      name: 'USDT',
      fullName: 'Tether USD',
      price: 1.0001,
      change24h: 0.01,
      marketCap: 83.2e9,
      volume24h: 28.5e9,
      logo: 'assets/images/usdt_logo.png',
    ),
    StablecoinData(
      name: 'USDC',
      fullName: 'USD Coin',
      price: 0.9998,
      change24h: -0.02,
      marketCap: 33.8e9,
      volume24h: 4.2e9,
      logo: 'assets/images/usdc_logo.png',
    ),
    StablecoinData(
      name: 'BUSD',
      fullName: 'Binance USD',
      price: 1.0003,
      change24h: 0.03,
      marketCap: 17.8e9,
      volume24h: 8.1e9,
      logo: 'assets/images/busd_logo.png',
    ),
    StablecoinData(
      name: 'DAI',
      fullName: 'Dai Stablecoin',
      price: 0.9995,
      change24h: -0.05,
      marketCap: 5.3e9,
      volume24h: 124.8e6,
      logo: 'assets/images/dai_logo.png',
    ),
  ];

  final List<MarketMetric> _marketMetrics = [
    MarketMetric(
      title: 'Total Stablecoin Market Cap',
      value: '\$140.1B',
      change: '+2.3%',
      isPositive: true,
    ),
    MarketMetric(
      title: '24h Volume',
      value: '\$41.2B',
      change: '+12.7%',
      isPositive: true,
    ),
    MarketMetric(
      title: 'Market Dominance',
      value: '59.3%',
      change: '-0.8%',
      isPositive: false,
    ),
    MarketMetric(
      title: 'Active Addresses',
      value: '2.1M',
      change: '+5.2%',
      isPositive: true,
    ),
  ];

  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      SnackBarHelper.showSuccess(context, 'Stablecoin data refreshed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8F8F8) // Softer off-white for light mode
          : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF8F8F8) // Softer off-white for light mode
            : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: const Text(
          'Stablecoins',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
            )
          : RefreshIndicator(
              color: const Color(0xFF00D4AA),
              onRefresh: () async => _refreshData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Period selector
                    _buildPeriodSelector(),
                    const SizedBox(height: 16),
                    
                    // Market overview
                    _buildCard(
                      title: 'Market Overview',
                      child: _buildMarketOverview(),
                    ),
                    
                    // Price chart placeholder
                    _buildCard(
                      title: 'Price Stability Index',
                      child: _buildPriceChart(),
                    ),
                    
                    // Stablecoin rankings
                    _buildCard(
                      title: 'Top Stablecoins',
                      child: _buildStablecoinList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: _periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00D4AA)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildMarketOverview() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: _marketMetrics.length,
      itemBuilder: (context, index) {
        final metric = _marketMetrics[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[50]
                : const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.title,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  fontFamily: 'Inter',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    metric.isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 14,
                    color: metric.isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    metric.change,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: metric.isPositive ? Colors.green : Colors.red,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceChart() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: const Color(0xFF00D4AA),
            ),
            const SizedBox(height: 16),
            Text(
              'Price Stability Chart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stability analysis for $_selectedPeriod period',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStablecoinList() {
    return Column(
      children: List.generate(_stablecoins.length, (index) {
        final coin = _stablecoins[index];
        return _buildStablecoinItem(coin, index + 1);
      }),
    );
  }

  Widget _buildStablecoinItem(StablecoinData coin, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[50]
            : const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.monetization_on,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          
          // Coin info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      coin.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: coin.change24h >= 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${coin.change24h >= 0 ? '+' : ''}${coin.change24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: coin.change24h >= 0 ? Colors.green : Colors.red,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  coin.fullName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          
          // Price and stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${coin.price.toStringAsFixed(4)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'MCap: ${_formatNumber(coin.marketCap)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Vol: ${_formatNumber(coin.volume24h)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1e9) {
      return '\$${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '\$${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '\$${(number / 1e3).toStringAsFixed(1)}K';
    } else {
      return '\$${number.toStringAsFixed(0)}';
    }
  }
}

/// Data models
class StablecoinData {
  final String name;
  final String fullName;
  final double price;
  final double change24h;
  final double marketCap;
  final double volume24h;
  final String logo;

  StablecoinData({
    required this.name,
    required this.fullName,
    required this.price,
    required this.change24h,
    required this.marketCap,
    required this.volume24h,
    required this.logo,
  });
}

class MarketMetric {
  final String title;
  final String value;
  final String change;
  final bool isPositive;

  MarketMetric({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
  });
}