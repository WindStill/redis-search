# RedisSearch

High performance real-time search (Support Chinese), index in Redis for Rails application

## Features

* Real-time search
* High performance
* Segment words search and prefix match search
* Support ActiveRecord, Mongoid and others ORM

## Requirements

* Redis 2.2+

## Install

in Rails application Gemfile

	gem 'redis','2.1.1'
	gem "rmmseg-cpp-huacnlee", "0.2.8"
	gem 'redis-search', '0.3'

install bundlers

    $ bundle install

## Configure

create file in: config/initializers/redis_search.rb

    require "redis_search"
    redis = Redis.new(:host => "127.0.0.1",:port => "6379")
    # change redis database to 3, you need use a special database for search feature.
    redis.select(3)
    RedisSearch.configure do |config|
      config.redis = redis
      config.complete_max_length = 100
    end

## Usage

bind RedisSearch callback event, it will to rebuild search indexes when data create or update.

    class Post
      include Mongoid::Document
      include RedisSearch
  
      field :title
      field :body
  
      belongs_to :user
      belongs_to :category
  
      redis_search_index(:title_field => :title,
                         :ext_fields => [:category_name])
  
      def category_name
        self.category.name
      end
    end
    
    class User
      include Mongoid::Document
      include RedisSearch
      
      field :name
      field :tagline
      field :email
      
      redis_search_index(:title_field => :name,
                         :prefix_index_enable => true,
                         :ext_fields => [:email,:tagline])
    end

    class SearchController < ApplicationController
      # GET /searchs?q=title
      def index
        RedisSearch::Search.query("Post", params[:q])
      end
      
      # GET /search_users?q=j
      def search_users
        RedisSearch::Search.complete("Post", params[:q])
      end
    end

## Benchmark test

* [https://gist.github.com/1150933](https://gist.github.com/1150933)
    
## Demo

You can try the search feature in [`zheye.org`](http://zheye.org)