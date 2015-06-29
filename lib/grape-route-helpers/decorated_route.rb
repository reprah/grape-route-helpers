module GrapeRouteHelpers
  # wrapper around Grape::Route that adds a helper method
  class DecoratedRoute
    attr_reader :route, :helper_names, :helper_arguments, :extension

    def initialize(route)
      @route = route
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

          content_type = attrs.delete(:format)
          path = '/' + path_segments_with_values(attrs).join('/')

          path + content_type
        end
      RUBY
      instance_eval method_body
    end

    def route_versions
      if route_version
        route_version.split('|')
      else
        [nil]
      end
    end

    def path_helper_name(opts = {})
      segments = path_segments_with_values(opts)

      name = if segments.empty?
               'root'
             else
               segments.join('_')
             end
      name + '_path'
    end

    def segment_to_value(segment, opts = {})
      options = HashWithIndifferentAccess.new(
        route_options.merge(opts)
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
        route_options[segment.to_sym]
      end
      dynamic_path_segments - segments_in_options
    end

    def optional_segments
      ['format']
    end

    def uses_segments_in_path_helper?(segments)
      requested = segments - optional_segments
      required = required_helper_segments

      if requested.empty? && required.empty?
        true
      else
        requested.all? do |segment|
          required.include?(segment)
        end
      end
    end

    # accessing underlying Grape::Route

    def route_path
      route.route_path
    end

    def route_options
      route.instance_variable_get(:@options)
    end

    def route_version
      route.route_version
    end

    def route_namespace
      route.route_namespace
    end
  end
end
