$ ->
    console.log 'ho'
    capture = ->
        console.log 'capturing'
        html2canvas $('body') , onrendered: (canvas) ->
            #$('body').append canvas
            data_url = canvas.toDataURL()
            $.ajax(
                type: 'POST'
                url: 'http://localhost:8888'
                data:
                    canvas_url: data_url)
            return

    setInterval(capture, 1000)



