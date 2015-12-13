module TimekitApi
  class Client
    DOMAIN = 'https://api.timekit.io/'
    API_VERSION = 'v2'
    BASEURL = "#{DOMAIN}#{API_VERSION}/"
    @debugMode = false

    # where we keep our tokens
    User = Struct.new(:email,
                      :api_token,
                      :is_authenticated,
                      :timezone,
                      :password,
                      :first_name,
                      :last_name,
                      :last_sync,
                      :id,
                      :name,
                      :image,
                      :activated)

    def initialize(opts = {})

      if TimekitApi.config[:app_name].nil?
        fail(ArgumentError,"Must specify app name in TimekitApi.config")
      end

      # setup faraday
      @conn = Faraday.new(url: BASEURL) do |c|
        c.use FaradayMiddleware::ParseJson, content_type: 'application/json'
        c.use FaradayMiddleware::FollowRedirects, limit: 3
        c.use Faraday::Response::RaiseError
        c.use Faraday::Adapter::NetHttpPersistent

        if TimekitApi.config[:debug]
          c.use Faraday::Response::Logger, Logger.new('faraday.log')
        end
      end

      # configs for connection, these should be sane defaults
      @conn.headers['Timekit-App'] = TimekitApi.config[:app_name]
      @conn.headers['Timekit-OutputTimestampFormat'] = TimekitApi.config[:output_timestamp_format]

      # per instance timezones
      if opts[:timezone].nil?
        set_timezone(TimekitApi.config[:timezone])
      else
        set_timezone(opts[:timezone])
      end

      # initialize our user, but not authenticated yet.
      @user = User.new
      @user.is_authenticated = false
    end

    def set_user(body)
      body.each { |k, v| @user.send("#{k}=", v) if v }
    end

    def get_user
      @user
    end

    def auth(email, password)
      res = make_request('post', 'auth', [], { email: email, password: password })

      if res && res[:code] == 200
        set_user(res[:body]['data'])
        @user.is_authenticated = true
        @conn.basic_auth(@user.email, @user.api_token)
        return true
      else
        return false
      end
    end

    # => should be private
    #  method for make the call to Timekit API
    #
    #  @param $method
    #  @param $url
    #  @param array $params
    #  @param array $body
    #  @param bool $returnJson
    #  @return TimekitResponse
    #  @throws TimekitException
    #
    def make_request(method, url, params = [], body = [], _returnJson = true)
      if @user && @user.is_authenticated
        @conn.basic_auth(@user.email, @user.api_token)
      end

      response = @conn.send(method.to_sym) do |request|
        request.url url
        request.headers['Content-Type'] = 'application/json'
        request.body = body.to_json
        request.params = params
      end
      code = response.status
      body = response.body
      return { code: code, body: body }
    rescue Exception => e
      puts e
      raise e
    end

    # private
    def addHeader(*headers)
      headers.each { |k, v| @conn.headers[k] = v }
    end

    # private
    def append_id_to_resource(id = nil, path)
      path = id.nil? ? path : path + "/#{id}"
    end

    def set_timezone(timezone)
      addHeader(['Timekit-Timezone', timezone])
    end

    def findtime(emails, filters = nil, future = '2 days', length = '30 minutes')
      fail(ArgumentError, 'emails must be an array') if emails.class != Array
      fail(ArgumentError, 'more than one email') if emails.length == 0

      body = {
        emails: emails,
        future: future,
        length: length,
        filters: filters
      }

      make_request('post', 'findtime', [], body)
    end

    def accounts_google_calendars
      make_request('get', 'accounts/google/calendars')
    end

    def accounts_google_signup
      make_request('get', 'accounts/google/signup', [], [], false)
    end

    def get_accounts
      make_request('get', 'accounts')
    end

    def accounts_sync
      make_request('get', 'accounts/sync')
    end

    def get_calendars(id = nil, params = [])
      path = append_id_to_resource(id, 'calendars')
      make_request('get', path, params)
    end

    def get_contacts
      make_request('get', 'contacts')
    end

    def get_events(start_time, end_time)
      params = {
        start: start_time,
        end: end_time
      }
      make_request('get', 'events', params)
    end

    def get_events_availability(start_time, end_time, email)
      params = {
        start: start_time,
        end: end_time,
        email: email
      }
      make_request('get', 'events/availability', params)
    end

    def get_user_timezone(email)
      path = append_id_to_resource(email, '/users/timezone')
      make_request('get', path)
    end

    def create_event(start_time, end_time, what, where, participants, invite = false, calendar_id)
      body = {
        start: start_time,
        end: end_time,
        what: what,
        where: where,
        participants: participants,
        invite: invite,
        calendar_id: calendar_id
      }
      make_request('post', 'events', [], body)
    end

    def create_meeting(what, where, suggestions = [])
      body = {
        what: what,
        where: where,
        suggestion: suggestions
      }
      make_request('post', 'meetings', [], body)
    end

    def get_meetings(token = nil, params = [])
      path = append_id_to_resource(token, 'meetings')
      make_request('get', path, params)
    end

    def set_meeting_availability(suggestion_id, availability)
      body = {
        suggestion_id: suggestion_id,
        availability: availability
      }
      make_request('post', 'meetings/availability', [], body)
    end

    def book_meeting(suggestion_id)
      body = { suggestion_id: suggestion_id }
      make_request('post', 'meetings/book', [], body)
    end

    def edit_meeting(token, body)
      path = append_id_to_resource(token, 'meetings')
      make_request('put', path, [], body)
    end

    def me(params = [])
      make_request('get', 'users/me', params)
    end
    alias_method :current_user, :me
    alias_method :get_current_user, :me

    def create_user(email, first_name, last_name, password, timezone = nil)
      timezone = timezone.nil? ? TimekitApi.config[:timezone] : timezone
      body = {
        email:      email,
        first_name: first_name,
        last_name:  last_name,
        timezone:   timezone,
        password:   password
      }
      make_request('post', 'users', [], body)
    end

    def update_user(data)
      fail unless @user.is_authenticated # can't do this without a user.
      body = {
        first_name: data[:first_name] || @user.first_name,
        last_name: data[:last_name] || @user.last_name,
        password: data[:password] || @user.password,
        timezone: data[:timezone] || @user.timezone
      }

      # update our own instance value for our user.
      setUser(body)

      make_request('put', '/users/me', [], body)
    end

    def get_user_properties(id = nil)
      path = append_id_to_resource(id, 'properties')
      make_request('get', path)
    end

    def set_user_properties(key, value)
      body = { key: key, value: value }
      make_request('put', 'properties', [], body)
    end
  end
end
