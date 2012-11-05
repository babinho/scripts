# Scrapes Arukone puzzles from menneske.no
# If you Call the script without parameters it will tell you what to do.
# Author: Berislav Babic
# Licence: MIT
require 'open-uri'
require 'nokogiri'
class ArukoneScrape
  def self.read_arukone(id, link)
    page = Nokogiri::HTML(open(link).read)
    rows = page.xpath("//div[@class='arukone']/table/tr")
    puzzle_id = id
    hardness = page.xpath("//div[@class='arukone']").xpath("//text()").map {|x| x if x.to_s =~ /Difficulty/}.reject(&:nil?).first().to_s
    hardness = hardness[12, hardness.length - 12 ].downcase
    output = []
    r,c = 0,0
    rows.each do |row|
      row.xpath('td').each do |column|
        if column.child
          output << "#{puzzle_id},#{hardness},#{column.child.to_s},#{r},#{c}"
        end
        c += 1
      end
      c = 0
      r += 1
    end
    output
  end

  def self.read(size, nstart, nend)
    case size.to_i
    when 5
      link = 'http://www.menneske.no/arukone/5x5/eng/?number='
    when 9
      link = 'http://www.menneske.no/arukone/eng/?number='
    else
      puts "First parameter must be 5 or 9 for the size of the grid you are scraping"
      return nil
    end
    out = []
    numbers = [*nstart..nend]
    while a = numbers.shift(100)
      break if a.size == 0
      a.each do |n|
        l = link + n.to_s
        out += read_arukone(n, l)
      end
      sleep 5
    end
    out
  end

  def self.write_file(arr, size)
    f = File.open("arukone_#{size.to_s}x#{size.to_s}.csv", 'w')
    arr.each do |line|
      f.write line + "\n"
    end
    f.close
  end
end



def scraper(args)
  if args.length != 3
    puts "The program is called with the following arguments: grid_size(5 or 9) starting_puzzle(eg. 1) ending_puzzle(eg. 1434)\n
    $> ruby arukone_scrape.rb 5 1 1434"
    return
  end
  out = ArukoneScrape.read(args[0], args[1], args[2])
  ArukoneScrape.write_file(out, args[0]) if out.size != 0
  puts "All done, have a nice day!"
end

scraper(ARGV)
