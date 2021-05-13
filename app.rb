require 'sinatra'
require_relative 'algorithms'

get '/' do
  @t = 1
  @p = 1
  @s = nil

  @pos = [
    [1, 1, 1, 1].join(",")
  ].join(";")

  @neg = [
    [0, 0, 0, 0].join(",")
  ].join(";")

  @ch = [
    [1, '-', '-', 1].join(","),
    [1, 0, 0, 0].join(","),
    ['-', '-', 1, '-', '-'].join(",")
  ].join(";")

  erb :index
end

post '/calc' do
  T = params['T'].to_i
  P = params['P'].to_i
  S = params['S'].to_i

  POS = convert_text_to_array(params['POS'])

  NEG = convert_text_to_array(params['NEG'])

  CH = convert_text_to_array(params['CH'])

  @result = calc(T, POS, NEG, P, S, CH)

  erb :result
end
