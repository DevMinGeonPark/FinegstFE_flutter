import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupModal extends StatefulWidget {
  final bool isOpen;
  final Function onClose;
  final List<PopupContent> data;
  // final Function(String) handleUri;

  const PopupModal({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.data,
    // required this.handleUri,
  });

  @override
  State<PopupModal> createState() => _PopupModalState();
}

class _PopupModalState extends State<PopupModal> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        // 불투명한 오버레이 배경
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        // 캐러셀 컨텐츠
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.9,
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: FlutterCarousel(
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                        items: widget.data
                            .expand((item) =>
                                // gongContent의 모든 요소에 대해 이미지 위젯 생성
                                item.gongContent
                                    .map((content) => GestureDetector(
                                          onTap: () {
                                            widget.onClose();
                                            // widget.handleUri(content.linkUrl);
                                          },
                                          child: Image.network(
                                            content.gongImgUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        )))
                            .toList(),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent, // 완전 명 배경
                        borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent, // 완전 투명 배경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('lastPopupDate',
                                    DateTime.now().toIso8601String());
                                widget.onClose();
                              },
                              child: const Text(
                                '오늘 그만 보기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 12,
                            color: Colors.white.withOpacity(0.3), // 구분선 추가
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent, // 완전 투명 배경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () => widget.onClose(),
                              child: const Text(
                                '닫기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
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
        ),
      ],
    );
  }
}

class PopupContent {
  final List<GongContent> gongContent;

  PopupContent({required this.gongContent});
}

class GongContent {
  final String gongImgUrl;
  final String linkUrl;

  GongContent({required this.gongImgUrl, required this.linkUrl});
}
