# frozen_string_literal: true

module CBRAContracts
  class ContractMethod
    attr_accessor :name, :path, :description
    attr_reader :parameters

    def initialize(name:, path:, description:, params: [])
      @name = name
      @path = path
      @description = description
      @params = params
    end
  end
end
