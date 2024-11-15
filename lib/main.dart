import 'package:contentful_flutter/contentful_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/example_data_model.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contentful Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Contentful Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final repository = ContentfulDeliveryAPIRepository(
      client: ContentfulClient(
        spaceId: dotenv.get('SPACE_ID'),
        accessToken: dotenv.get('ACCESS_TOKEN'),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: repository.getEntries<Entry<ExampleDataModel>>(
            fromJsonT: (json) => Entry.fromJson(
              json as Map<String, dynamic>,
              (json) => ExampleDataModel.fromJson(json as Map<String, dynamic>),
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              final textStyle =
                  Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
              final data = snapshot.data
                  as ContentfulDeliveryDataModel<Entry<ExampleDataModel>>;
              final bodyContents = data.items.first.fields.body.contentList;

              if (bodyContents?.isEmpty ?? true) return const SizedBox.shrink();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bodyContents!.map(
                    (content) {
                      final contentData = repository.getDataFrom(
                        content: content,
                        includes: data.includes,
                      );
                      if (contentData == null) return const SizedBox.shrink();
                      return Column(
                        children: [
                          ContentfulFlutterBuilder(
                            data: contentData,
                            includes: data.includes,
                            textBuilder: (
                              content,
                              style,
                              ignorePadding,
                              padding,
                            ) {
                              return Text(
                                content.value ?? '',
                                style: style,
                                softWrap: false,
                                overflow: TextOverflow.visible,
                              );
                            },
                            blockQuoteBuilder: (child) {
                              return Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: 3,
                                      height: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: child,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              );
                            },
                            linkWidgetBuilder: (uri, child) => InkWell(
                              onTap: () => _launchUrl(Uri.parse(uri ?? '')),
                              child: child,
                            ),
                            imageBuilder: (imageUrl) => imageUrl.endsWith('svg')
                                ? SvgPicture.network(imageUrl)
                                : Image.network(imageUrl),
                            dividerBuilder: () => const Divider(),
                            listIdentationPadding:
                                const EdgeInsets.only(left: 16),
                            textStyle: textStyle,
                            headingOneStyle: textStyle.copyWith(fontSize: 32),
                            headingTwoStyle: textStyle.copyWith(fontSize: 24),
                            headingThreeStyle: textStyle.copyWith(fontSize: 18),
                            headingFourStyle: textStyle.copyWith(fontSize: 16),
                            headingFiveStyle: textStyle.copyWith(fontSize: 14),
                            headingSixStyle: textStyle.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 8)
                        ],
                      );
                    },
                  ).toList(),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
