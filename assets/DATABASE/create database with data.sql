-- Tabloları oluşturma
CREATE TABLE
    "content_type_enum" ("id" integer PRIMARY KEY, "name" varchar);

CREATE TABLE
    "content_status_enum" ("id" integer PRIMARY KEY, "name" varchar);

CREATE TABLE
    "app_user" (
        "id" integer PRIMARY KEY,
        "username" varchar UNIQUE,
        "email" varchar UNIQUE,
        "password_hash" varchar,
        "bio" text,
        "personality_analyze" text,
        "created_at" timestamp
    );

CREATE TABLE
    "user_follow" (
        "id" integer PRIMARY KEY,
        "follower_id" integer,
        "following_id" integer,
        "created_at" timestamp
    );

CREATE TABLE
    "content" (
        "id" integer PRIMARY KEY,
        "title" varchar,
        "content_type_id" integer,
        "release_date" timestamp,
        "description" text,
        "length" integer,
        "consume_count" integer,
        "favori_count" integer,
        "list_count" integer,
        "review_count" integer,
        "rating_distribution" json,
        "created_at" timestamp
    );

CREATE TABLE
    "theme" ("id" integer PRIMARY KEY, "name" varchar);

CREATE TABLE
    "language" ("id" integer PRIMARY KEY, "name" varchar);

CREATE TABLE
    "country" ("id" integer PRIMARY KEY, "name" varchar);

CREATE TABLE
    "content_theme" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "theme_id" integer
    );

CREATE TABLE
    "content_language" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "language_id" integer
    );

CREATE TABLE
    "content_country" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "country_id" integer
    );

CREATE TABLE
    "user_content_log" (
        "id" integer PRIMARY KEY,
        "user_id" integer,
        "content_id" integer,
        "content_status_id" integer,
        "date" timestamp,
        "rating" decimal,
        "is_favorite" boolean DEFAULT false,
        "is_consume_later" boolean DEFAULT false,
        "review" text
    );

CREATE TABLE
    "review" (
        "id" integer PRIMARY KEY,
        "user_id" integer,
        "content_id" integer,
        "text" text,
        "rating" decimal,
        "like_count" integer DEFAULT 0,
        "comment_count" integer DEFAULT 0,
        "created_at" timestamp,
        "updated_at" timestamp
    );

CREATE TABLE
    "review_like" (
        "id" integer PRIMARY KEY,
        "user_id" integer,
        "review_id" integer,
        "created_at" timestamp
    );

CREATE TABLE
    "review_comment" (
        "id" integer PRIMARY KEY,
        "review_id" integer,
        "user_id" integer,
        "text" text,
        "created_at" timestamp
    );

CREATE TABLE
    "user_list" (
        "id" integer PRIMARY KEY,
        "user_id" integer,
        "title" varchar,
        "description" text,
        "is_public" boolean DEFAULT true,
        "created_at" timestamp,
        "updated_at" timestamp
    );

CREATE TABLE
    "list_content" (
        "id" integer PRIMARY KEY,
        "list_id" integer,
        "content_id" integer,
        "added_at" timestamp
    );

CREATE TABLE
    "creator" (
        "id" integer PRIMARY KEY,
        "name" varchar,
        "profile_path" varchar
    );

CREATE TABLE
    "content_creator" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "creator_id" integer,
        "role_type" varchar
    );

CREATE TABLE
    "genre" ("id" integer PRIMARY KEY, "name" varchar);

CREATE TABLE
    "content_genre" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "genre_id" integer
    );

CREATE TABLE
    "platform" (
        "id" integer PRIMARY KEY,
        "name" varchar,
        "logo_path" varchar
    );

CREATE TABLE
    "content_platform" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "platform_id" integer
    );

CREATE TABLE
    "app_cast_aaaa" (
        "id" integer PRIMARY KEY,
        "name" varchar,
        "profile_path" varchar
    );

CREATE TABLE
    "content_cast" (
        "id" integer PRIMARY KEY,
        "content_id" integer,
        "cast_id" integer,
        "character_name" varchar
    );

-- İndeksler
CREATE UNIQUE INDEX ON "user_follow" ("follower_id", "following_id");

CREATE UNIQUE INDEX ON "content_theme" ("content_id", "theme_id");

CREATE UNIQUE INDEX ON "content_language" ("content_id", "language_id");

CREATE UNIQUE INDEX ON "content_country" ("content_id", "country_id");

CREATE UNIQUE INDEX ON "user_content_log" ("user_id", "content_id");

CREATE UNIQUE INDEX ON "review_like" ("user_id", "review_id");

CREATE UNIQUE INDEX ON "list_content" ("list_id", "content_id");

CREATE UNIQUE INDEX ON "content_creator" ("content_id", "creator_id");

CREATE UNIQUE INDEX ON "content_genre" ("content_id", "genre_id");

CREATE UNIQUE INDEX ON "content_platform" ("content_id", "platform_id");

CREATE UNIQUE INDEX ON "content_cast" ("content_id", "cast_id");

-- Foreign Key'ler
ALTER TABLE "user_follow" ADD FOREIGN KEY ("follower_id") REFERENCES "app_user" ("id");

ALTER TABLE "user_follow" ADD FOREIGN KEY ("following_id") REFERENCES "app_user" ("id");

ALTER TABLE "content" ADD FOREIGN KEY ("content_type_id") REFERENCES "content_type_enum" ("id");

ALTER TABLE "content_theme" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_theme" ADD FOREIGN KEY ("theme_id") REFERENCES "theme" ("id");

ALTER TABLE "content_language" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_language" ADD FOREIGN KEY ("language_id") REFERENCES "language" ("id");

ALTER TABLE "content_country" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_country" ADD FOREIGN KEY ("country_id") REFERENCES "country" ("id");

ALTER TABLE "user_content_log" ADD FOREIGN KEY ("user_id") REFERENCES "app_user" ("id");

ALTER TABLE "user_content_log" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "user_content_log" ADD FOREIGN KEY ("content_status_id") REFERENCES "content_status_enum" ("id");

ALTER TABLE "review" ADD FOREIGN KEY ("user_id") REFERENCES "app_user" ("id");

ALTER TABLE "review" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "review_like" ADD FOREIGN KEY ("user_id") REFERENCES "app_user" ("id");

ALTER TABLE "review_like" ADD FOREIGN KEY ("review_id") REFERENCES "review" ("id");

ALTER TABLE "review_comment" ADD FOREIGN KEY ("review_id") REFERENCES "review" ("id");

ALTER TABLE "review_comment" ADD FOREIGN KEY ("user_id") REFERENCES "app_user" ("id");

ALTER TABLE "user_list" ADD FOREIGN KEY ("user_id") REFERENCES "app_user" ("id");

ALTER TABLE "list_content" ADD FOREIGN KEY ("list_id") REFERENCES "user_list" ("id");

ALTER TABLE "list_content" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_creator" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_creator" ADD FOREIGN KEY ("creator_id") REFERENCES "creator" ("id");

ALTER TABLE "content_genre" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_genre" ADD FOREIGN KEY ("genre_id") REFERENCES "genre" ("id");

ALTER TABLE "content_platform" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_platform" ADD FOREIGN KEY ("platform_id") REFERENCES "platform" ("id");

ALTER TABLE "content_cast" ADD FOREIGN KEY ("content_id") REFERENCES "content" ("id");

ALTER TABLE "content_cast" ADD FOREIGN KEY ("cast_id") REFERENCES "app_cast_aaaa" ("id");

-- Örnek Veri Ekleme
-- content_type_enum Tablosu
INSERT INTO
    content_type_enum (id, name)
VALUES
    (1, 'Movie'),
    (2, 'TV Show'),
    (3, 'Book'),
    (4, 'Game');

-- content_status_enum Tablosu
INSERT INTO
    content_status_enum (id, name)
VALUES
    (1, 'Released'),
    (2, 'Upcoming'),
    (3, 'In Production'),
    (4, 'Cancelled');

-- app_user Tablosu
INSERT INTO
    app_user (
        id,
        username,
        email,
        password_hash,
        bio,
        personality_analyze,
        created_at
    )
VALUES
    (
        1,
        'user1',
        'user1@example.com',
        'hashed_password1',
        'Bio of user1',
        'Analyze of user1',
        '2023-01-01 10:00:00'
    ),
    (
        2,
        'user2',
        'user2@example.com',
        'hashed_password2',
        'Bio of user2',
        'Analyze of user2',
        '2023-01-02 10:00:00'
    ),
    (
        3,
        'user3',
        'user3@example.com',
        'hashed_password3',
        'Bio of user3',
        'Analyze of user3',
        '2023-01-03 10:00:00'
    ),
    (
        4,
        'user4',
        'user4@example.com',
        'hashed_password4',
        'Bio of user4',
        'Analyze of user4',
        '2023-01-04 10:00:00'
    ),
    (
        5,
        'user5',
        'user5@example.com',
        'hashed_password5',
        'Bio of user5',
        'Analyze of user5',
        '2023-01-05 10:00:00'
    );

-- user_follow Tablosu
INSERT INTO
    user_follow (id, follower_id, following_id, created_at)
VALUES
    (1, 1, 2, '2023-01-03 10:00:00'),
    (2, 2, 3, '2023-01-04 10:00:00'),
    (3, 3, 4, '2023-01-05 10:00:00'),
    (4, 4, 5, '2023-01-06 10:00:00'),
    (5, 5, 1, '2023-01-07 10:00:00');

-- content Tablosu
INSERT INTO
    content (
        id,
        title,
        content_type_id,
        release_date,
        description,
        length,
        consume_count,
        favori_count,
        list_count,
        review_count,
        rating_distribution,
        created_at
    )
VALUES
    (
        1,
        'Movie Title 1',
        1,
        '2023-01-01 10:00:00',
        'Description of Movie 1',
        120,
        100,
        50,
        30,
        20,
        '{"1": 10, "2": 20, "3": 30, "4": 40, "5": 50}',
        '2023-01-01 10:00:00'
    ),
    (
        2,
        'TV Show Title 1',
        2,
        '2023-01-02 10:00:00',
        'Description of TV Show 1',
        300,
        200,
        100,
        50,
        40,
        '{"1": 20, "2": 30, "3": 40, "4": 50, "5": 60}',
        '2023-01-02 10:00:00'
    ),
    (
        3,
        'Book Title 1',
        3,
        '2023-01-03 10:00:00',
        'Description of Book 1',
        300,
        150,
        75,
        40,
        30,
        '{"1": 15, "2": 25, "3": 35, "4": 45, "5": 55}',
        '2023-01-03 10:00:00'
    ),
    (
        4,
        'Game Title 1',
        4,
        '2023-01-04 10:00:00',
        'Description of Game 1',
        200,
        100,
        50,
        25,
        20,
        '{"1": 10, "2": 20, "3": 30, "4": 40, "5": 50}',
        '2023-01-04 10:00:00'
    ),
    (
        5,
        'Movie Title 2',
        1,
        '2023-01-05 10:00:00',
        'Description of Movie 2',
        150,
        200,
        100,
        50,
        40,
        '{"1": 20, "2": 30, "3": 40, "4": 50, "5": 60}',
        '2023-01-05 10:00:00'
    ),
    (
        6,
        'TV Show Title 2',
        2,
        '2023-01-06 10:00:00',
        'Description of TV Show 2',
        400,
        300,
        150,
        75,
        60,
        '{"1": 25, "2": 35, "3": 45, "4": 55, "5": 65}',
        '2023-01-06 10:00:00'
    ),
    (
        7,
        'Book Title 2',
        3,
        '2023-01-07 10:00:00',
        'Description of Book 2',
        350,
        200,
        100,
        50,
        40,
        '{"1": 20, "2": 30, "3": 40, "4": 50, "5": 60}',
        '2023-01-07 10:00:00'
    ),
    (
        8,
        'Game Title 2',
        4,
        '2023-01-08 10:00:00',
        'Description of Game 2',
        250,
        150,
        75,
        40,
        30,
        '{"1": 15, "2": 25, "3": 35, "4": 45, "5": 55}',
        '2023-01-08 10:00:00'
    ),
    (
        9,
        'Movie Title 3',
        1,
        '2023-01-09 10:00:00',
        'Description of Movie 3',
        180,
        250,
        125,
        60,
        50,
        '{"1": 25, "2": 35, "3": 45, "4": 55, "5": 65}',
        '2023-01-09 10:00:00'
    ),
    (
        10,
        'TV Show Title 3',
        2,
        '2023-01-10 10:00:00',
        'Description of TV Show 3',
        500,
        400,
        200,
        100,
        80,
        '{"1": 30, "2": 40, "3": 50, "4": 60, "5": 70}',
        '2023-01-10 10:00:00'
    );

-- theme Tablosu
INSERT INTO
    theme (id, name)
VALUES
    (1, 'Action'),
    (2, 'Drama'),
    (3, 'Comedy'),
    (4, 'Sci-Fi'),
    (5, 'Horror'),
    (6, 'Romance'),
    (7, 'Thriller'),
    (8, 'Fantasy'),
    (9, 'Mystery'),
    (10, 'Adventure');

-- language Tablosu
INSERT INTO
    language (id, name)
VALUES
    (1, 'English'),
    (2, 'Spanish'),
    (3, 'French'),
    (4, 'German'),
    (5, 'Chinese'),
    (6, 'Japanese'),
    (7, 'Russian'),
    (8, 'Italian'),
    (9, 'Portuguese'),
    (10, 'Arabic');

-- country Tablosu
INSERT INTO
    country (id, name)
VALUES
    (1, 'USA'),
    (2, 'UK'),
    (3, 'France'),
    (4, 'Germany'),
    (5, 'China'),
    (6, 'Japan'),
    (7, 'Russia'),
    (8, 'Italy'),
    (9, 'Brazil'),
    (10, 'Saudi Arabia');

-- content_theme Tablosu
INSERT INTO
    content_theme (id, content_id, theme_id)
VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 2),
    (4, 2, 3),
    (5, 3, 4),
    (6, 3, 5),
    (7, 4, 6),
    (8, 4, 7),
    (9, 5, 8),
    (10, 5, 9),
    (11, 6, 10),
    (12, 6, 1),
    (13, 7, 2),
    (14, 7, 3),
    (15, 8, 4),
    (16, 8, 5),
    (17, 9, 6),
    (18, 9, 7),
    (19, 10, 8),
    (20, 10, 9);

-- content_language Tablosu
INSERT INTO
    content_language (id, content_id, language_id)
VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 1),
    (4, 2, 3),
    (5, 3, 4),
    (6, 3, 5),
    (7, 4, 6),
    (8, 4, 7),
    (9, 5, 8),
    (10, 5, 9),
    (11, 6, 10),
    (12, 6, 1),
    (13, 7, 2),
    (14, 7, 3),
    (15, 8, 4),
    (16, 8, 5),
    (17, 9, 6),
    (18, 9, 7),
    (19, 10, 8),
    (20, 10, 9);

-- content_country Tablosu
INSERT INTO
    content_country (id, content_id, country_id)
VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 2),
    (4, 2, 3),
    (5, 3, 4),
    (6, 3, 5),
    (7, 4, 6),
    (8, 4, 7),
    (9, 5, 8),
    (10, 5, 9),
    (11, 6, 10),
    (12, 6, 1),
    (13, 7, 2),
    (14, 7, 3),
    (15, 8, 4),
    (16, 8, 5),
    (17, 9, 6),
    (18, 9, 7),
    (19, 10, 8),
    (20, 10, 9);

-- user_content_log Tablosu
INSERT INTO
    user_content_log (
        id,
        user_id,
        content_id,
        content_status_id,
        date,
        rating,
        is_favorite,
        is_consume_later,
        review
    )
VALUES
    (
        1,
        1,
        1,
        1,
        '2023-01-01 10:00:00',
        4.5,
        true,
        false,
        'Great movie!'
    ),
    (
        2,
        2,
        2,
        1,
        '2023-01-02 10:00:00',
        3.5,
        false,
        true,
        'Interesting show.'
    ),
    (
        3,
        3,
        3,
        1,
        '2023-01-03 10:00:00',
        4.0,
        true,
        false,
        'Enjoyed the book.'
    ),
    (
        4,
        4,
        4,
        1,
        '2023-01-04 10:00:00',
        3.0,
        false,
        true,
        'Fun game.'
    ),
    (
        5,
        5,
        5,
        1,
        '2023-01-05 10:00:00',
        4.5,
        true,
        false,
        'Another great movie!'
    ),
    (
        6,
        1,
        6,
        1,
        '2023-01-06 10:00:00',
        3.5,
        false,
        true,
        'Long but good.'
    ),
    (
        7,
        2,
        7,
        1,
        '2023-01-07 10:00:00',
        4.0,
        true,
        false,
        'Great read.'
    ),
    (
        8,
        3,
        8,
        1,
        '2023-01-08 10:00:00',
        3.0,
        false,
        true,
        'Interesting game.'
    ),
    (
        9,
        4,
        9,
        1,
        '2023-01-09 10:00:00',
        4.5,
        true,
        false,
        'Great movie!'
    ),
    (
        10,
        5,
        10,
        1,
        '2023-01-10 10:00:00',
        3.5,
        false,
        true,
        'Long but good.'
    );

-- review Tablosu
INSERT INTO
    review (
        id,
        user_id,
        content_id,
        text,
        rating,
        like_count,
        comment_count,
        created_at,
        updated_at
    )
VALUES
    (
        1,
        1,
        1,
        'Great movie!',
        4.5,
        10,
        5,
        '2023-01-01 10:00:00',
        '2023-01-01 10:00:00'
    ),
    (
        2,
        2,
        2,
        'Interesting show.',
        3.5,
        5,
        2,
        '2023-01-02 10:00:00',
        '2023-01-02 10:00:00'
    ),
    (
        3,
        3,
        3,
        'Enjoyed the book.',
        4.0,
        8,
        4,
        '2023-01-03 10:00:00',
        '2023-01-03 10:00:00'
    ),
    (
        4,
        4,
        4,
        'Fun game.',
        3.0,
        6,
        3,
        '2023-01-04 10:00:00',
        '2023-01-04 10:00:00'
    ),
    (
        5,
        5,
        5,
        'Another great movie!',
        4.5,
        12,
        6,
        '2023-01-05 10:00:00',
        '2023-01-05 10:00:00'
    ),
    (
        6,
        1,
        6,
        'Long but good.',
        3.5,
        7,
        3,
        '2023-01-06 10:00:00',
        '2023-01-06 10:00:00'
    ),
    (
        7,
        2,
        7,
        'Great read.',
        4.0,
        9,
        5,
        '2023-01-07 10:00:00',
        '2023-01-07 10:00:00'
    ),
    (
        8,
        3,
        8,
        'Interesting game.',
        3.0,
        5,
        2,
        '2023-01-08 10:00:00',
        '2023-01-08 10:00:00'
    ),
    (
        9,
        4,
        9,
        'Great movie!',
        4.5,
        11,
        5,
        '2023-01-09 10:00:00',
        '2023-01-09 10:00:00'
    ),
    (
        10,
        5,
        10,
        'Long but good.',
        3.5,
        8,
        4,
        '2023-01-10 10:00:00',
        '2023-01-10 10:00:00'
    );

-- review_like Tablosu
INSERT INTO
    review_like (id, user_id, review_id, created_at)
VALUES
    (1, 2, 1, '2023-01-01 10:00:00'),
    (2, 1, 2, '2023-01-02 10:00:00'),
    (3, 3, 3, '2023-01-03 10:00:00'),
    (4, 4, 4, '2023-01-04 10:00:00'),
    (5, 5, 5, '2023-01-05 10:00:00'),
    (6, 1, 6, '2023-01-06 10:00:00'),
    (7, 2, 7, '2023-01-07 10:00:00'),
    (8, 3, 8, '2023-01-08 10:00:00'),
    (9, 4, 9, '2023-01-09 10:00:00'),
    (10, 5, 10, '2023-01-10 10:00:00');

-- review_comment Tablosu
INSERT INTO
    review_comment (id, review_id, user_id, text, created_at)
VALUES
    (1, 1, 2, 'I agree!', '2023-01-01 10:00:00'),
    (2, 2, 1, 'I disagree.', '2023-01-02 10:00:00'),
    (3, 3, 3, 'Nice review!', '2023-01-03 10:00:00'),
    (
        4,
        4,
        4,
        'I had a different experience.',
        '2023-01-04 10:00:00'
    ),
    (5, 5, 5, 'Great insights!', '2023-01-05 10:00:00'),
    (6, 6, 1, 'I agree!', '2023-01-06 10:00:00'),
    (7, 7, 2, 'I disagree.', '2023-01-07 10:00:00'),
    (8, 8, 3, 'Nice review!', '2023-01-08 10:00:00'),
    (
        9,
        9,
        4,
        'I had a different experience.',
        '2023-01-09 10:00:00'
    ),
    (
        10,
        10,
        5,
        'Great insights!',
        '2023-01-10 10:00:00'
    );

-- user_list Tablosu
INSERT INTO
    user_list (
        id,
        user_id,
        title,
        description,
        is_public,
        created_at,
        updated_at
    )
VALUES
    (
        1,
        1,
        'Favorites',
        'My favorite movies and shows',
        true,
        '2023-01-01 10:00:00',
        '2023-01-01 10:00:00'
    ),
    (
        2,
        2,
        'Watch Later',
        'Movies and shows to watch later',
        true,
        '2023-01-02 10:00:00',
        '2023-01-02 10:00:00'
    ),
    (
        3,
        3,
        'Must Read',
        'Books I must read',
        true,
        '2023-01-03 10:00:00',
        '2023-01-03 10:00:00'
    ),
    (
        4,
        4,
        'Games to Play',
        'Games I want to play',
        true,
        '2023-01-04 10:00:00',
        '2023-01-04 10:00:00'
    ),
    (
        5,
        5,
        'Top Picks',
        'My top picks',
        true,
        '2023-01-05 10:00:00',
        '2023-01-05 10:00:00'
    );

-- list_content Tablosu
INSERT INTO
    list_content (id, list_id, content_id, added_at)
VALUES
    (1, 1, 1, '2023-01-01 10:00:00'),
    (2, 2, 2, '2023-01-02 10:00:00'),
    (3, 3, 3, '2023-01-03 10:00:00'),
    (4, 4, 4, '2023-01-04 10:00:00'),
    (5, 5, 5, '2023-01-05 10:00:00'),
    (6, 1, 6, '2023-01-06 10:00:00'),
    (7, 2, 7, '2023-01-07 10:00:00'),
    (8, 3, 8, '2023-01-08 10:00:00'),
    (9, 4, 9, '2023-01-09 10:00:00'),
    (10, 5, 10, '2023-01-10 10:00:00');

-- creator Tablosu
INSERT INTO
    creator (id, name, profile_path)
VALUES
    (1, 'Director 1', 'path/to/profile1'),
    (2, 'Director 2', 'path/to/profile2'),
    (3, 'Author 1', 'path/to/profile3'),
    (4, 'Developer 1', 'path/to/profile4'),
    (5, 'Director 3', 'path/to/profile5'),
    (6, 'Author 2', 'path/to/profile6'),
    (7, 'Developer 2', 'path/to/profile7'),
    (8, 'Director 4', 'path/to/profile8'),
    (9, 'Author 3', 'path/to/profile9'),
    (10, 'Developer 3', 'path/to/profile10');

-- content_creator Tablosu
INSERT INTO
    content_creator (id, content_id, creator_id, role_type)
VALUES
    (1, 1, 1, 'Director'),
    (2, 2, 2, 'Director'),
    (3, 3, 3, 'Author'),
    (4, 4, 4, 'Developer'),
    (5, 5, 5, 'Director'),
    (6, 6, 6, 'Author'),
    (7, 7, 7, 'Developer'),
    (8, 8, 8, 'Director'),
    (9, 9, 9, 'Author'),
    (10, 10, 10, 'Developer');

-- genre Tablosu
INSERT INTO
    genre (id, name)
VALUES
    (1, 'Action'),
    (2, 'Drama'),
    (3, 'Comedy'),
    (4, 'Sci-Fi'),
    (5, 'Horror'),
    (6, 'Romance'),
    (7, 'Thriller'),
    (8, 'Fantasy'),
    (9, 'Mystery'),
    (10, 'Adventure');

-- content_genre Tablosu
INSERT INTO
    content_genre (id, content_id, genre_id)
VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 2),
    (4, 2, 3),
    (5, 3, 4),
    (6, 3, 5),
    (7, 4, 6),
    (8, 4, 7),
    (9, 5, 8),
    (10, 5, 9),
    (11, 6, 10),
    (12, 6, 1),
    (13, 7, 2),
    (14, 7, 3),
    (15, 8, 4),
    (16, 8, 5),
    (17, 9, 6),
    (18, 9, 7),
    (19, 10, 8),
    (20, 10, 9);

-- platform Tablosu
INSERT INTO
    platform (id, name, logo_path)
VALUES
    (1, 'Netflix', 'path/to/logo1'),
    (2, 'Hulu', 'path/to/logo2'),
    (3, 'Amazon Prime', 'path/to/logo3'),
    (4, 'HBO Max', 'path/to/logo4'),
    (5, 'Disney+', 'path/to/logo5'),
    (6, 'Steam', 'path/to/logo6'),
    (7, 'PlayStation Store', 'path/to/logo7'),
    (8, 'Xbox Store', 'path/to/logo8'),
    (9, 'Apple Books', 'path/to/logo9'),
    (10, 'Google Play Books', 'path/to/logo10');

-- content_platform Tablosu
INSERT INTO
    content_platform (id, content_id, platform_id)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5),
    (6, 6, 6),
    (7, 7, 7),
    (8, 8, 8),
    (9, 9, 9),
    (10, 10, 10);

-- app_cast_aaaa Tablosu
INSERT INTO
    app_cast_aaaa (id, name, profile_path)
VALUES
    (1, 'Actor 1', 'path/to/profile1'),
    (2, 'Actor 2', 'path/to/profile2'),
    (3, 'Actor 3', 'path/to/profile3'),
    (4, 'Actor 4', 'path/to/profile4'),
    (5, 'Actor 5', 'path/to/profile5'),
    (6, 'Actor 6', 'path/to/profile6'),
    (7, 'Actor 7', 'path/to/profile7'),
    (8, 'Actor 8', 'path/to/profile8'),
    (9, 'Actor 9', 'path/to/profile9'),
    (10, 'Actor 10', 'path/to/profile10');

-- content_cast Tablosu
INSERT INTO
    content_cast (id, content_id, cast_id, character_name)
VALUES
    (1, 1, 1, 'Character 1'),
    (2, 2, 2, 'Character 2'),
    (3, 3, 3, 'Character 3'),
    (4, 4, 4, 'Character 4'),
    (5, 5, 5, 'Character 5'),
    (6, 6, 6, 'Character 6'),
    (7, 7, 7, 'Character 7'),
    (8, 8, 8, 'Character 8'),
    (9, 9, 9, 'Character 9'),
    (10, 10, 10, 'Character 10');