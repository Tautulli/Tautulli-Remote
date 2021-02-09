import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMetadataItemModel = MetadataItemModel(
    art: '/library/metadata/53052/art/1599764717',
    audioChannels: 6,
    actors: [
      'Mark Hamill',
      'Harrison Ford',
      'Carrie Fisher',
      'Billy Dee Williams',
      'Anthony Daniels',
      'David Prowse',
      'Kenny Baker',
      'Peter Mayhew',
      'Frank Oz',
      'James Earl Jones',
      'Kathryn Mullen',
      'Wendy Froud',
      'Jeremy Bulloch',
      'Jason Wingreen',
      'Temuera Morrison',
      'Clive Revill',
      'Marjorie Eaton',
      'Ian McDiarmid',
      'Alec Guinness',
      'John Hollis',
      'Jack Purvis',
      'Des Webb',
      'Julian Glover',
      'Kenneth Colley',
      'John Ratzenberger',
      'Michael Sheard',
      'Michael Culver',
      'John Dicks',
      'Milton Johns',
      'Mark Jones',
      'Oliver Maguire',
      'Robin Scobey',
      'Bruce Boa',
      'Christopher Malcolm',
      'Denis Lawson',
      'Ian Liston',
      'John Morton',
      'Richard Oldfield',
      'Jack McKenzie',
      'Jerry Harte',
      'Norman Chancer',
      'Norwich Duff',
      'Ray Hassett',
      'Brigitte Kahn',
      'Burnell Tucker',
      'Bob Anderson',
      'Lightning Bear',
      'Richard Bonehill',
      'John Cannon',
      'Mark Capri',
      'Martin Dew',
      'Peter Diamond',
      'Stuart Fell',
      'Doug Robinson',
      'Tony Smart',
      'Alan Harris',
      'Tiffany L. Kurtz',
      'Mac McDonald',
      'Ralph McQuarrie',
      'Ralph Morse',
      'Terry Richards',
      'Michael Santiago',
      'Treat Williams',
      'Shaun Curry',
      'Alan Austen',
      'Jim Dowdall',
      'Ian Durrant',
      'Tom Egeland',
      'Alan Flyng',
      'Chris Parsons',
      'Trevor Butterfield',
      'Christopher Bunn',
      'Quentin Pierre',
      'Keith Swaden',
      'Howie Weed',
      'Morris Bush'
    ],
    audioCodec: 'ac3',
    contentRating: 'PG',
    directors: ['Irvin Kershner'],
    duration: 7641536,
    genres: ['Sci-Fi', 'Adventure', 'Action', 'Fantasy'],
    grandparentRatingKey: null,
    grandparentTitle: '',
    grandparentThumb: null,
    mediaType: 'movie',
    parentRatingKey: null,
    parentTitle: '',
    parentThumb: null,
    rating: 8.8,
    ratingImage: 'imdb://image.rating',
    ratingKey: 53052,
    studio: 'Lucasfilm',
    summary:
        'The epic saga continues as Luke Skywalker, in hopes of defeating the evil Galactic Empire, learns the ways of the Jedi from aging master Yoda. But Darth Vader is more determined than ever to capture Luke. Meanwhile, rebel leader Princess Leia, cocky Han Solo, Chewbacca, and droids C-3PO and R2-D2 are thrown into various stages of capture, betrayal and despair.',
    tagline: 'The Adventure Continues...',
    title: 'The Empire Strikes Back',
    thumb: '/library/metadata/53052/thumb/1599764717',
    videoCodec: 'h264',
    videoFullResolution: '1080p',
    writers: ['Leigh Brackett', 'Lawrence Kasdan'],
    year: 1980,
  );

  test('should be a subclass of MetadataItem entity', () async {
    //assert
    expect(tMetadataItemModel, isA<MetadataItem>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('metadata_item.json'));
        // act
        final result = MetadataItemModel.fromJson(jsonMap['response']['data']);
        // assert
        expect(result, equals(tMetadataItemModel));
      },
    );

    test(
      'should return a MetadataItem with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('metadata_item.json'));
        // act
        final result = MetadataItemModel.fromJson(jsonMap['response']['data']);
        // assert
        expect(result.ratingKey,
            equals(int.tryParse(jsonMap['response']['data']['rating_key'])));
      },
    );
  });
}
