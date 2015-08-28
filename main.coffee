
EVENTS = "blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup  mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error"

uuid = ->
    #https://gist.github.com/bmc/1893440
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else (r & 0x3|0x8)
        v.toString(16)
    )

get_params = ->
    # https://stelfox.net/blog/2013/12/access-get-parameters-with-coffeescript/
    params = {}
    query = window.location.search.substring(1)
    raw_vars = query.split("&")

    for v in raw_vars
        [key, val] = v.split("=")
        params[key] = decodeURIComponent(val)

    params

set_interval = (ms, func) -> setInterval func, ms


$ ->
    $body = $('body')

    if get_params().watch?
        $body.css('background', 'white')

        set_interval 1000, ->
            $.ajax
                type: 'GET'
                url: 'http://10.0.1.13:8888'
                success: (data) ->
                    $body.empty()
                    for f in data.files
                        image = new Image()
                        $body.append("<img src='#{f}?v=#{Math.random()}'>")
                    

    else
        client_id = uuid()
        $body.bind(EVENTS, -> capture())

        capture = _.throttle( ->
            html2canvas $body, onrendered: (canvas) ->
                data_url = canvas.toDataURL()
                $.ajax(
                    type: 'POST'
                    url: 'http://10.0.1.13:8888'
                    data:
                        canvas_url: data_url
                        client_id: client_id
                )
                return
        , 1000, {leading: false})

