require 'psych'

module CBRAContracts
  class OpenApiGenerator
    def initialize(contract:)
      @contract = contract
    end

    def to_h
      {
        'openapi' => '3.0.0',
        'servers' => [{
          'description' => '',
          'url' => '',
        }],
        'paths' => @contract.to_h
      }
    end

    def write
      # Write to a real file/directory
      File.open('openapi.yml', 'w') do |file|
        file.write(to_h.to_yaml)
      end
    end
  end
end
