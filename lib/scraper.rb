require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    doc.css('.student-card').map do |student|
      name = student.css('h4.student-name').text
      location = student.css('p.student-location').text
      url = student.css('a').attribute('href').value
      {:name => name, :location => location, :profile_url => url}
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_hash = {}
    doc.css('.social-icon-container a').each do |link|
      url = link.attribute('href').value
      profile_hash[:twitter] = url if url.include?('twitter')
      profile_hash[:linkedin] = url if url.include?('linkedin')
      profile_hash[:github] = url if url.include?('github')
      if ['blog', 'wordpress', '.io'].any? { |word| url.include?(word) } || !(['github', 'twitter', 'linkedin', 'facebook'].any? { |word| url.include?(word) })
        profile_hash[:blog] = url
      end
    end
    profile_hash[:profile_quote] = doc.css('.profile-quote').text
    profile_hash[:bio] = doc.css('div.bio-content div.description-holder p').text
    profile_hash
  end

end
