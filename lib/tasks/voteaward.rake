require 'json'
require 'yaml'

namespace :voteaward do

  desc 'load voteaward 2012 users from json file'
  task :load_users, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward 2012 users from json file'
    Voteaward::User.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::User.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    columns = Voteaward::User.column_names
    puts "#{data["v2012"]["Users"].count} users are found."
    data["v2012"]["Users"].sort_by { |x| x['created_at'] }.each do |x|
      user = Voteaward::User.new
      columns.each do |c|
        user[c] = x[c]
      end
      user["oid"] = x["_id"]["$oid"]
      user["omniauth_token"] = x["omniauth_credentials"]["token"]
      user["omniauth_expires_at"] = x["omniauth_credentials"]["expires_at"]
      user["omniauth_expires"] = x["omniauth_credentials"]["expires"]
      user.save!
    end
    puts "#{Voteaward::User.count} users are created."
  end

  desc 'load voteaward elections from json file'
  task :load_elections, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward elections from json file'
    Voteaward::Election.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Election.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    columns = Voteaward::Election.column_names
    puts "#{data["v2012"]["Elections"].count} elections are found."
    data["v2012"]["Elections"].sort_by { |x| x['created_at'] }.each do |x|
      election = Voteaward::Election.new
      columns.each do |c|
        election[c] = x[c]
      end
      election["oid"] = x["_id"]["$oid"]
      election.save!
    end
    puts "#{Voteaward::Election.count} elections are created."
  end

  desc 'load voteaward candidates from json file'
  task :load_candidates, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward candidates from json file'
    Voteaward::Candidate.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Candidate.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    columns = Voteaward::Candidate.column_names
    puts "#{data["v2012"]["Candidates"].count} candidates are found."
    data["v2012"]["Candidates"].sort_by { |x| x['created_at'] }.each do |x|
      candidate = Voteaward::Candidate.new
      columns.each do |c|
        candidate[c] = x[c]
      end
      candidate["oid"] = x["_id"]["$oid"]
      candidate["voteaward_election_id"] = Voteaward::Election.find_by_oid(x["election_id"]["$oid"]).id
      candidate.save!
    end
    puts "#{Voteaward::Candidate.count} candidates are created."
  end

  desc 'load voteaward promises and awards from json file'
  task :load_promises_and_awards, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward promises and awards from json file'
    Voteaward::Promise.delete_all
    Voteaward::Award.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Promise.table_name}")
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Award.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    begin
      columns = Voteaward::Promise.column_names
      puts "#{data["v2012"]["Promises"].count} promises are found."
      data["v2012"]["Promises"].sort_by { |x| x['created_at'] }.each do |x|
        promise = Voteaward::Promise.new
        columns.each do |c|
          promise[c] = x[c]
        end
        promise["oid"] = x["_id"]["$oid"]
        promise["voteaward_election_id"] = Voteaward::Election.find_by_oid(x["election_id"]["$oid"]).id if x["election_id"]
        promise["voteaward_candidate_id"] = Voteaward::Candidate.find_by_oid(x["candidate_id"]["$oid"]).id if x["candidate_id"]
        promise["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id if x["user_id"]
        promise.save!
      end
      puts "#{Voteaward::Promise.count} promises are created."
    end

    begin
      columns = Voteaward::Award.column_names
      puts "#{data["v2012"]["Awards"].count} awards are found."
      data["v2012"]["Awards"].sort_by { |x| x['created_at'] }.each do |x|
        award = Voteaward::Award.new
        columns.each do |c|
          award[c] = x[c]
        end
        award["oid"] = x["_id"]["$oid"]
        award["voteaward_election_id"] = Voteaward::Election.find_by_oid(x["election_id"]["$oid"]).id if x["election_id"]
        award["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id if x["user_id"]
        award.save!
      end
      puts "#{Voteaward::Award.count} awards are created."
    end

    puts "Update #{Voteaward::Promise.where.not(award_ids: nil).count} Voteaward::Promise.award_ids"
    Voteaward::Promise.where.not(award_ids: nil).each do |x|
      x.award_ids = x.award_ids.map { |a| Voteaward::Award.find_by_oid(a["$oid"]).id }
      x.save!
    end

    puts "Update #{Voteaward::Award.where.not(promise_ids: nil).count} Voteaward::Award.promise_ids"
    Voteaward::Award.where.not(promise_ids: nil).each do |x|
      x.promise_ids = x.promise_ids.map { |a| Voteaward::Promise.find_by_oid(a["$oid"]).id }
      x.save!
    end
  end

  desc 'load voteaward events and votes from json file'
  task :load_events_and_votes, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward events and votes from json file'
    Voteaward::Event.delete_all
    Voteaward::Vote.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Event.table_name}")
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Vote.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    begin
      columns = Voteaward::Event.column_names
      puts "#{data["v2012"]["Events"].count} events are found."
      data["v2012"]["Events"].sort_by { |x| x['created_at'] }.each do |x|
        event = Voteaward::Event.new
        columns.each do |c|
          event[c] = x[c]
        end
        event["oid"] = x["_id"]["$oid"]
        event["voteaward_election_id"] = Voteaward::Election.find_by_oid(x["election_id"]["$oid"]).id if x["election_id"]
        event["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id if x["user_id"]
        event.save!
      end
      puts "#{Voteaward::Event.count} events are created."
    end

    begin
      columns = Voteaward::Vote.column_names
      puts "#{data["v2012"]["Votes"].count} votes are found."
      data["v2012"]["Votes"].sort_by { |x| x['created_at'] }.each do |x|
        vote = Voteaward::Vote.new
        columns.each do |c|
          vote[c] = x[c]
        end
        vote["oid"] = x["_id"]["$oid"]
        vote["voteaward_event_id"] = Voteaward::Event.find_by_oid(x["event_id"]["$oid"]).id if x["event_id"]
        vote["voteaward_election_id"] = Voteaward::Election.find_by_oid(x["election_id"]["$oid"]).id if x["election_id"]
        vote["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id if x["user_id"]
        vote.save!
      end
      puts "#{Voteaward::Vote.count} votes are created."
    end
  end

  desc 'load voteaward campaigns from json file'
  task :load_campaigns, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward campaigns from json file'
    Voteaward::Campaign.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Campaign.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    columns = Voteaward::Campaign.column_names
    puts "#{data["v2012"]["Campaigns"].count} campaigns are found."
    data["v2012"]["Campaigns"].sort_by { |x| x['created_at'] }.each do |x|
      campaign = Voteaward::Campaign.new
      columns.each do |c|
        campaign[c] = x[c]
      end
      campaign["oid"] = x["_id"]["$oid"]
      campaign["voteaward_candidate_id"] = Voteaward::Candidate.find_by_oid(x["candidate_id"]["$oid"]).id if x["candidate_id"]
      campaign["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id if x["user_id"]
      campaign.save!
    end
    puts "#{Voteaward::Campaign.count} campaigns are created."
  end

  desc 'load voteaward giveups from json file'
  task :load_giveups, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward giveups from json file'
    Voteaward::Giveup.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Giveup.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    columns = Voteaward::Giveup.column_names
    puts "#{data["v2012"]["Giveups"].count} giveups are found."
    data["v2012"]["Giveups"].sort_by { |x| x['created_at'] }.each do |x|
      giveup = Voteaward::Giveup.new
      columns.each do |c|
        giveup[c] = x[c]
      end
      giveup["oid"] = x["_id"]["$oid"]
      giveup["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id
      giveup.save!
    end
    puts "#{Voteaward::Giveup.count} giveups are created."
  end

  desc 'load voteaward comments from json file'
  task :load_comments, [:filename] => [:environment ] do |task, args|
    puts "#{args[:filename]} is not found." and return unless File.exists? args[:filename]
    puts 'load voteaward comments from json file'
    Voteaward::Comment.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE #{Voteaward::Comment.table_name}")
    data = JSON.parse(File.read(args[:filename]))
    columns = Voteaward::Comment.column_names
    puts "#{data["v2012"]["Comments"].count} comments are found."
    data["v2012"]["Comments"].sort_by { |x| x['created_at'] }.each do |x|
      comment = Voteaward::Comment.new
      columns.each do |c|
        comment[c] = x[c]
      end
      comment["oid"] = x["_id"]["$oid"]
      comment["commentable_id"] = "Voteaward::#{x['commentable_type']}".constantize.find_by_oid(x["commentable_id"]["$oid"]).id
      comment["voteaward_user_id"] = Voteaward::User.find_by_oid(x["user_id"]["$oid"]).id
      comment["commentable_type"] = "Voteaward::#{comment['commentable_type']}"
      comment.save!
    end
    puts "#{Voteaward::Comment.count} comments are created."
  end

  desc 'load voteaward data from json file(default)'
  task :load_data, [:filename] => [:environment ] do |task, args|
    puts 'load voteaward data from json file'
    Rake::Task['voteaward:load_users'].execute filename: args[:filename]
    Rake::Task['voteaward:load_elections'].execute filename: args[:filename]
    Rake::Task['voteaward:load_candidates'].execute filename: args[:filename]
    Rake::Task['voteaward:load_promises_and_awards'].execute filename: args[:filename]
    Rake::Task['voteaward:load_events_and_votes'].execute filename: args[:filename]
    Rake::Task['voteaward:load_campaigns'].execute filename: args[:filename]
    Rake::Task['voteaward:load_giveups'].execute filename: args[:filename]
    Rake::Task['voteaward:load_comments'].execute filename: args[:filename]
  end

end
