require "rubygems"
require "bundler/setup"
require 'httparty'
require 'multi_json'
require 'base'

module Echonest
  class Artist < Echonest::Base

    def initialize(name, api_key)
      @name = name
      @api_key = api_key
    end

    def name
      @name
    end

    def entity_name
      self.class.to_s.split('::').last.downcase
    end

    def get_response(options = {})
      calling_method = caller[0].split('`').last[0..-2]
      get("#{ entity_name }/#{ calling_method }", options)
    end

    def biographies(options = { results: 1 })
      #response = get("#{ entity_name }/#{ __method__ }", results: options[:results], name: @name)
      response = get_response(results: options[:results], name: @name)
      biographies = []
      response[:response][:biographies].each do |b|
        biographies << Biography.new(text: b[:text], site: b[:site], url: b[:url])
      end
      biographies
    end

    def blogs(options = { results: 1 })
      response = get("#{ entity_name }/#{ __method__ }", results: options[:results], name: @name)
      blogs = []
      response[:response][:blogs].each do |b|
        blogs << Blog.new(name: b[:name], site: b[:site], url: b[:url])
      end
      blogs
    end

    def familiarity
      response = get("#{ entity_name }/#{ __method__ }", name: @name)
      response[:response][:artist][:familiarity]
    end

    def hotttnesss
      response = get("#{ entity_name }/#{ __method__ }", name: @name)
      response[:response][:artist][:hotttnesss]
    end

    def images
      response = get("#{ entity_name }/#{ __method__ }", name: @name)
    end

  end
end