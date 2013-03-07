package tower

import grails.converters.JSON
import grails.converters.XML

class MessageController {
	
	def index() {
		def now = new Date()
		def messages = Message.findAllByDateCreatedGreaterThan(now - 1).sort{a,b -> b.getDuration().compareTo(a.getDuration())}
		def mapByHost = messages.inject([:]) { map, message ->
			def messagesByHost = map[message.host]
			if (!messagesByHost) {
				messagesByHost = []
			}
			map[message.host] = messagesByHost << message
			return map
		}
		// Limit the result set to the top 20 longest requests
		mapByHost.each {
			def limit = it.value.size() > 20 ? 19 : (it.value.size - 1)
			it.value = it.value[0..limit]
		}
		[messages: mapByHost]
	}

    def list() {
        def messages = Message.list();
		withFormat {
			html { render messages as JSON }
			json { render messages as JSON }
			xml { render messages as XML }
		}
    }
	
	def status() {
		def config = this.getConfig(params.host)
		render(template: "message", model: [messageId: params.messageId, config: config], contentType: "text/javascript")
	}
	
	def toggle() {
		def config = this.getConfig(params.host)
		config.enabled = !config.enabled
		config.save(flush:true)
		
		log.info("Monitoring ${config.enabled ? 'activated' : 'deactivated'} for host ${config.host}")
		render(template: "message", model: [messageId: params.messageId, config: config], contentType: "text/javascript")
	}
	
	def create() {
		log.info("Message received " + params)
		def query = params.url.tokenize("?")
		def message = new Message()
		message.host = params.host
		message.source = params.source
		message.url = query[0]
		message.params = query.size() > 1 ? query[1] : null
		message.status = params.status
		message.requestSent = params.requestSent as Long
		message.responseReceived = params.responseReceived as Long
		message.save()
		render(template: "message", model: [messageId: params.messageId, config: this.getConfig(message.host)], contentType: "text/javascript")
	}
	
	private Config getConfig(String host) {
		def config = Config.findByHost(host)
		if (!config) {
			config = new Config()
			config.host = host
			config.enabled = false
		}
		return config
	}
	
}
