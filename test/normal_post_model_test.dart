import 'dart:math';

import 'package:faker/faker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/normal_post.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;
  late NormalPostModel normalPost;

  setUpAll(() {
    Random rand = Random();
    bool upvoted = faker.randomGenerator.boolean();
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
      "post_normal": {
        "id": faker.randomGenerator.integer(1000),
        "post_image": faker.randomGenerator.boolean()
            ? faker.image.image(random: true)
            : null,
        "up_vote": faker.randomGenerator
            .numbers(1500, faker.randomGenerator.integer(1500)),
        "down_vote": faker.randomGenerator
            .numbers(1500, faker.randomGenerator.integer(1500)),
        "up_voted": upvoted
      }
    };
  });

  test('JSON deserialized to BankModel Instance', () {
    normalPost = NormalPostModel.fromAPIResponse(json);
    expect(normalPost, isA<NormalPostModel>());
  });

  test('Normal Post ID casted', () {
    expect(normalPost.id, json['id']);
  });

  test('Related-to casted', () {
    expect(normalPost.relatedTo, json['related_to']);
  });

  test('Post Content casted', () {
    expect(normalPost.postContent, json['post_content']);
  });

  test('Created-on casted', () {
    expect(normalPost.createdOn,
        Jiffy(json['created_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Modified-on casted', () {
    expect(normalPost.modifiedOn,
        Jiffy(json['modified_on'], "yyyy-MM-dd'T'HH:mm:ss").dateTime);
  });

  test('Is-Anonymous casted', () {
    expect(normalPost.isAnonymous, json['is_anonymous']);
  });

  test('Post Type casted', () {
    expect(normalPost.postType, json['post_type']);
  });

  test('Poked NGO casted', () {
    expect(normalPost.pokedNGO,
        (json['poked_ngo'] as List).map((e) => NGO__Model.fromAPIResponse(e)));
  });

  test('Author name casted', () {
    expect(normalPost.author, json['author']);
  });

  test('Author ID casted', () {
    expect(normalPost.authorID, json['author_id']);
  });

  test('Post-Image casted', () {
    expect(normalPost.attachedImage, json['post_normal']['post_image']);
  });

  test('Up-vote casted', () {
    expect(normalPost.upVote, json['post_normal']['up_vote']);
  });

  test('Down-vote casted', () {
    expect(normalPost.downVote, json['post_normal']['down_vote']);
  });

  test('Up-voted casted', () {
    expect(normalPost.upVoted, json['post_normal']['up_voted']);
  });
}
