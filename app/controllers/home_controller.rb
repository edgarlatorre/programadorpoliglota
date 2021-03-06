class HomeController < ApplicationController
  caches_page :index, :support

  def index
    page = 1
    @tag_groups = TagGroup.all
    @tweets = {}
    @links = {}
    @retweeted_users = {}
    load_tweets_and_links_for @tag_groups, page
  end

  def see_more
    @page = params[:page].to_i ||= 1
    @tag_group = TagGroup.find(params[:tag_group].to_i)
    @tweets = retrieve_tweets_for @tag_group, @page
    has_more_pages(@tag_group)

    render :layout => false
  end

  def support
  end

  private

  def has_more_pages(tag_group)
    total_tweets = Tweet.amount_of_tweets_for @tag_group
    @has_more_pages = (total_tweets > @page * Tweet::TWEETS_PER_PAGE)  
  end
  
  def load_tweets_and_links_for(tag_groups, page)
    tag_groups.each do |tag_group|
      @tweets[tag_group.name] = retrieve_tweets_for tag_group, page
      @retweeted_users[tag_group.name] = RetweetedUser.most_retweeted_for(tag_group)
      @links[tag_group.name] = Link.most_popular_for tag_group
    end
  end  
  
  def retrieve_tweets_for(tag_group, page)
    Tweet.last_tweets_for tag_group, :page=> page
  end  
end
