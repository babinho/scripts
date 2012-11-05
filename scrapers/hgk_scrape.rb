#encoding: utf-8
require "rubygems"
require 'open-uri'
require 'nokogiri'
require "json"
  module Scraper

    def Scraper.get_links
      page = Nokogiri::HTML(open('http://www2.hgk.hr/izvoznici/?q=d.d').read)
      ul = page.xpath('//ul[@class="nabrajanje nabrajanje-glavna"]')
      list = ul.css('li')
      list.collect {|l| "http://www2.hgk.hr/izvoznici/#{l.css('a').attr('href')}"}
    end

    def Scraper.parse(uri)
      p = Nokogiri::HTML(open(uri).read)
      main_div = p.xpath("//div[@id='sadrzaj']")
      naz = main_div.css('div.naziv-firme').first
      naziv_firme = naz.text
      addr = naz.next_element
      address = addr.text
      cty = addr.next_element
      city = cty.text
      begin
        mbs = main_div.search("[text()*='MB:']").first.next.text
      rescue
        mbs = ""
      end
      begin
        county = main_div.search("[text()*='Županija:']").first.next.text
      rescue
        county = ""
      end
      begin
        phone = main_div.search("[text()*='Telefon:']").first.next.text
      rescue
        phone = ""
      end
      begin
        fax = main_div.search("[text()*='Telefax:']").first.next.text
      rescue
        fax = ""
      end
      begin
        email = main_div.search("[text()*='E-mail:']").first.next.text
      rescue
        email = ""
      end
      begin
        www = main_div.search("[text()*='Web:']").first.next.text
      rescue
        www = ""
      end



      {naziv: strip_or_self!(naziv_firme),
        address: strip_or_self!(address),
        city: strip_or_self!(city),
        mbs: strip_or_self!(mbs),
        county: strip_or_self!(county),
        phone: strip_or_self!(phone),
        email: strip_or_self!(email),
        fax: strip_or_self!(fax),
        www: strip_or_self!(www)}
      rescue OpenURI::HTTPError
        return nil
    end
    def Scraper.process
      links = []
      Scraper.get_links.each do |l|
        begin
          links << Scraper.parse(l)
        end
      end
      JSON.pretty_generate(links.reject(&:nil?))
    end
    def self.strip_or_self!(str)
      str.strip! || str if str
    end
  end
puts Scraper.process
