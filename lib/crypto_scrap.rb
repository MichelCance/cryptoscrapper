require 'nokogiri'
require 'open-uri'  # Obligatoire avec nokogiri pour charger une page sur le web


def init_nokogiri(url)
    page = Nokogiri::HTML(open(url))
    return page
end

def main
    page = init_nokogiri("https://coinmarketcap.com/all/views/all/")
    if page != nil
        symbol_xpath = '//div[@class="cmc-table__table-wrapper-outer"]/div/table/tbody/tr[@class="cmc-table-row"]/td[contains(@class, "symbol")]'
        price_xpath = '//div[@class="cmc-table__table-wrapper-outer"]/div/table/tbody/tr[@class="cmc-table-row"]/td[contains(@class, "price")]'
        symbol_nbr = page.xpath(symbol_xpath).length
        crypto_array = array_creation(page, symbol_xpath, price_xpath, symbol_nbr)
       	puts crypto_array
    end
end

def array_creation(page, symbol_xpath, price_xpath, symbol_nbr)
        crypto_array = Array.new
        (0..symbol_nbr-1).each { |n|
            crypto_hash = Hash.new
            crypto_hash[page.xpath(symbol_xpath)[n].text] = page.xpath(price_xpath)[n].text 
            crypto_array << crypto_hash
        }
        return crypto_array
end

main