inception = Movie.find_or_create_by!(title: "Inception", original_title: "Inception", year: 2010)
the_matrix = Movie.find_or_create_by!(title: "The Matrix", original_title: "The Matrix", year: 1999)
parasite = Movie.find_or_create_by!(title: "Parasite", original_title: "기생충", year: 2019)

breaking_bad = TvShow.find_or_create_by!(title: "Breaking Bad", original_title: "Breaking Bad", year: 2008)

breaking_bad_season_1 = Season.find_or_create_by!(tv_show: breaking_bad, number: 1) do |season|
  season.title = "Season 1"
  season.original_title = "Season 1"
  season.year = 2008
end

breaking_bad_season_1_episode_1 = Episode.find_or_create_by!(season: breaking_bad_season_1, number: 1) do |episode|
  episode.title = "Pilot"
  episode.original_title = "Pilot"
  episode.year = 2008
end

breaking_bad_season_1_episode_2 = Episode.find_or_create_by!(season: breaking_bad_season_1, number: 2) do |episode|
  episode.title = "Cat's in the Bag..."
  episode.original_title = "Cat's in the Bag..."
  episode.year = 2008
end

Season.find_or_create_by!(tv_show: breaking_bad, number: 2) do |season|
  season.title = "Season 2"
  season.original_title = "Season 2"
  season.year = 2009
end

top_picks = List.find_or_create_by!(name: "Top Picks")

[
  [ inception, 1 ],
  [ breaking_bad, 2 ],
  [ breaking_bad_season_1, 3 ],
  [ breaking_bad_season_1_episode_1, 4 ],
  [ breaking_bad_season_1_episode_2, 5 ],
  [ the_matrix, 6 ]
].each do |content, position|
  ListItem.find_or_create_by!(list: top_picks, content: content) do |item|
    item.position = position
  end
end

movies_only = List.find_or_create_by!(name: "Movie Night")

[ [ the_matrix, 1 ], [ inception, 2 ], [ parasite, 3 ] ].each do |content, position|
  ListItem.find_or_create_by!(list: movies_only, content: content) do |item|
    item.position = position
  end
end
