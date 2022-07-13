import 'dart:math';

import 'package:faker/faker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_option.dart';
import 'package:sasae_flutter_app/models/post/poll/poll_post.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;
  late PollPostModel pollPost;

  setUpAll(() {
    var pollOptions = List.generate(
        faker.randomGenerator.integer(10, min: 2),
        (index) => {
              "id": faker.randomGenerator.integer(1000),
              "option": faker.lorem.word(),
              "reacted_by": faker.randomGenerator
                  .numbers(1500, faker.randomGenerator.integer(1500)),
            });
    int? a = faker.randomGenerator.element(pollOptions)['id'] as int?;

    int? choice = faker.randomGenerator.boolean() ? null : a;
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
      "post_poll": {
        "id": faker.randomGenerator.integer(1000),
        "ends_on": Jiffy(faker.date.dateTime(maxYear: 2010, minYear: 1900))
            .format("yyyy-MM-dd'T'HH:mm:ss"),
        "choice": choice,
        "options": pollOptions,
      }
    };
  });

  test('JSON deserialized to BankModel Instance', () {
    pollPost = PollPostModel.fromAPIResponse(json);
    expect(pollPost, isA<PollPostModel>());
  });

  test('Normal Post ID casted', () {
    expect(pollPost.id, json['id']);
  });

  test('Related-to casted', () {
    expect(pollPost.relatedTo, json['related_to']);
  });

  test('Post Content casted', () {
    expect(pollPost.postContent, json['post_content']);
  });

  test('Created-on casted', () {
    expect(pollPost.createdOn,
        Jiffy(json['created_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Modified-on casted', () {
    expect(pollPost.modifiedOn,
        Jiffy(json['modified_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Is-Anonymous casted', () {
    expect(pollPost.isAnonymous, json['is_anonymous']);
  });

  test('Post Type casted', () {
    expect(pollPost.postType, json['post_type']);
  });

  test('Poked NGO casted', () {
    expect(pollPost.pokedNGO,
        (json['poked_ngo'] as List).map((e) => NGO__Model.fromAPIResponse(e)));
  });

  test('Author name casted', () {
    expect(pollPost.author, json['author']);
  });

  test('Author ID casted', () {
    expect(pollPost.authorID, json['author_id']);
  });

  test('Poll-post ends-on casted', () {
    expect(pollPost.endsOn,
        Jiffy(json['post_poll']['ends_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Up-vote casted', () {
    expect(
        pollPost.polls,
        (json['post_poll']['options'] as List)
            .map((e) => PollOptionModel.fromAPIResponse(e)));
  });

  test('Down-vote casted', () {
    expect(pollPost.choice, json['post_poll']['choice']);
  });
}
