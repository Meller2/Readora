import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const ReadoraApp());
}

class ReadoraApp extends StatelessWidget {
  const ReadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readora',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F4EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E7CE2),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeShell(),
    );
  }
}

class Book {
  const Book({
    required this.title,
    required this.author,
    required this.progress,
    required this.minutesLeft,
    required this.palette,
    required this.symbol,
  });

  final String title;
  final String author;
  final double progress;
  final int minutesLeft;
  final List<Color> palette;
  final IconData symbol;
}

const books = [
  Book(
    title: 'Quiet Stars',
    author: 'Mira Vale',
    progress: .64,
    minutesLeft: 42,
    palette: [Color(0xFF191A2E), Color(0xFF6C8FF5), Color(0xFFF5C7A9)],
    symbol: Icons.auto_stories_rounded,
  ),
  Book(
    title: 'The Glass Orchard',
    author: 'N. Arlen',
    progress: .28,
    minutesLeft: 128,
    palette: [Color(0xFF12332F), Color(0xFF7BC7A4), Color(0xFFFFE2A8)],
    symbol: Icons.local_florist_rounded,
  ),
  Book(
    title: 'Soft Machines',
    author: 'Ada Soren',
    progress: .82,
    minutesLeft: 18,
    palette: [Color(0xFF2B2044), Color(0xFFD89DFF), Color(0xFF78D5F6)],
    symbol: Icons.memory_rounded,
  ),
];

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  Book? _reading;

  @override
  Widget build(BuildContext context) {
    final pages = [
      LibraryScreen(onOpenBook: (book) => setState(() => _reading = book)),
      const ExploreScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _reading == null
                ? KeyedSubtree(key: ValueKey(_tab), child: pages[_tab])
                : ReaderScreen(
                    key: ValueKey(_reading!.title),
                    book: _reading!,
                    onClose: () => setState(() => _reading = null),
                  ),
          ),
          if (_reading == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                child: LiquidBottomBar(
                  selectedIndex: _tab,
                  onTap: (index) => setState(() => _tab = index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key, required this.onOpenBook});

  final ValueChanged<Book> onOpenBook;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFCF7), Color(0xFFE9EEF8), Color(0xFFF7F1E8)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 120),
          physics: const BouncingScrollPhysics(),
          children: [
            const Header(),
            const SizedBox(height: 28),
            ContinueCard(book: books.first, onTap: () => onOpenBook(books.first)),
            const SizedBox(height: 28),
            const SectionTitle(title: 'Library', trailing: '12 books'),
            const SizedBox(height: 14),
            for (final book in books.skip(1)) ...[
              BookTile(book: book, onTap: () => onOpenBook(book)),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Readora',
                style: TextStyle(
                  fontSize: 34,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Evening shelf',
                style: TextStyle(color: Color(0xFF73706A), fontSize: 15),
              ),
            ],
          ),
        ),
        GlassButton(icon: Icons.search_rounded, onTap: () {}),
      ],
    );
  }
}

class ContinueCard extends StatelessWidget {
  const ContinueCard({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 244,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: book.palette.first.withOpacity(.24),
              blurRadius: 36,
              offset: const Offset(0, 22),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Stack(
            children: [
              Positioned.fill(child: BookCover(book: book)),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(.52)],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GlassPill(text: 'Continue reading'),
                    const Spacer(),
                    Text(
                      book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${book.author}  |  ${book.minutesLeft} min left',
                      style: TextStyle(color: Colors.white.withOpacity(.78), fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    ProgressLine(value: book.progress, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  const BookTile({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 132,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.62),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(.72)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 86, child: ClipRRect(borderRadius: BorderRadius.circular(22), child: BookCover(book: book))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(book.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(book.author, style: const TextStyle(color: Color(0xFF77736D))),
                  const SizedBox(height: 18),
                  ProgressLine(value: book.progress, color: book.palette[1]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9A968F)),
          ],
        ),
      ),
    );
  }
}

class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key, required this.book, required this.onClose});

  final Book book;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFFFBF6EC)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
          child: Column(
            children: [
              Row(
                children: [
                  GlassButton(icon: Icons.keyboard_arrow_down_rounded, onTap: onClose),
                  const Spacer(),
                  GlassButton(icon: Icons.tune_rounded, onTap: () {}),
                ],
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFEFA),
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.07),
                        blurRadius: 38,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 22),
                      const Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Text(
                            'The room held its breath in a pale wash of morning light. Every page on the table seemed to remember a different weather, and every margin carried the quiet pressure of a thought not yet spoken.\n\nShe read slowly, not because the words were difficult, but because they made the day feel wider. Outside, the city softened into glass and gold, and the small rituals of attention became a kind of music.',
                            style: TextStyle(
                              fontSize: 21,
                              height: 1.62,
                              color: Color(0xFF28231E),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ProgressLine(value: book.progress, color: const Color(0xFF28231E)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Discover',
      subtitle: 'Curated shelves and calm recommendations.',
      icon: Icons.explore_rounded,
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Profile',
      subtitle: 'Reading rhythm, goals, and saved quotes.',
      icon: Icons.person_rounded,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFFFCF7), Color(0xFFEAF2EF)]),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: const Color(0xFF2B2B2D).withOpacity(.7)),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Color(0xFF77736D))),
          ],
        ),
      ),
    );
  }
}

class LiquidBottomBar extends StatelessWidget {
  const LiquidBottomBar({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      Icons.auto_stories_rounded,
      Icons.explore_rounded,
      Icons.person_rounded,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          height: 72,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.42),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(.7)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selectedIndex == i ? Colors.white.withOpacity(.72) : Colors.transparent,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Center(
                        child: Icon(
                          items[i],
                          color: selectedIndex == i ? const Color(0xFF1F2024) : const Color(0xFF77736D),
                        ),
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
}

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: book.palette,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -28,
            child: CircleAvatar(radius: 76, backgroundColor: Colors.white.withOpacity(.14)),
          ),
          Positioned(
            left: -22,
            bottom: -28,
            child: CircleAvatar(radius: 58, backgroundColor: Colors.white.withOpacity(.12)),
          ),
          Center(
            child: Icon(book.symbol, color: Colors.white.withOpacity(.86), size: 48),
          ),
        ],
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  const GlassButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.48),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.72)),
            ),
            child: Icon(icon, color: const Color(0xFF25262A)),
          ),
        ),
      ),
    );
  }
}

class GlassPill extends StatelessWidget {
  const GlassPill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(.32)),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({super.key, required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        color: color,
        backgroundColor: color.withOpacity(.18),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(trailing, style: const TextStyle(color: Color(0xFF77736D), fontSize: 14)),
      ],
    );
  }
}
