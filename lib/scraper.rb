require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    roster = Nokogiri::HTML(html)

    rosters = []
    roster.css("div.student-card").each do |card|

      rosters.push({
        :name => card.css("h4.student-name").text,
        :location => card.css("p.student-location").text,
        :profile_url => card.css("a").attribute("href").value
        })
    end
    rosters
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    data = Nokogiri::HTML(html)

    info = {}
    data.css("div.vitals-container").each do |vital|

      info[:profile_quote] = vital.css("div.profile-quote").text

      # binding.pry
    end

    social = data.css("div.vitals-container").css("div.social-icon-container a")
    social.each do |soc_link|
      if soc_link.attribute("href").value.start_with?("https://twitter.com/")
        info[:twitter] = soc_link.attribute("href").value
      elsif soc_link.attribute("href").value.start_with?("https://www.linkedin.com")
        info[:linkedin] = soc_link.attribute("href").value
      elsif soc_link.attribute("href").value.start_with?("https://github.com/")
        info[:github] = soc_link.attribute("href").value
      else
        info[:blog] = soc_link.attribute("href").value
      end
    end

    info[:bio] = data.css("div.details-container").css("div.description-holder p").text

    # binding.pry

    info
  end

end
