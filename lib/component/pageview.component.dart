import 'dart:async';
import 'package:flutter/material.dart';

class PageViewExample extends StatefulWidget {
  final List<String> lstTitulos;
  final List<String> lstImagenes;
  const PageViewExample({super.key, required this.lstTitulos, required this.lstImagenes});

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  late Timer _timer;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: widget.lstTitulos.length, vsync: this);

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextPage = _currentPageIndex + 1;

      if (_currentPageIndex == (widget.lstTitulos.length - 1)) {
        _pageViewController.jumpToPage(0);
        handlePageViewChanged(0);
      } else {
        handlePageViewChanged(nextPage);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      PageView(
        controller: _pageViewController,
        onPageChanged: handlePageViewChanged,
        children: <Widget>[
          ...widget.lstImagenes.map((e) => ImagenesTransaccion(imagen: e)),
        ],
      ),
      Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(widget.lstTitulos[_currentPageIndex],
                style: TextStyle(color: Colors.white, fontSize: 22)),
          )),
      Align(
        alignment: Alignment.bottomCenter,
        child: PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          cantidadImg: widget.lstTitulos.length,
        ),
      ),
    ]);
  }

  void handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
      _updateCurrentPageIndex(_currentPageIndex);
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class ImagenesTransaccion extends StatelessWidget {
  final Color color = const Color.fromARGB(255, 9, 1, 119);
  final String imagen;
  const ImagenesTransaccion({
    super.key,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 9, 1, 119),
        child: Image(image: AssetImage(imagen)));
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.cantidadImg,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final int cantidadImg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TabPageSelector(
            controller: tabController,
            color: Colors.transparent,
            selectedColor: Colors.white,
          )
        ],
      ),
    );
  }
}
