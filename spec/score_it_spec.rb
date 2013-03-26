require 'spec_helper'
require 'ostruct'

class SomeClass
  include ScoreIt

  attr_accessor :attr1, :attr2

  def initialize attr1, attr2
    @attr1, @attr2 = attr1, attr2
  end

end

describe "Scorable Class" do
  let(:some_instance) { SomeClass.new "value 1", "value 2"}

  it "should provide a method to store scorable attributes" do
    SomeClass.should respond_to(:score_attributes)
    SomeClass.score_attributes :attr1
    SomeClass.scorable_attributes.should include(:attr1)
  end

  it "instance should know about its scorable attributes" do
    SomeClass.score_attributes :attr1
    some_instance.should respond_to(:scorable_attributes)
    some_instance.scorable_attributes.should_not be_empty
    some_instance.scorable_attributes.should include(:attr1)
  end

  context "no attributes given" do

    it "total score should be 0" do
      some_instance.stub(:scorable_attributes) { [] }
      some_instance.total_score.should == 0
    end
    
  end

  context "attributes given" do

    it "score should not be 0 if value is present" do
      SomeClass.score_attributes [:attr1, 42]
      some_instance.score.should_not == 0
    end

    it "score should be 0 if value is not present" do
      SomeClass.score_attributes [:attr1, 42]
      some_instance.attr1 = ""
      some_instance.score.should == 0
    end

    it "total score should be the sum of all scores" do
      SomeClass.score_attributes [:attr1, 42], [:attr2, 18]
      some_instance.total_score.should == 60
    end

    it "scores should be equal to the ones provided" do
      SomeClass.score_attributes [:attr1, 42]
      some_instance.score_for(:attr1).should == 42
    end

    it "score of an unknown attribute should be 0" do
      some_instance.score_for(:attr3).should == 0
    end
  end
  
end