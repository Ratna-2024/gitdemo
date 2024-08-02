const mysrvdemo = function(srv){
    srv.on('somesrv', (req, res) => {
        return "hey " + req.data.msg;
    });
}

module.exports = mysrvdemo;