#处理html跨域问题
class HeaderData
  def initialize(app)
    @app = app
  end

  def call(env)
    status, header, body = @app.call(env)
    begin
      if !env['QUERY_STRING'].nil? && env['QUERY_STRING'].include?('ajax_data')
        data = Hash[env['QUERY_STRING'].split('&').map{|u| u.split('=')}]
        if data['ajax_data'].to_i == 10
          header['Access-Control-Allow-Origin'] = '*'
          header['Access-Control-Allow-Methods']= 'GET, POST, PUT, DELETE, OPTIONS'
        end
      end
    rescue => e
      puts "#{Time.now}------#{e}"
    end
    [status, header, body]
  end

end

class Start
  def initialize
    @filenames = ['', '.html', 'index.html', '/index.html']
    @rack_static = ::Rack::Static.new(
      lambda { [404, {}, []] },
      root: File.expand_path('../../public', __FILE__),
      urls: ['/']
    )
  end

  def self.instance
    @instance ||= Rack::Builder.new do

      use HeaderData

      map '/views' do
        run Start.new
      end

      map '/' do
        # use Rack::Auth::Basic, "简单加密方式" do |username, password|
        #   username == '666' && password == 'otl'
        # end
        run Api
      end



    end.to_app
  end

  def call(env)
    request_path = env['PATH_INFO']
    response = []
    @filenames.each do |path|
      response = @rack_static.call(env.merge('PATH_INFO' => request_path + path))
      return response if response[0] != 404
    end
    response
  end
end


