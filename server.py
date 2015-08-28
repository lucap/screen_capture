import re
import os
import glob

import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.add_header('Access-Control-Allow-Origin', '*')
        files = glob.glob('output/*.png')
        self.write({'files': files})

    def post(self):
        self.add_header('Access-Control-Allow-Origin', '*')
        data = self.get_argument('canvas_url')
        client_id = self.get_argument('client_id')
        if data and client_id:
            imgstr = re.search(r'base64,(.*)', data).group(1)
            file_location = os.path.join('output', client_id + '.png')

            with open(file_location, 'wb') as f:
                f.write(imgstr.decode('base64'))


application = tornado.web.Application([
    (r"/", MainHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.current().start()
