require "../../spec_helper"

class Rendering::CustomPage
  include LuckyWeb::Page

  assign title : String
  assign arg2 : String

  render do
    text title
  end
end

class Rendering::Foo < LuckyWeb::Action
  get "/foo" do
    render Rendering::CustomPage, title: "EditPage", arg2: "testing_multiple_args"
  end
end

class Rendering::WithinSameNameSpace < LuckyWeb::Action
  get "/in-namespace" do
    render CustomPage, title: "WithinSameNameSpace", arg2: "testing_multiple_args"
  end
end

describe LuckyWeb::Action do
  it "renders fully qualified pages" do
    body = Rendering::Foo.new(context, params).call.body

    body.should eq "EditPage"
  end

  it "renders within the same namespace" do
    body = Rendering::WithinSameNameSpace.new(context, params).call.body

    body.should eq "WithinSameNameSpace"
  end
end

private def context(path = "/")
  io = IO::Memory.new
  request = HTTP::Request.new("GET", path)
  response = HTTP::Server::Response.new(io)
  HTTP::Server::Context.new request, response
end

private def params
  {} of String => String
end
