# frozen_string_literal: true

require 'argon2'
require 'bcrypt'
require 'benchmark'
require 'json'

password_short = 'supers3c586ecret2209password'
password_long = '3c586c97649052209960f6d6919d2ca4dce5d4c87de486bcdaf9ef0ce60526f7866c1fab48ce403730fb36602749129f95b1439684fae807352eedfc26bdd081'
result = {
  time_bcrypt: {
    password_short: {
      cost: {}
    },
    password_long: {
      cost: {}
    }
  },
  time_argon2: {
    password_short: {
      cost: {}
    },
    password_long: {
      cost: {}
    }
  }
}

cost_factors = [10, 12, 14, 16]
cost_factors.each do |cost|
  time_bcrypt_short = Benchmark.measure do
    BCrypt::Password.create(password_short, cost: cost)
  end
  result[:time_bcrypt][:password_short][:cost][cost] = time_bcrypt_short.real
  time_bcrypt_long = Benchmark.measure do
    BCrypt::Password.create(password_long, cost: cost)
  end
  result[:time_bcrypt][:password_long][:cost][cost] = time_bcrypt_long.real
end

cost_factors.each do |cost|
  argon2 = Argon2::Password.new(t: cost)
  time_argon2_short = Benchmark.measure do
    argon2.create(password_short)
  end
  result[:time_argon2][:password_short][:cost][cost] = time_argon2_short.real
  time_argon2_long = Benchmark.measure do
    argon2.create(password_long)
  end
  result[:time_argon2][:password_long][:cost][cost] = time_argon2_long.real
end

File.open('benchmark_ruby_bcrypt_argon2.json', 'w') { |f| f.write(JSON.generate(result)) }

puts result
