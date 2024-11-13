Table content_type_enum {
  id integer [pk]
  name varchar
}

Table content_status_enum {
  id integer [pk]
  name varchar
}

Table user {
  id integer [pk]
  username varchar [unique]
  email varchar [unique]
  password_hash varchar
  bio text
  personality_analyze text
  created_at timestamp
}

Table user_follow {
  id integer [pk]
  follower_id integer [ref: > user.id]
  following_id integer [ref: > user.id]
  created_at timestamp
  indexes {
    (follower_id, following_id) [unique]
  }
}

Table content {
  id integer [pk]
  title varchar
  content_type_id integer [ref: > content_type_enum.id]
  release_date timestamp
  description text
  length integer
  consume_count integer
  favori_count integer
  list_count integer
  review_count integer
  rating_distribution json
  created_at timestamp
}

Table theme {
  id integer [pk]
  name varchar
}

Table language {
  id integer [pk]
  name varchar
}

Table country {
  id integer [pk]
  name varchar
}

Table content_theme {
  id integer [pk]
  content_id integer [ref: > content.id]
  theme_id integer [ref: > theme.id]
  indexes {
    (content_id, theme_id) [unique]
  }
}

Table content_language {
  id integer [pk]
  content_id integer [ref: > content.id]
  language_id integer [ref: > language.id]
  indexes {
    (content_id, language_id) [unique]
  }
}

Table content_country {
  id integer [pk]
  content_id integer [ref: > content.id]
  country_id integer [ref: > country.id]
  indexes {
    (content_id, country_id) [unique]
  }
}

Table user_content_log {
  id integer [pk]
  user_id integer [ref: > user.id]
  content_id integer [ref: > content.id]
  content_status_id integer [ref: > content_status_enum.id]
  date timestamp
  rating decimal
  is_favorite boolean [default: false]
  is_consume_later boolean [default: false]
  review text
  indexes {
    (user_id, content_id) [unique]
  }
}

Table review {
  id integer [pk]
  user_id integer [ref: > user.id]
  content_id integer [ref: > content.id]
  text text
  rating decimal
  like_count integer [default: 0]
  comment_count integer [default: 0]
  created_at timestamp
  updated_at timestamp
}

Table review_like {
  id integer [pk]
  user_id integer [ref: > user.id]
  review_id integer [ref: > review.id]
  created_at timestamp
  indexes {
    (user_id, review_id) [unique]
  }
}

Table review_comment {
  id integer [pk]
  review_id integer [ref: > review.id]
  user_id integer [ref: > user.id]
  text text
  created_at timestamp
}

Table user_list {
  id integer [pk]
  user_id integer [ref: > user.id]
  title varchar
  description text
  is_public boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table list_content {
  id integer [pk]
  list_id integer [ref: > user_list.id]
  content_id integer [ref: > content.id]
  added_at timestamp
  indexes {
    (list_id, content_id) [unique]
  }
}

Table creator {
  id integer [pk]
  name varchar
  profile_path varchar
}

Table content_creator {
  id integer [pk]
  content_id integer [ref: > content.id]
  creator_id integer [ref: > creator.id]
  role_type varchar
  indexes {
    (content_id, creator_id) [unique]
  }
}

Table genre {
  id integer [pk]
  name varchar
}

Table content_genre {
  id integer [pk]
  content_id integer [ref: > content.id]
  genre_id integer [ref: > genre.id]
  indexes {
    (content_id, genre_id) [unique]
  }
}

Table platform {
  id integer [pk]
  name varchar
  logo_path varchar
}

Table content_platform {
  id integer [pk]
  content_id integer [ref: > content.id]
  platform_id integer [ref: > platform.id]
  indexes {
    (content_id, platform_id) [unique]
  }
}

Table cast {
  id integer [pk]
  name varchar
  profile_path varchar
}

Table content_cast {
  id integer [pk]
  content_id integer [ref: > content.id]
  cast_id integer [ref: > cast.id]
  character_name varchar
  indexes {
    (content_id, cast_id) [unique]
  }
}