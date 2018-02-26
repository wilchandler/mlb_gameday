# frozen_string_literal: true

require 'minitest/autorun'
require 'mlb_gameday.rb'

# Mock the basic `open` function so we don't actually hit the MLB website
class MockedApi < MLBGameday::API
  alias old_open open

  def open(url, &block)
    dir = File.dirname __FILE__
    base = url.gsub 'http://gdx.mlb.com/components/game/mlb/', ''
    path = File.join dir, base

    unless File.exist?(path)
      puts "Downloading from website: #{url}"

      return old_open(url, &block)
    end

    file = File.open path

    return file unless block_given?

    yield file
  end
end

class TestGame < MiniTest::Test
  def setup
    @api = MockedApi.new
    @game = @api.game('2014_05_28_cinmlb_lanmlb_1')
    # @free_game = @api.game('2013_04_01_slnmlb_arimlb_1')
  end

  def test_load_game_from_gid
    assert_equal 'Dodgers', @game.home_team.name
  end

  def test_load_game_for_team_on_date
    dodgers = @api.team('Dodgers')

    games = @api.find_games(team: dodgers, date: Date.parse('2014-05-28'))

    assert_equal 1, games.count
  end

  def test_game_has_two_teams
    assert_equal 2, @game.teams.count
  end

  def test_correct_venue
    assert_equal 'Dodger Stadium', @game.venue
  end

  def test_home_start_time
    assert_equal '7:10 PM PT', @game.home_start_time
  end

  def test_away_start_time
    assert_equal '10:10 PM ET', @game.away_start_time
  end

  def test_home_starting_pitcher
    assert_equal 'Clayton Kershaw', @game.home_pitcher.name
  end

  def test_home_tv
    assert_equal 'SportsNet LA, SNLA Spanish', @game.home_tv
  end

  def test_away_radio
    assert_equal 'WLW 700, Reds Radio Network', @game.away_radio
  end

  def test_free_game_1
    refute @game.free?
  end

  def test_free_game_2
    skip 'Free game not yet loaded.'

    assert @free_game.free?
  end

  def test_game_attendance
    assert_equal '41,129', @game.attendance
  end

  def test_game_elapsed_time
    assert_equal '3:08', @game.elapsed_time
  end

  def test_game_weather
    assert_equal '71 degrees, partly cloudy', @game.weather
  end

  def test_game_wind
    assert_equal '8 mph, Out to CF', @game.wind
  end

  def test_game_umpires
    assert_equal(
      {
        'HP' => 'Phil Cuzzi',
        '1B' => 'Gerry Davis',
        '2B' => 'Quinn Wolcott',
        '3B' => 'Greg Gibson'
      },
      @game.umpires
    )
  end
end
