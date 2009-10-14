require 'life'

describe Life do
  it "should have the answer 42" do
    life = Life.new
    life.answer.should == 42
  end
end
