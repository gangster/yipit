require 'faraday'
require 'faraday_middleware'
require 'core_ext/array'

module Yipit
  class Client
    attr_reader :api_key, :conn

    # Initialize the client.
    # TODO:  Document.
    def initialize(*args)
      options = args.extract_options!
      version = 'v1'
      @api_key = args[0]
      @conn = Faraday.new(:url => "http://api.yipit.com/#{version}") do |builder|
        builder.adapter Faraday.default_adapter
        builder.use Faraday::Response::Logger if options[:debug] == true
        builder.use Faraday::Response::Mashify
        builder.use Faraday::Response::ParseJson
      end
    end

    # @overload deals(options={})
    #   Search for Deals
    #   @param [Hash] options A customizable set of options
    #   @option options [String] :lat Latitude of point to to sort deals by proximity to. Use with lon.  Uses radius.
    #   @option options [String] :lon Longitude of point to to sort deals by proximity to. Use with lat.  Uses radius.
    #   @option options [Fixnum] :radius Maximum distance of radius in miles to deal location from center point. Defaults to 10. Requires lat and lon
    #   @option options [String] :divisions One or more division slugs (comma separated). See Divisions API for more details.
    #   @option options [String] :source One or more source slugs (comma separated). See Sources API for more details.
    #   @option options [String] :phone Deals available at a business matching one of the phone numbers. See Businesses API for more details.
    #   @option options [String] :tag One or more tag slugs (comma separated). See Tags API for more details. Note: Specifying multiple tags returns deals matching any one of the tags, NOT all of them
    #   @option options [Boolean] :paid Shows deals filtered on paid status.  Defaults to false. Set to true if you would like to see all deals.
    #   @return [Array] An array of Hashie::Mash objects representing Yipit deals
    #   @example Search deals by latitude and longitude
    #       client.deals(:lat => "-37.74", :lon => "-76.00")
    #   @example Search deals within a 2 miles radius of latitude and longitude
    #       client.deals(:lat => "-37.74", :lon => "-76.00", :radius => 2)
    #   @example Search deals from Groupon
    #       client.deals(:source => "Groupon")
    #   @example Search deals based on phone number
    #       client.deals(:phone => "7185551212")
    #   @example Search deals based on tags
    #       client.deals(:tag => "restaurants,spa")
    #   @example Search deals based on paid status. (Defaults to false)
    #       client.deals(:paid => true)
    # @overload deals(deal_id)
    #   Get deal details
    #   @param [Fixnum] deal_id A Deal Id
    #   @return [Hashie::Mash] A Hashie::Mash object representing a Yipit deal
    def deals(params=nil)
      # so user can search for deals with no conditionals
      if params.nil?
        response = @conn.get("deals") { |req| req.params = { :key => @api_key } }
        response.body.response.deals
      # so user can search for deals with conditions
      elsif params.is_a? Hash
        params.merge!({:key => @api_key})
        response = @conn.get("deals") { |req| req.params = params }
        response.body.response.deals
      # so user can search for specific deal by id with same method
      elsif params.is_a? Fixnum
        id = params
        response = @conn.get('deals/#{id}') { |req| req.params = { :key => @api_key } }
        response.body.response.deals[0]
      end
    end

    # @overload sources(options={})
    #   Search for sources
    #   @param [Hash] options A customizable set of options
    #   @option options [String] :division One or more division slugs. See Divisions API for more details. Note: Specifying multiple divisions returns sources that exist in either of the divisions, NOT all of them.
    #   @option options [String] :paid When paid is true, only paid sources are returned. Defaults to false.
    # @overload sources(source_id)
    #   Get source details
    #   @param [String] slug A source slug
    #   @return [Hashie::Mash] A Hashie::Mash object representing a Yipit Deal Source
    def sources(*args)
      super
    end

    # @overload tags(options={})
    #   This method returns a list of all tags. There are no parameters specific to tags.
    #   @param [Hash] options A customizable set of options
    #   @return [Array] An array of Hashie::Mash objects representing Yipit tags.
    def tags(*args)
      super
    end

    def divisions(params={})
      params.merge!({:key => @api_key})
      response = @conn.get('deals') { |req| req.params = params }
    end

    def businesses(*args)
      super
    end

    def method_missing(sym, *args, &block)
      options = args.extract_options!.merge(:key => api_key)
      response = conn.get("/v1/#{sym.to_s}/#{args[0]}") { |req| req.params = options  }
      ret = response.body.response.send sym
      args[0].nil? ? ret : ret.first if ret
    end
  end
end
