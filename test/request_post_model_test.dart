import 'dart:math';

import 'package:faker/faker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/request_post.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;
  late RequestPostModel requestPostModel;

  setUpAll(() {
    int min = faker.randomGenerator.integer(1500);
    int target = faker.randomGenerator.integer(2000, min: min);
    int? max = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(3000, min: target)
        : null;
    Random rand = Random();
    json = {
      "id": faker.randomGenerator.integer(1000),
      "related_to": List.generate(
        rand.nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      "post_content": faker.lorem.sentences(rand.nextInt(20 - 3) + 3).join(' '),
      "created_on": Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
          .format("yyyy-MM-dd'T'HH:mm:ss"),
      "modified_on": Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
          .format("yyyy-MM-dd'T'HH:mm:ss"),
      "is_anonymous": faker.randomGenerator.boolean(),
      "post_type": "Normal",
      "poked_ngo": List.generate(
          faker.randomGenerator.integer(8, min: 0),
          (index) => {
                "id": faker.randomGenerator.integer(1000),
                "full_name": faker.company.name(),
                "display_picture": faker.image.image(random: true),
              }),
      "author": faker.person.name(),
      "author_id": faker.randomGenerator.integer(1000),
      "post_request": {
        "id": faker.randomGenerator.integer(1000),
        "min": min,
        "max": max,
        "target": target,
        "ends_on": Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
            .format("yyyy-MM-dd'T'HH:mm:ss"),
        "request_type": faker.randomGenerator.element(['Join', 'Petition']),
        "reacted_by": faker.randomGenerator
            .numbers(1500, faker.randomGenerator.integer(1500)),
        "is_participated": faker.randomGenerator.boolean()
      }
    };
  });

  test('JSON deserialized to RequestModel Instance', () {
    requestPostModel = RequestPostModel.fromAPIResponse(json);
    expect(requestPostModel, isA<RequestPostModel>());
  });

  test('Normal Post ID casted', () {
    expect(requestPostModel.id, json['id']);
  });

  test('Related-to casted', () {
    expect(requestPostModel.relatedTo, json['related_to']);
  });

  test('Post Content casted', () {
    expect(requestPostModel.postContent, json['post_content']);
  });

  test('Created-on casted', () {
    expect(requestPostModel.createdOn,
        Jiffy(json['created_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Modified-on casted', () {
    expect(requestPostModel.modifiedOn,
        Jiffy(json['modified_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Is-Anonymous casted', () {
    expect(requestPostModel.isAnonymous, json['is_anonymous']);
  });

  test('Post Type casted', () {
    expect(requestPostModel.postType, json['post_type']);
  });

  test('Poked NGO casted', () {
    expect(requestPostModel.pokedNGO,
        (json['poked_ngo'] as List).map((e) => NGO__Model.fromAPIResponse(e)));
  });

  test('Author name casted', () {
    expect(requestPostModel.author, json['author']);
  });

  test('Author ID casted', () {
    expect(requestPostModel.authorID, json['author_id']);
  });
  test('Minimum participation casted', () {
    expect(requestPostModel.min, json['post_request']['min']);
  });
  test('Target participation casted', () {
    expect(requestPostModel.target, json['post_request']['target']);
  });
  test('Maximum participation casted', () {
    expect(requestPostModel.max, json['post_request']['max']);
  });
  test('Request-post ends-on casted', () {
    expect(
        requestPostModel.endsOn,
        Jiffy(json['post_request']['ends_on'], "yyyy-MM-dd'T'HH:mm:ss")
            .dateTime);
  });

  test('Is-Participated casted', () {
    expect(requestPostModel.isParticipated,
        json['post_request']['is_participated']);
  });

  test('Participation casted', () {
    expect(requestPostModel.reaction, json['post_request']['reacted_by']);
  });

  test('Request-type casted', () {
    expect(requestPostModel.requestType, json['post_request']['request_type']);
  });
}
