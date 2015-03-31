module Orchestrate::Search
  # Aggregate Builder object for constructing aggregate params included in a search
  class AggregateBuilder

    # @return [QueryBuilder]
    attr_reader :builder

    # @return [Array] Aggregate param arguments
    attr_reader :aggregates

    extend Forwardable

    # Initialize a new AggregateBuilder object
    # @param builder [Orchestrate::Search::SearchBuilder] The Search Builder object
    def initialize(builder)
      @builder = builder
      @aggregates = []
    end

    def_delegator :@builder, :options
    def_delegator :@builder, :order
    def_delegator :@builder, :limit
    def_delegator :@builder, :offset
    def_delegator :@builder, :aggregate
    def_delegator :@builder, :find
    def_delegator :@builder, :collection

    # @return Pretty-Printed string representation of the AggregateBuilder object
    def to_s
      "#<Orchestrate::Search::AggregateBuilder collection=#{collection.name} query=#{builder.query} aggregate=#{to_param}>"
    end
    alias :inspect :to_s

    # @return constructed aggregate string parameter for search query
    def to_param
      aggregates.map {|agg| agg.to_param }.join(',')
    end

    # @!group Aggregate Functions

    # @param field_name [#to_s]
    # @param offset [Integer, nil]
    # @param limit [Integer, nil]
    # @return [AggregateBuilder]
    def top_values(field_name, offset = nil, limit = nil)
      topValues = TopValuesBuilder.new(self, "#{field_name}", offset, limit)
      aggregates << topValues
      topValues
    end

    # @param field_name [#to_s]
    # @return [AggregateBuilder]
    def stats(field_name)
      stat = StatsBuilder.new(self, "#{field_name}")
      aggregates << stat
      stat
    end

    # @param field_name [#to_s]
    # @return [RangeBuilder]
    def range(field_name)
      rng = RangeBuilder.new(self, "#{field_name}")
      aggregates << rng
      rng
    end

    # @param field_name [#to_s]
    # @return [DistanceBuilder]
    def distance(field_name)
      dist = DistanceBuilder.new(self, "#{field_name}")
      aggregates << dist
      dist
    end

    # @param field_name [#to_s]
    # @return [TimeSeriesBuilder]
    def time_series(field_name)
      time = TimeSeriesBuilder.new(self, "#{field_name}")
      aggregates << time
      time
    end
    # @!endgroup
  end

  # Stats Builder object for constructing top-values functions to be included in the aggregate param
  class TopValuesBuilder

    # @return [AggregateBuilder]
    attr_reader :builder

    # @return [#to_s] The field to operate over
    attr_reader :field_name

    # @return [Integer,nil] The zero-based index of the first paged value to retrieve in this aggregation.
    # If omitted, uses the server default value of zero.
    attr_reader :offset

    # @return [Integer,nil] The maximum number of values to retrieve per page of results for this aggregation.
    # If omitted, uses the server default value of ten.
    attr_reader :limit

    extend Forwardable

    # Initialize a new TopValuesBuilder object
    # @param builder [AggregateBuilder] The Aggregate Builder object
    # @param field_name [#to_s]
    # @param offset
    # @param limit
    def initialize(builder, field_name, offset, limit)
      @builder = builder
      @field_name = field_name
      if offset.nil? ^ limit.nil?
        raise "offset and limit arguments can only be supplied together, or not at all"
      end
      @offset = offset
      @limit = limit
    end

    def_delegator :@builder, :options
    def_delegator :@builder, :order
    def_delegator :@builder, :limit
    def_delegator :@builder, :offset
    def_delegator :@builder, :aggregate
    def_delegator :@builder, :find
    def_delegator :@builder, :top_values
    def_delegator :@builder, :stats
    def_delegator :@builder, :range
    def_delegator :@builder, :distance
    def_delegator :@builder, :time_series
    def_delegator :@builder, :collection

    # @return [#to_s] Pretty-Printed string representation of the TopValuesBuilder object
    def to_s
      "#<Orchestrate::Search::TopValuesBuilder collection=#{collection.name} field_name=#{field_name} offset=#{offset} limit=#{limit}>"
    end
    alias :inspect :to_s

    # @return [#to_s] constructed aggregate string clause
    def to_param
      if offset.nil? && limit.nil?
        "#{field_name}:top_values"
      else
        "#{field_name}:top_values:offset:#{offset}:limit:#{limit}"
      end
    end
  end

  # Stats Builder object for constructing stats functions to be included in the aggregate param
  class StatsBuilder

    # @return [AggregateBuilder]
    attr_reader :builder

    # @return [#to_s] The field to operate over
    attr_reader :field_name

    extend Forwardable

    # Initialize a new RangeBuilder object
    # @param builder [AggregateBuilder] The Aggregate Builder object
    # @param field_name [#to_s]
    def initialize(builder, field_name)
      @builder = builder
      @field_name = field_name
    end

    def_delegator :@builder, :options
    def_delegator :@builder, :order
    def_delegator :@builder, :limit
    def_delegator :@builder, :offset
    def_delegator :@builder, :aggregate
    def_delegator :@builder, :find
    def_delegator :@builder, :top_values
    def_delegator :@builder, :stats
    def_delegator :@builder, :range
    def_delegator :@builder, :distance
    def_delegator :@builder, :time_series
    def_delegator :@builder, :collection

    # @return Pretty-Printed string representation of the StatsBuilder object
    def to_s
      "#<Orchestrate::Search::StatsBuilder collection=#{collection.name} field_name=#{field_name}>"
    end
    alias :inspect :to_s

    # @return [#to_s] constructed aggregate string clause
    def to_param
      "#{field_name}:stats"
    end
  end

  # Range Builder object for constructing range functions to be included in the aggregate param
  class RangeBuilder

    # @return [AggregateBuilder]
    attr_reader :builder

    # @return [#to_s] The field to operate over
    attr_reader :field_name

    # @return [#to_s] The range sets
    attr_reader :ranges

    extend Forwardable

    # Initialize a new RangeBuilder object
    # @param builder [AggregateBuilder] The Aggregate Builder object
    # @param field_name [#to_s]
    def initialize(builder, field_name)
      @builder = builder
      @field_name = field_name
      @ranges = ''
    end

    def_delegator :@builder, :options
    def_delegator :@builder, :order
    def_delegator :@builder, :limit
    def_delegator :@builder, :offset
    def_delegator :@builder, :aggregate
    def_delegator :@builder, :find
    def_delegator :@builder, :top_values
    def_delegator :@builder, :stats
    def_delegator :@builder, :range
    def_delegator :@builder, :distance
    def_delegator :@builder, :time_series
    def_delegator :@builder, :collection

    # @return Pretty-Printed string representation of the RangeBuilder object
    def to_s
      "#<Orchestrate::Search::RangeBuilder collection=#{collection.name} field_name=#{field_name} ranges=#{ranges}>"
    end
    alias :inspect :to_s

    # @return [#to_s] constructed aggregate string clause
    def to_param
      "#{field_name}:range:#{ranges}"
    end

    # @param x [Integer]
    # @return [RangeBuilder]
    def below(x)
      @ranges << "*~#{x}:"
      self
    end

    # @param x [Integer]
    # @return [RangeBuilder]
    def above(x)
      @ranges << "#{x}~*:"
      self
    end

    # @param x [Integer]
    # @param y [Integer]
    # @return [RangeBuilder]
    def between(x, y)
      @ranges << "#{x}~#{y}:"
      self
    end
  end

  # Distance Builder object for constructing distance functions for the aggregate param
  class DistanceBuilder < RangeBuilder

    # @return Pretty-Printed string representation of the DistanceBuilder object
    def to_s
      "#<Orchestrate::Search::DistanceBuilder collection=#{collection.name} field_name=#{field_name} ranges=#{ranges}>"
    end
    alias :inspect :to_s

    # @return [#to_s] constructed aggregate string clause
    def to_param
      "#{field_name}:distance:#{ranges}"
    end
  end

  # Time Series Builder object for constructing time series functions for the aggregate param
  class TimeSeriesBuilder

    # @return [AggregateBuilder]
    attr_reader :builder

    # @return [#to_s] The field to operate over
    attr_reader :field_name

    # @return [#to_s] The interval of time for the TimeSeries function
    attr_reader :interval

    extend Forwardable

    # Initialize a new TimeSeriesBuilder object
    # @param builder [AggregateBuilder] The Aggregate Builder object
    # @param field_name [#to_s] The field to operate over
    def initialize(builder, field_name)
      @builder = builder
      @field_name = field_name
      @interval = nil
      @time_zone = nil
    end

    def_delegator :@builder, :options
    def_delegator :@builder, :order
    def_delegator :@builder, :limit
    def_delegator :@builder, :offset
    def_delegator :@builder, :aggregate
    def_delegator :@builder, :find
    def_delegator :@builder, :top_values
    def_delegator :@builder, :stats
    def_delegator :@builder, :range
    def_delegator :@builder, :distance
    def_delegator :@builder, :time_series
    def_delegator :@builder, :collection

    # @return Pretty-Printed string representation of the TimeSeriesBuilder object
    def to_s
      "#<Orchestrate::Search::TimeSeriesBuilder collection=#{collection.name} field_name=#{field_name} interval=#{interval} time_zone=#{@time_zone}>"
    end
    alias :inspect :to_s

    # @return [#to_s] constructed aggregate string clause
    def to_param
      if @time_zone.nil?
        "#{field_name}:time_series:#{interval}"
      else
        "#{field_name}:time_series:#{interval}:#{@time_zone}"
      end
    end

    # Set time series interval to year
    # @return [AggregateBuilder]
    def year
      @interval = 'year'
      self
    end

    # Set time series interval to quarter
    # @return [AggregateBuilder]
    def quarter
      @interval = 'quarter'
      self
    end

    # Set time series interval to month
    # @return [AggregateBuilder]
    def month
      @interval = 'month'
      self
    end

    # Set time series interval to week
    # @return [AggregateBuilder]
    def week
      @interval = 'week'
      self
    end

    # Set time series interval to day
    # @return [AggregateBuilder]
    def day
      @interval = 'day'
      self
    end

    # Set time series interval to hour
    # @return [AggregateBuilder]
    def hour
      @interval = 'hour'
      self
    end

    # Use the designated time zone (e.g., "-0500" or "+0430") when calculating bucket boundaries
    # @param zone [String]
    # @return [RangeBuilder]
    def time_zone(zone)
      @time_zone = zone
      self
    end
  end
end