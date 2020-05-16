require 'psych'

module CBRAContracts
  class OpenApiGenerator
    def initialize(contract:)
      @contract = contract
    end

    def spec
      {
        'openapi' => '3.0.0',
        'servers' => [{
          'description' => '',
          'url' => '',
        }],
        'paths' => @contract.to_h
      }
    end

    def generate
      # TODO: Write to a real file/directory
      File.open('openapi.yml', 'w') do |file|
        file.write(spec.to_yaml)
      end
    end
  end
end
