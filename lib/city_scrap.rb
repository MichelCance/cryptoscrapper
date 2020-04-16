require 'nokogiri'
require 'open-uri'  # Obligatoire avec nokogiri pour charger une page sur le web

def init_nokogiri(url)
    print "."
    page = Nokogiri::HTML(open(url))
    return page
end

def main
    page = init_nokogiri("https://annuaire-des-mairies.com/val-d-oise.html")
    if page != nil
        cities_xpath = '//a[@class="lientxt"]'
        cities_nbr = page.xpath(cities_xpath).length
        cities_array = array_creation(page, cities_xpath, cities_nbr)
    puts cities_array
    end
end

def email_scrap(email_link_page, n, cities_nbr)
    page = init_nokogiri(email_link_page)
    if page != nil
        email_xpath = '/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]'
        return page.xpath(email_xpath).text
    end
end

def array_creation(page, cities_xpath, cities_nbr)
        cities_array = Array.new
        (0..cities_nbr-1).each { |n|
            cities_hash = Hash.new
            cities = page.xpath(cities_xpath)[n].text.downcase 
            link = page.xpath(cities_xpath)[n]['href'].gsub(/^[\.]/, '')
            link = "https://annuaire-des-mairies.com#{link}"
            cities_hash[cities] = email_scrap(link, n, cities_nbr)

            cities_array << cities_hash
            #puts "Le hash #{hash_tmp} a été ajouté dans le tableau array_mairies"
        }
        return cities_array
end

main