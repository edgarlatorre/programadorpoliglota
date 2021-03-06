require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "should retrive all tweets for #java Tag" do
      tweets = [Tweet.new, Tweet.new]
      tag = TagGroup.new(:name=>'#java')
      
      TagGroup.should_receive(:all).and_return([tag])
      query = Object.new
      Tweet.should_receive(:last_tweets_for).with(tag, :page=>1).and_return(tweets)
      
      get :index
      tweets_found = assigns(:tweets)
      tweets_found['#java'].should eq(tweets)
    end
    
    it "should retrieve all links for #java Tag" do
      java_tag = TagGroup.new :name=>'#java'
      tags = [java_tag]
      links = [Link.new, Link.new]
      
      TagGroup.should_receive(:all).and_return(tags)
      Tweet.should_receive(:last_tweets_for) 
      Link.should_receive(:most_popular_for).with(java_tag).and_return(links)
      
      get :index
      links_found = assigns(:links)
      links_found['#java'].should eq(links)
    end
    
    it 'should retrieve most retweeted for #java Tag' do
      java_tag = TagGroup.new :name=>'#java'
      tags = [java_tag]
      users = [RetweetedUser.new, RetweetedUser.new]
      
      TagGroup.should_receive(:all).and_return(tags)
      Tweet.should_receive(:last_tweets_for) 
      Link.should_receive(:most_popular_for)
      RetweetedUser.should_receive(:most_retweeted_for).with(java_tag).and_return(users)
      
      get :index
      users_found = assigns(:retweeted_users)
      users_found['#java'].should eq(users)
    end
  end
  describe "#see_more" do
    it "should use the given page number for pagination" do
      tweets = [Tweet.new, Tweet.new]
      tag = TagGroup.new(:name=>'#java')
      
      TagGroup.should_receive(:find).with(1).and_return(tag)
      Tweet.should_receive(:last_tweets_for).with(tag, :page=>2).and_return(tweets)
      
      get :see_more, :page=>'2', :tag_group=>'1'
    end
    
    it "should make available the number of the current page" do
      tweets = [Tweet.new, Tweet.new]
      tag = TagGroup.new(:name=>'#java')
      
      TagGroup.should_receive(:find).with(1).and_return(tag)
      Tweet.should_receive(:last_tweets_for).with(tag, :page=>2).and_return(tweets)
      
      get :see_more, :page=>'2', :tag_group=>'1'
      assigns(:page).should == 2
    end
    
    it "should make available that there are no other pages to see" do
      tweets = [Tweet.new, Tweet.new]
      tag = TagGroup.new(:name=>'#java')

      TagGroup.should_receive(:find).with(1).and_return(tag)
      Tweet.should_receive(:last_tweets_for).with(tag, :page=>2).and_return(tweets)
      Tweet.should_receive(:amount_of_tweets_for).with(tag).and_return(7)
      
      get :see_more, :page=>'2', :tag_group=>'1'
      assigns(:has_more_pages).should == false
    end
    
    it "should make available that there are other pages to see" do
      tweets = [Tweet.new, Tweet.new]
      tag = TagGroup.new(:name=>'#java')

      TagGroup.should_receive(:find).with(1).and_return(tag)
      Tweet.should_receive(:last_tweets_for).with(tag, :page=>2).and_return(tweets)
      Tweet.should_receive(:amount_of_tweets_for).with(tag).and_return(25)
      
      get :see_more, :page=>'2', :tag_group=>'1'
      assigns(:has_more_pages).should == true
    end
  end
end