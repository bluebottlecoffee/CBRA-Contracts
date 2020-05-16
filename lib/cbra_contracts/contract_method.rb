# frozen_string_literal: true

module CBRAContracts
  class ContractMethod
    attr_accessor :name, :http_method, :description
    attr_reader :parameters

    def initialize(name:, http_method:, description:, params: [])
      @name = name
      @http_method = http_method
      @description = description
      @params = params
    end

    def path
      "/#{name}"
    end

    def to_h
      {
        "#{http_method}" => {
          'summary' => description,
          'requestBody' => {
            'content' => {
              'application/json' => {
                'schema' => {
                  # TODO: Add parameters and return type
                },
              },
            },
          },
        },
      }
    end
  end
end
