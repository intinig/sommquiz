require __dir__ + "/spec_helper"
require File.join(File.dirname(__FILE__) + "/../lib/models")

describe "General features" do
  it "should run redis" do
    REDIS.set "foo", "bar"
    expect(REDIS.get("foo")).to eq("bar")
  end
end
