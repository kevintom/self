require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'simple-rss'

get '/' do
  twitter_response = RestClient.get("http://twitter.com/statuses/user_timeline/6068312.rss")
  posterous_response = RestClient.get("http://kevintom.posterous.com/rss.xml")
  blog_response = RestClient.get("http://blog.kevintom.com/feed/")
  
  twitter_rss = SimpleRSS.parse(twitter_response)
  posterous_rss = SimpleRSS.parse(posterous_response)
  blog_rss = SimpleRSS.parse(blog_response)
  
  twitter_title = twitter_rss.items[0].title
  twitter_title = twitter_title.gsub("kevintom: ", "")
  link = twitter_rss.items[0].link
  
  twitter_snippet = '<a href="' + link + '">' + twitter_title + '</a>'

  posterous_body = posterous_rss.items[0].description
  posterous_title = posterous_rss.items[0].title
  posterous_link = posterous_rss.items[0].link
  posterous_snippet = '<p class="posterous_title"><a href="' + posterous_link + '">' + posterous_title + '</a></p>' + posterous_body

  blog_title = blog_rss.items[0].title
  blog_link = blog_rss.items[0].link
  blog_body = blog_rss.items[0].content_encoded
  blog_snippet = '<p class="blog_title"><a href="' + blog_link + '">' + blog_title + '</a></p>' + blog_body
#  blog_snippet = '<p>Blog Offline</p>'
  erb :index, :locals =>{:blog => blog_snippet, :posterous => posterous_snippet, :twitter => twitter_snippet}
end
