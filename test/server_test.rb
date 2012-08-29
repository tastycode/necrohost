require 'test_helper'
describe Necrohost::Server do
  describe "render shortcut" do
    let(:template_name) { "the_template" }

    subject do
      Necrohost::Server.dependencies[:mustache] = stub(:mustache => :hamly_stache)
      Necrohost::Server.dependencies[:haml] = stub(:haml => "")
      Necrohost::Server.new!
    end

    it "just renders mustache/haml by default" do
      subject.expects(:mustache).returns(:mustache_result)
      subject.expects(:haml).with(:mustache_result)
      subject.render_hamustache template_name
    end

    it "autocreates a view inherited from layout" do
      expected_class = "Necrohost::Server::Views::TheTemplate"
      subject.render_hamustache template_name
      Necrohost::Server::Views.const_defined?("TheTemplate").must_equal true
      Necrohost::Server::Views.const_get("TheTemplate").must_be :<, Necrohost::Server::Views::Layout
    end

  end

end

