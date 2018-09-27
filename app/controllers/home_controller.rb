require 'rest-client'
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    response = RestClient.get 'http://quotesondesign.com/wp-json/posts'
    result = JSON.parse(response)
    r = result.first
    attr = { title: r['title'], content: r['content'], link: r['link'] }
    attr.merge({ source: r['custom_meta']['Source'] }) if r['custom_meta'].present?
    @quote = Quote.find_by_title_and_content(r['title'], r['content']) || Quote.create(attr)
  end

  def create_quotes
    @quote = Quote.new(quote_params)
    @quote.source = params[:source] if params[:source]
    Quote.find_by_title_and_content(params[:quote][:title], params[:quote][:content]) || @quote.save
  end

  private
  def quote_params
    params.require(:quote).permit(:title, :content, :link)
  end
end

