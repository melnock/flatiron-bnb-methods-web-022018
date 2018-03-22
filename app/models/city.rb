class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(span_start, span_end)
    span_start_date = Date.parse(span_start)
    span_end_date = Date.parse(span_end)
    span = (span_start_date..span_end_date).to_a
    self.listings.select do |listing|
      listing_arr = []
      listing.reservations.map do |res|
        listing_arr << [res.checkin, res.checkout]
      end
      res_dates = listing_arr.flatten
      !span.any?{|el| res_dates.include?(el)}
    end
  end

  def self.highest_ratio_res_to_listings
    cities = City.all
    hash = {}
    cities.map do |city|
      listing_total = city.listings.count
      res_total = 0
      city.listings.each do |listing|
        res_total = listing.reservations.count + res_total
      end
      hash[city] = (res_total.to_f / listing_total)
    end
    hash.max_by{|k,v| v}[0]
  end

  def self.most_res
    cities = City.all
    hash = {}
    cities.map do |city|
      res_total = 0
      city.listings.each do |listing|
        res_total = listing.reservations.count + res_total
      end
      hash[city] = res_total
    end
    hash.max_by{|k,v| v}[0]
  end

end
