require File.dirname(__FILE__) + '/../spec_helper'

describe GreedyPage do
  scenario :home_page

  before do
    create_page "Greedy Parent", :class_name => "GreedyPage" do
       create_page "Greedy Child", :class_name => "GreedyPage"
       create_page "Normal Child"
    end
    create_page "Sibling Page"
  end

  it "should find the page when it normally could be found" do
     pages(:greedy_parent).find_by_url('/greedy-parent').should == pages(:greedy_parent)
     pages(:greedy_child).find_by_url('/greedy-parent/greedy-child').should == pages(:greedy_child)
     pages(:normal_child).find_by_url('/greedy-parent/normal-child').should == pages(:normal_child)
  end
 
  it "should find the greedy page when a child could not be found" do
     pages(:home).find_by_url('/greedy-parent/missing-child').should == pages(:greedy_parent)
  end
  
  it "should find the greedy child when a grand child could not be found" do
     pages(:home).find_by_url('/greedy-parent/greedy-child/missing-child').should == pages(:greedy_child)
     pages(:home).find_by_url('/greedy-parent/greedy-child/missing-child1/missing-child2/missing-child3').should == pages(:greedy_child)
  end

  it "should not find the greedy page when a child should be found" do
     pages(:home).find_by_url('/greedy-parent/normal-child').should_not == pages(:greedy_parent)
  end
  
  it "should not find the greedy page when a sibling should be found" do
     pages(:home).find_by_url('/sibling-page').should_not == pages(:greedy_parent)
  end
  
end
