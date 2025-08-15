import 'package:booking_restaurant_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pagesData = [
    {
      "image": "assets/svgs/onBoarding1.svg",
      "title": "Nearby restaurants",
      "text":
          "You don't have to go far to find a good restaurant, we have provided all the restaurants that are near you",
    },
    {
      "image": "assets/svgs/onBoarding2.svg",
      "title": "Select the Favorites Menu",
      "text":
          "Now eat well, don't leave the house. You can choose your favorite food only with one click",
    },
    {
      "image": "assets/svgs/onBoarding3.svg",
      "title": "Good food at a cheap price",
      "text": "You can eat at expensive restaurants with affordable price",
    },
  ];

  void _nextPage() {
    if (_currentIndex < _pagesData.length - 1) {
      _pageController.jumpToPage(_currentIndex + 1);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _pagesData.length,
                itemBuilder: (context, index) {
                  return _OnBoardingPage(
                    image: _pagesData[index]["image"]!,
                    title: _pagesData[index]["title"]!,
                    text: _pagesData[index]["text"]!,
                  );
                },
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child:  Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _pagesData.length,
                      (index) => Container(
                        margin:  EdgeInsets.symmetric(horizontal: 5),
                        width: _currentIndex == index ? 12 : 8,
                        height: _currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.green
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextPage,
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _OnBoardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String text;

  const _OnBoardingPage({
    required this.image,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SvgPicture.asset(image)),
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
