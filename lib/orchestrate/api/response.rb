require 'forwardable'

module Orchestrate::API
  class Response

    extend Forwardable
    def_delegators :@response, :status, :body, :headers, :success?, :finished?, :on_complete

    attr_reader :request_id
    attr_reader :request_time

    def initialize(faraday_response)
      @response = faraday_response
      @request_id = headers['X-Orchestrate-Req-Id']
      @request_time = Time.parse(headers['Date'])
    end

  end

  class ItemResponse < Response
    attr_reader :location
    attr_reader :ref

    def initialize(faraday_response)
      super(faraday_response)
      @location = headers['Content-Location'] || headers['Location']
      @ref = headers.fetch('Etag','').gsub('"','')
    end
  end

  class CollectionResponse < Response
    attr_reader :count
    attr_reader :total_count
    attr_reader :results
    attr_reader :next_link
    attr_reader :prev_link

    def initialize(faraday_response)
      super(faraday_response)
      @count = body['count']
      @total_count = body['total_count']
      @results = body['results']
      @next_link = body['next']
      @prev_link = body['prev']
    end
  end
end