# frozen_string_literal: true

RSpec.describe "Configuration" do
  it "has a version number" do
    expect(PubSub::VERSION).not_to be nil
  end
end
