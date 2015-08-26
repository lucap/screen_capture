
EVENTS = "blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup  mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error"

uuid = ->
    #https://gist.github.com/bmc/1893440
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else (r & 0x3|0x8)
        v.toString(16)
    )

$ ->
    $body = $('body')
    client_id = uuid()
    $body.bind(EVENTS, ->
      capture()
      return
    )

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

