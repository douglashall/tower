$(document).ready(function(){
    var messageId = 1;
    var handleRequest = function(xhr) {
        var now = new Date();
        xhr.towerMessage = {
            messageId: messageId++,
            requestSent: now.getTime()
        };
    };
    var handleResponse = function(url, status, xhr) {
        if ($('.tower-active').html() != 'true') return;
        var now = new Date();
        xhr.towerMessage.responseReceived = now.getTime();
        xhr.towerMessage.url = url;
        xhr.towerMessage.host = window.location.host;
        xhr.towerMessage.source = window.location.href;
        xhr.towerMessage.status = status;
        $('.tower-scripts').append('<div id="message-' + xhr.towerMessage.messageId + '"><script src="${grailsApplication.config.grails.serverURL}/message/create?' + $.param(xhr.towerMessage) + '"></script></div>');
    };
    
    $('body').append('<div class="tower-active" style="display:none;">false</div>');
    $('body').append('<div class="tower-scripts" style="display:none;"></div>');
    $('.tower-scripts').append('<div id="message-' + messageId + '"><script src="${grailsApplication.config.grails.serverURL}/message/status?host=' + window.location.host + '&messageId=' + messageId++ + '"></script></div>');
    $(document).keydown(function(event){
        if (event.which == 84 && event.ctrlKey) {
            if (window.confirm('Monitoring is ' + ($('.tower-active').html() == 'true' ? 'enabled. Disable?' : 'disabled. Enable?'))) {
                $('.tower-scripts').append('<div id="message-' + messageId + '"><script src="${grailsApplication.config.grails.serverURL}/message/toggle?host=' + window.location.host + '&messageId=' + messageId++ + '"></script></div>');
            }
        }
    });
    $(document).ajaxSend(function(event, jqxhr, options){
        handleRequest(jqxhr);
    });
    $(document).ajaxComplete(function(event, jqxhr, options){
    	 handleResponse(options.url, jqxhr.status, jqxhr);
    });
    if (typeof Ext !== 'undefined') {
        Ext.Ajax.on('beforerequest', function(conn, options, eOpts){
            handleRequest(conn);
        });
        Ext.Ajax.on('requestcomplete', function(conn, options, eOpts){
            handleResponse(options.request.options.url, options.status, conn);
        });
    }
});
