class Cache
  attr_accessor :max_size

  class << self
    def serialize cache
      error_ptr = Pointer.new(:object)
      NSJSONSerialization.dataWithJSONObject([
        cache.instance_variable_get('@data'),
        cache.max_size], options: 0, error: error_ptr)
    end
    def restore serialized
      cache = Cache.new(20)
      if serialized
        begin
          data = serialized.dataUsingEncoding(4, allowLossyConversion:false)
          error_ptr = Pointer.new(:object)
          data, max = NSJSONSerialization.JSONObjectWithData(data, options: 1|2|4, error: error_ptr)
          if data
            cache.instance_variable_set('@data', data)
            cache.max_size = max
          end
        rescue
        end
      end
      cache
    end
  end

  def initialize max_size=4
    @data = {}
    @max_size = max_size
  end

  def store key, value
    @data.store key, [0, value]
    age_keys
    prune
  end

  def read key
    if value = @data[key]
      renew(key)
      age_keys
    end
    value
  end

  private # -------------------------------

  def renew key
    @data[key][0] = 0
  end

  def delete_oldest
    m = @data.values.map{ |v| v[0] }.max
    @data.reject!{ |k,v| v[0] == m }
  end

  def age_keys
    @data.each{ |k,v| @data[k][0] += 1 }
  end

  def prune
    delete_oldest if @data.size > @max_size
  end
end
