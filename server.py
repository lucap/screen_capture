import re

import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")

    def post(self):
        self.add_header('Access-Control-Allow-Origin', '*')
        data = self.get_argument('canvas_url')
        if data:
            imgstr = re.search(r'base64,(.*)', data).group(1)
            output = open('output.png', 'wb')
            output.write(imgstr.decode('base64'))
            output.close()


application = tornado.web.Application([
    (r"/", MainHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.current().start()
