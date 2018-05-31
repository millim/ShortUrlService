class HomeApi < Grape::API

  content_type :json, 'application/json'
  format :json

  desc 'use key'
  params do
    requires :key, type: String, desc: 'key'
  end
  get '/:key' do
    error!('Not Found', 404) if params[:key].length >8
    params[:key] = params[:key].downcase
    url = ShortUrl.find_url_by_key params[:key]
    if url.nil?
      return redirect(BLANK_KEY_URL) if BLANK_KEY_URL
      error!('Not Found', 404)
    else
      redirect(url)
    end
  end

end