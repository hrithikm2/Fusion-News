import '../models/news_article_model.dart';

/// Demo data source for news articles
///
/// This provides mock data for demonstration purposes
/// when API keys are not available.
class NewsDemoDataSource {
  static List<NewsArticleModel> getDemoArticles() {
    return [
      NewsArticleModel(
        id: '1',
        title: 'Breaking: Major Technology Breakthrough Announced',
        description:
            'Scientists have made a significant breakthrough in quantum computing that could revolutionize the industry.',
        content:
            'In a groundbreaking announcement today, researchers at leading tech companies revealed a major advancement in quantum computing technology. This breakthrough could potentially solve complex problems that would take traditional computers thousands of years to process.',
        author: 'Sarah Johnson',
        source: 'Tech News',
        url: 'https://example.com/news/1',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        categories: ['Technology', 'Science'],
        readTime: 5,
        likes: 42,
        shares: 8,
      ),
      NewsArticleModel(
        id: '2',
        title: 'Global Climate Summit Reaches Historic Agreement',
        description:
            'World leaders have reached a consensus on new climate policies that aim to reduce carbon emissions by 50% by 2030.',
        content:
            'The international climate summit concluded today with a historic agreement that sets ambitious targets for carbon reduction. The agreement includes new policies for renewable energy adoption and carbon trading mechanisms.',
        author: 'Michael Chen',
        source: 'Global News',
        url: 'https://example.com/news/2',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        categories: ['Environment', 'Politics'],
        readTime: 7,
        likes: 156,
        shares: 23,
      ),
      NewsArticleModel(
        id: '3',
        title: 'SpaceX Successfully Launches New Satellite Constellation',
        description:
            'Elon Musk\'s SpaceX has successfully deployed another batch of satellites for its global internet coverage project.',
        content:
            'SpaceX continues to expand its Starlink satellite constellation with another successful launch. The new satellites will provide high-speed internet access to remote areas around the world.',
        author: 'Alex Rodriguez',
        source: 'Space News',
        url: 'https://example.com/news/3',
        imageUrl: 'https://picsum.photos/400/300?random=3',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        categories: ['Space', 'Technology'],
        readTime: 4,
        likes: 89,
        shares: 15,
      ),
      NewsArticleModel(
        id: '4',
        title: 'New Medical Treatment Shows Promise for Cancer Patients',
        description:
            'Clinical trials reveal that a new immunotherapy treatment has shown remarkable results in treating previously untreatable cancers.',
        content:
            'Researchers have announced promising results from clinical trials of a new immunotherapy treatment. The treatment has shown significant success in patients with advanced cancer stages.',
        author: 'Dr. Emily Watson',
        source: 'Medical News',
        url: 'https://example.com/news/4',
        imageUrl: 'https://picsum.photos/400/300?random=4',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        categories: ['Health', 'Science'],
        readTime: 6,
        likes: 234,
        shares: 45,
      ),
      NewsArticleModel(
        id: '5',
        title: 'Economic Growth Surges in Emerging Markets',
        description:
            'Several emerging economies are showing strong growth indicators, with GDP increases exceeding expectations.',
        content:
            'Economic analysts report that emerging markets are experiencing robust growth, driven by increased foreign investment and domestic consumption. The trend is expected to continue throughout the year.',
        author: 'James Wilson',
        source: 'Financial Times',
        url: 'https://example.com/news/5',
        imageUrl: 'https://picsum.photos/400/300?random=5',
        publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        categories: ['Economy', 'Business'],
        readTime: 5,
        likes: 67,
        shares: 12,
      ),
      NewsArticleModel(
        id: '6',
        title: 'Renewable Energy Reaches New Milestone',
        description:
            'Solar and wind power now account for over 30% of global electricity generation, marking a significant milestone in the energy transition.',
        content:
            'The renewable energy sector has reached a historic milestone, with solar and wind power now providing more than 30% of global electricity. This represents a major step forward in the transition to clean energy.',
        author: 'Lisa Thompson',
        source: 'Energy Weekly',
        url: 'https://example.com/news/6',
        imageUrl: 'https://picsum.photos/400/300?random=6',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        categories: ['Energy', 'Environment'],
        readTime: 4,
        likes: 123,
        shares: 28,
      ),
      NewsArticleModel(
        id: '7',
        title: 'AI-Powered Healthcare System Launched',
        description:
            'A new artificial intelligence system has been deployed in hospitals to assist doctors with diagnosis and treatment planning.',
        content:
            'Hospitals across the country are implementing a new AI-powered healthcare system that can analyze medical images and patient data to assist healthcare professionals in making more accurate diagnoses.',
        author: 'Dr. Robert Kim',
        source: 'Healthcare Today',
        url: 'https://example.com/news/7',
        imageUrl: 'https://picsum.photos/400/300?random=7',
        publishedAt: DateTime.now().subtract(const Duration(hours: 14)),
        categories: ['Health', 'Technology'],
        readTime: 6,
        likes: 178,
        shares: 34,
      ),
      NewsArticleModel(
        id: '8',
        title: 'International Trade Agreement Signed',
        description:
            'Major trading partners have signed a comprehensive agreement that will reduce tariffs and increase economic cooperation.',
        content:
            'Representatives from multiple countries have signed a landmark trade agreement that will reduce barriers to international commerce and promote economic growth across participating nations.',
        author: 'Maria Garcia',
        source: 'World Trade News',
        url: 'https://example.com/news/8',
        imageUrl: 'https://picsum.photos/400/300?random=8',
        publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
        categories: ['Economy', 'Politics'],
        readTime: 5,
        likes: 95,
        shares: 19,
      ),
    ];
  }
}
