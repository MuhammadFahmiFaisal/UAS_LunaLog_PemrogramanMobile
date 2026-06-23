import '../models/models.dart';

class DummyData {
  static final UserProfile currentUser = UserProfile(
    id: '1',
    name: 'Sarah',
    email: 'sarah@email.com',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuADdK0ni4qpvUQnDaKDFSlxIFIYWnd4aqt_LRUn_VjP1cojZDYm4AA8umYaGHXwMYEQpVsR0ciQ1xVlQHfykft8pDEn49CjIJqrVeY57iMlio8aLiULOBh7zvzEZOyopoBIgkCXX6q9XDSROY6X40ENflS563NiGLvf4PDp5olPtxEA4iA1i8Ku2sr1wkau_jEEsNVj7AHb0HHPwpdDeXoIxqjf6yY1n9GCHBD5V6u8uN3YRbmUqnNbZghlWG1jETGkpq-dAhuMHA',
    lastPeriodDate: DateTime.now().subtract(const Duration(days: 12)),
    periodDuration: 5,
    cycleLength: 28,
    goal: 'Memahami siklus dan kesehatan reproduksi',
  );

  static final List<Period> periods = [
    Period(
      id: 'p1',
      startDate: DateTime.now().subtract(const Duration(days: 12)),
      endDate: DateTime.now().subtract(const Duration(days: 8)),
      durationDays: 5,
    ),
    Period(
      id: 'p2',
      startDate: DateTime.now().subtract(const Duration(days: 40)),
      endDate: DateTime.now().subtract(const Duration(days: 36)),
      durationDays: 5,
    ),
    Period(
      id: 'p3',
      startDate: DateTime.now().subtract(const Duration(days: 68)),
      endDate: DateTime.now().subtract(const Duration(days: 64)),
      durationDays: 5,
    ),
  ];

  static final List<DailyLog> recentLogs = [
    DailyLog(
      id: 'd1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      flow: FlowLevel.light,
      symptoms: ['Kram ringan', 'Pegal'],
      mood: Mood.calm,
      sexualActivity: false,
      notes: 'Hari kedua setelah haid mulai berkurang.',
    ),
    DailyLog(
      id: 'd2',
      date: DateTime.now().subtract(const Duration(days: 2)),
      flow: FlowLevel.medium,
      symptoms: ['Kram', 'Sakit punggung'],
      mood: Mood.tired,
      sexualActivity: false,
      notes: 'Nyeri cukup terasa di pagi hari.',
    ),
    DailyLog(
      id: 'd3',
      date: DateTime.now().subtract(const Duration(days: 3)),
      flow: FlowLevel.heavy,
      symptoms: ['Kram', 'Sakit kepala', 'Mual ringan'],
      mood: Mood.anxious,
      sexualActivity: false,
    ),
  ];

  static final List<Article> articles = [
    Article(
      id: 'a1',
      title: 'Cara Mengurangi Kram Menstruasi',
      category: 'Kesehatan Fisik',
      content:
          'Kram menstruasi, atau dismenore, adalah rasa sakit yang dialami banyak wanita sebelum atau selama masa menstruasi. Hal ini terjadi karena kontraksi pada rahim yang dipicu oleh hormon prostaglandin. Rasa nyeri ini bisa sangat mengganggu aktivitas, namun ada beberapa cara alami yang bisa membantu menenangkan tubuh Anda.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAahMCqsUOYWipIzQZ35uweZT0si_-Qt4snylr9Jbj1laxv7RdgmsMLAW7u13xa2hSYceO2Uq-l-sm58eRMW_36d3jcMfU2TxHaqKrFGQp-0tAAyHuVh7dC7WwvptUiqS1xI1LTB1yhHugpk9U87_-LuvkjLPLWCCpJ259n3btpPgUJhIN0mn19cbZTQsbvGXGOOKZW_AXAJaamE97AmiDP3k6FAmRdCslRo06LMQbaL-vCjo7JrJSW2qYb7nGq4H3hmimUBkbFuw',
      readTimeMinutes: 5,
      tips: [
        TipItem(
          title: 'Kompres Hangat',
          description:
              'Mengaplikasikan bantal pemanas atau botol air hangat ke perut bagian bawah dan punggung bawah dapat membantu merilekskan otot-otot rahim yang berkontraksi.',
          icon: 'thermostat',
        ),
        TipItem(
          title: 'Minum Jahe Hangat',
          description:
              'Jahe memiliki sifat anti-inflamasi alami yang bekerja serupa dengan obat pereda nyeri komersial.',
          icon: 'coffee',
        ),
        TipItem(
          title: 'Posisi Yoga',
          description:
              "Gerakan ringan seperti 'Child's Pose' atau 'Cat-Cow' sangat efektif untuk meregangkan panggul dan melepaskan ketegangan di punggung bawah.",
          icon: 'self_improvement',
        ),
      ],
    ),
    Article(
      id: 'a2',
      title: 'Nutrisi Penting Saat Menstruasi',
      category: 'Nutrisi & Diet',
      content:
          'Nutrisi yang tepat dapat membantu menyeimbangkan hormon secara alami dan mengurangi gejala PMS. Perhatikan asupan makanan selama siklus bulanan Anda.',
      readTimeMinutes: 4,
      tips: [
        TipItem(
          title: 'Makanan Kaya Zat Besi',
          description:
              'Bayam, kacang-kacangan, dan daging merah membantu mengganti darah yang hilang selama menstruasi.',
        ),
        TipItem(
          title: 'Asam Lemak Omega-3',
          description:
              'Ikan salmon, chia seeds, dan walnut membantu mengurangi peradangan dan kram.',
        ),
      ],
    ),
    Article(
      id: 'a3',
      title: 'Tips Tidur Nyenyak Saat Haid',
      category: 'Kesehatan Tidur',
      content:
          'Banyak wanita mengalami kesulitan tidur selama menstruasi. Berikut tips untuk mendapatkan tidur yang berkualitas.',
      readTimeMinutes: 3,
      tips: [
        TipItem(
          title: 'Posisi Tidur',
          description:
              'Tidur miring dengan bantal di antara kaki dapat mengurangi tekanan pada panggul.',
        ),
        TipItem(
          title: 'Suhu Kamar',
          description:
              'Jaga suhu kamar tetap nyaman, tidak terlalu panas atau dingin.',
        ),
      ],
    ),
    Article(
      id: 'a4',
      title: 'Mengelola Stres Selama Siklus',
      category: 'Kesehatan Mental',
      content:
          'Perubahan hormon selama siklus menstruasi dapat mempengaruhi suasana hati. Pelajari cara mengelola stres dengan efektif.',
      readTimeMinutes: 5,
      tips: [
        TipItem(
          title: 'Meditasi',
          description:
              '10 menit meditasi setiap hari dapat membantu menenangkan pikiran.',
        ),
        TipItem(
          title: 'Journaling',
          description:
              'Menulis jurnal membantu mengidentifikasi pola emosi selama siklus.',
        ),
      ],
    ),
    Article(
      id: 'a5',
      title: 'Mengenal Siklus Ovulasi Anda',
      category: 'Kesehatan Reproduksi',
      content:
          'Ovulasi adalah proses ketika ovarium melepaskan sel telur yang matang. Memahami kapan Anda berovulasi sangat penting baik untuk mencegah maupun merencanakan kehamilan. Biasanya ovulasi terjadi sekitar hari ke-14 pada siklus 28 hari, namun setiap wanita berbeda.',
      readTimeMinutes: 4,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA0lB0bA8HhKx9z-Xv7uJ4-5D2p5N7G3t6A5H1b6jB8D3H5E4D1t8K6H5D3A9H7D6b0u1A6H2n6H6D3E5D0u1A6H5B6B8t3u1A6H5B6B8t3u1',
      tips: [
        TipItem(
          title: 'Perhatikan Suhu Basal Tubuh',
          description:
              'Suhu tubuh Anda akan sedikit meningkat tepat setelah ovulasi terjadi.',
        ),
        TipItem(
          title: 'Perubahan Lendir Serviks',
          description:
              'Menjelang ovulasi, lendir serviks menjadi lebih bening dan licin seperti putih telur mentah.',
        ),
      ],
    ),
    Article(
      id: 'a6',
      title: 'Olahraga yang Tepat Saat Menstruasi',
      category: 'Kesehatan Fisik',
      content:
          'Berolahraga saat menstruasi mungkin terasa berat, namun aktivitas fisik ringan justru dapat melancarkan aliran darah dan melepaskan endorfin yang bertindak sebagai pereda nyeri alami.',
      readTimeMinutes: 3,
      tips: [
        TipItem(
          title: 'Jalan Santai',
          description:
              'Jalan kaki selama 30 menit dapat membantu mengurangi kram perut bagian bawah.',
        ),
        TipItem(
          title: 'Hindari Latihan Beban Berat',
          description:
              'Pada hari 1-3 menstruasi, hindari angkat beban yang terlalu berat agar panggul tidak tertekan berlebihan.',
        ),
      ],
    ),
  ];

  static Map<String, bool> get periodDayMap {
    final map = <String, bool>{};
    for (final period in periods) {
      if (period.endDate == null) continue;
      DateTime day = period.startDate;
      while (!day.isAfter(period.endDate!)) {
        map['${day.year}-${day.month}-${day.day}'] = true;
        day = day.add(const Duration(days: 1));
      }
    }
    return map;
  }

  static List<String> get availableSymptoms => [
        'Kram',
        'Sakit punggung',
        'Sakit kepala',
        'Mual ringan',
        'Pegal',
        'Kembung',
        'Kelelahan',
        'Perubahan mood',
        'Nafsu makan meningkat',
        'Insomnia',
        'Puting sensitif',
        'Diare',
      ];
}
