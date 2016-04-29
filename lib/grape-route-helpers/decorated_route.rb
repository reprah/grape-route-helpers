module GrapeRouteHelpers
  # wrapper around Grape::Route that adds a helper method
  class DecoratedRoute
    attr_reader :route, :helper_names, :helper_arguments,
                :extension, :route_options

    def self.sanitize_method_name(string)
      string.gsub(/\W|^[0-9]/, '_')
    end

    def initialize(route)
      @route = route
      @route_options = route.options
      @helper_names = []
      @helper_arguments = required_helper_segments
      @extension = default_extension
      define_path_helpers
    end

    def default_extension
      pattern = /\((\.\:?\w+)\)$/
      match = route_path.match(pattern)
      return '' unless match
      ext = match.captures.first
      if ext == '.:format'
        ''
      else
        ext
      end
    end

    def define_path_helpers
      route_versions.each do |version|
        route_attributes = { version: version, format: extension }
        method_name = path_helper_name(route_attributes)
        @helper_names << method_name
        define_path_helper(method_name, route_attributes)
      end
    end

    def define_path_helper(method_name, route_attributes)
      method_body = <<-RUBY
        def #{method_name}(attributes = {})
          attrs = HashWithIndifferentAccess.new(
            #{route_attributes}.merge(attributes)
          )

          query_params = attrs.delete(:params)
          content_type = attrs.delete(:format)
          path = '/' + path_segments_with_values(attrs).join('/')

          path + content_type + query_string(query_params)
        end
      RUBY
      instance_eval method_body
    end

    def query_string(params)
      if params.nil?
        ''
      else
        '?' + params.to_param
      end
    end

    def route_versions
      version_pattern = /[^\[",\]\s]+/
      if route_version
        route_version.scan(version_pattern)
      else
        [nil]
      end
    end

    def path_helper_name(opts = {})
      if route_options[:as]
        name = route_options[:as].to_s
      else
        segments = path_segments_with_values(opts)

        name = if segments.empty?
                 'root'
               else
                 segments.join('_')
               end
      end

      sanitized_name = self.class.sanitize_method_name(name)
      sanitized_name + '_path'
    end

    def segment_to_value(segment, opts = {})
      options = HashWithIndifferentAccess.new(
        route.options.merge(opts)
      )

      if dynamic_segment?(segment)
        key = segment.slice(1..-1)
        options[key]
      else
        segment
      end
    end

    def path_segments_with_values(opts)
      segments = path_segments.map { |s| segment_to_value(s, opts) }
      segments.reject(&:blank?)
    end

    def path_segments
      pattern = %r{\(/?\.:?\w+\)|/|\*}
      route_path.split(pattern).reject(&:blank?)
    end

    def dynamic_path_segments
      segments = path_segments.select do |segment|
        dynamic_segment?(segment)
      end
      segments.map { |s| s.slice(1..-1) }
    end

    def dynamic_segment?(segment)
      segment.start_with?(':')
    end

    def required_helper_segments
      segments_in_options = dynamic_path_segments.select do |segment|
        route.options[segment.to_sym]
      end
      dynamic_path_segments - segments_in_options
    end

    def special_keys
      %w(format params)
    end

    def uses_segments_in_path_helper?(segments)
      segments = segments.reject { |x| special_keys.include?(x) }

      if required_helper_segments.empty? && segments.any?
        false
      else
        required_helper_segments.all? { |x| segments.include?(x) }
      end
    end

    def route_path
      route.path
    end

    def route_version
      route.version
    end

    def route_namespace
      route.namespace
    end

    def route_method
      route.request_method
    end
  end
end
