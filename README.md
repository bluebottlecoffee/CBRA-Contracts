# Component Based Rails Application (CBRA) Contracts

## Introduction

Many Rails applications start simply enough. A generator command here, a
migration there and soon enough, you've got a working application. Some end up
as a [Majestic Monolith](https://m.signalvnoise.com/the-majestic-monolith/).

As some applications grow, and new developers come and go they can drift from
"Majestic" and become more and more challenging to work in. God objects, tightly
coupled models and a lack of clear boundaries creep up seemingly overnight and
now what you thought was a small change can trigger a host of test failures.

At this point, a common solution is to reach for microservices. Smaller, domain
specific applications that are deployed independently sound great! The tradeoffs
being that you now have a new problem to worry about - the network. What calls
can fail and where, retry policies and latency are now brought to the forefront.
Deployment infrastructure, more complicated CI/CD pipelines, complicated local
environments are all potential pitfalls of a microservice architecture.

Another alternative is to break your monolith into modular "components." These
components are still built and deployed together but offer a more clear
separation of domain-specific functionality.

CBRA Contracts aims to help guide the transition from a less-than-majestic
monolith to a collection of clearly separated functionality with distinct
boundaries and ... contracts.

## How it Works

CBRA Contracts provides a DSL and "convention over configuration" approach to
define contract interfaces between application components. These contracts serve
to define a public interface for a component while hiding all implementation
details.

If a developer needs to use a functional component, she needs to look no further
than the contract to see what methods are available, what arguments need to be
passed and what return type she can expect.

This also allows for fearless refactoring of implementation code _inside_ of the
component. As long as the contract is fulfilled, any implementation is safe to
refactor or swap altogether.

### Usage

In your component Gemfile, include `gem 'cbra_contracts'` or in your `.gemspec`
include `spec.runtime_dependency 'cbra_contracts'`.

### Example

Let's define a contract!

```ruby
# A sample `Weather` component of our application

# weather/lib/contract.rb
module Weather
  extend CBRAContracts::DSL
  
  define_contract 'Weather', 'Provides weather lookups and predictions' do

    contract_method :lookup, 'Lookup the current weather of a location' do |m|
      m.param :postal_code, :string, 'Postal code of the weather request'
      m.param :time_of_day, :int, 'The time of day, in seconds'
      m.produces WeatherReport
    end

  end
end
```

Our Weather component now has a public interface that provides one method,
`lookup` and promises to return a `WeatherReport` provided that the caller
also adheres to the contract and provides arguments for `:postal_code` and
`:time_of_day`.

By convention, the implementation of the lookup should live in the
`weather/lib/weather/lookup.rb` class.

```ruby
# weather/lib/weather/lookup.rb

module Weather
  class Lookup
    def call(postal_code:, time_of_day:)
      ## implementation goes here
      
      WeatherReport.new(88, 'Sunny')
    end
  end
  
  class WeatherReport
    attr_reader :degrees, :description
    
    def initialize(degrees, description)
      @degrees = degrees
      @description = description
    end
  end
end
```

This can be overriden in the contract method definition block by setting
`m.implementation = MyCustomImplementationClass.new`.

## Future Goals

* Contract test stubs
* Documentation generation
* OpenAPI spec generation
* Rack endpoint routing

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/bluebottlecoffee/cbra_contracts. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[AGPL License](https://www.gnu.org/licenses/agpl-3.0.en.html).

## Code of Conduct

Everyone interacting in the CbraContracts project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/bluebottlecoffee/cbra_contracts/blob/master/CODE_OF_CONDUCT.md).
