class Api < Grape::API
  mount ShortUrlApi
  mount HomeApi
end




