require_relative './spec_helper'
require 'rack/test'
require 'json'
describe Necrohost::Server do
  describe "application" do
    include Rack::Test::Methods
    let(:app) { Necrohost::Server }

    it "returns successful for status/200" do
      get '/status/200'
      last_response.status.must_equal 200
    end

    it "returns 500 for status/500" do
      get '/status/500'
      last_response.status.must_equal 500
    end

    it "returns 301 for status/301" do
      get '/status/301'
      last_response.status.must_equal 301
      last_response.headers['location'].must_equal "http://example.org/redirected"
    end

    it "returns 302 for status/302" do
      get '/status/302'
      last_response.status.must_equal 302
      last_response.headers['location'].must_equal "http://example.org/redirected"
    end

    it "detects json format and returns json" do
      get '/status/200.json'
      last_response.status.must_equal 200
      JSON.parse(last_response.body).must_equal({"status" =>"200"})
    end
  end
  describe "render shortcuts" do
    let(:template_name) { "the_template" }

    subject do
      Necrohost::Server.dependencies[:mustache] = stub(:mustache => :hamly_stache)
      Necrohost::Server.dependencies[:haml] = stub(:haml => "")
      Necrohost::Server.new!
    end

    it "just renders mustache/haml by default" do
      subject.expects(:mustache).returns(:mustache_result)
      subject.expects(:haml).with(:mustache_result)
      subject.hamustache template_name
    end

    it "autocreates a view inherited from layout" do
      expected_class = "Necrohost::Server::Views::TheTemplate"
      subject.hamustache template_name
      Necrohost::Server::Views.const_defined?("TheTemplate").must_equal true
      Necrohost::Server::Views.const_get("TheTemplate").must_be :<, Necrohost::Server::Views::Layout
    end

  end

end

