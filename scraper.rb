#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'

# require 'colorize'
# require 'pry'
# require 'csv'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'

@BASE = 'http://www.assemblee.bi'
@PAGE = @BASE + '/spip.php?page=imprimer&id_article=418'

def noko(url)
  url.prepend @BASE unless url.start_with? 'http:'
  warn "Getting #{url}"
  Nokogiri::HTML(open(url).read) 
end

page = noko(@PAGE)
page.css('table tr').drop(2).each do |mem|
  tds = mem.css('td')
  data = { 
    id: '2010-' + tds[0].text.strip,
    name: tds[1].text.strip,
    area: tds[2].text.strip,
    party: tds[3].text.strip,
    party_id: tds[3].text.strip,
    term: '2010',
    source: @PAGE,
  }
  puts data
  ScraperWiki.save_sqlite([:id, :term], data)
end
