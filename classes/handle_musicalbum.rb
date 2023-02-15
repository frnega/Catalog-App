require 'json'
require 'date'
require_relative 'music_album'
require_relative 'genre'

class HandleMusicAlbum
  def initialize
    @albums = load_albums
    @genres = load_genres
  end

  # Create Music Album & Genre
  def create_music_album
    print 'Publish date of the album [Enter date in format (yyyy-mm-dd)]: '
    publish_date = Date.parse(gets.chomp)
    return unless publish_date

    print 'Is the album on spotify? [Y/N]: '
    on_spotify = gets.chomp.downcase == 'y' || false

    @albums << MusicAlbum.new(publish_date, on_spotify)
    puts 'Album created successfully'

    print 'Do you want to add genre? [Y/N]: '
    perm = gets.chomp.downcase == 'y' || false
    if perm
      puts 'Please, type the genre id '
      id = gets.chomp
      puts 'Please, type the genre name '
      g_name = gets.chomp
      @genres << Genre.new(id,g_name)
      puts 'Music album and Genre created successfully'
    else
      puts 'Music Album created successfully'
    end
  end

  # List Albums and Genres
  def list_albums
    @albums.each do |album|
      puts "\nName: #{album.name}"
      puts "Publish Date: #{album.publish_date}"
      puts "On Spotify: #{album.on_spotify}"
    end
  end

  def list_genres
    @genres.each do |genre|
      puts "\nName: #{genre.name}"
    end
  end

  # Load & Save Genres to JSON
  def load_genres
    if File.exist?('./json_data/genre.json') && File.read('./json_data/genre.json') != ''
      JSON.parse(File.read('./json_data/genre.json')).map do |genre|
        Genre.new(genre['name'])
      end
    else
      []
    end
  end

  def save_genres
    data = []
    @genres.each do |genre|
      data.push({ name: genre.name })
    end
    open('./json_data/genre.json', 'w') { |f| f << JSON.pretty_generate(data) }
  end

  # Load & Save Albums to JSON
  def load_albums
    if File.exist?('./json_data/album.json') && File.read('./json_data/album.json') != ''
      JSON.parse(File.read('./json_data/album.json')).map do |album|
        MusicAlbum.new(album['name'], album['publish_date'], album['spotify'])
      end
    else
      []
    end
  end

  def save_albums
    data = []
    @albums.each do |album|
      data.push({ album.name, album.publish_date, album.on_spotify })
    end
    open('./json_data/album.json', 'w') { |f| f << JSON.pretty_generate(data) }
  end
end