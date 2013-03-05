package tower

import grails.converters.JSON
import grails.converters.XML

class MessageController {

    def list() {
        def messages = Message.list();
		withFormat {
			html { render messages as JSON }
			json { render messages as JSON }
			xml { render messages as XML }
		}
    }
	
	def toggle() {
		log.info("Monitoring " + (grailsApplication.config.tower.active ? "deactivated" : "activated"))
		grailsApplication.config.tower.active = !grailsApplication.config.tower.active
		render(template: "message", model: [messageId: params.messageId], contentType: "text/javascript")
	}
	
	def create() {
		log.info("Message received " + params)
		def query = params.url.tokenize("?")
		def message = new Message()
		message.source = params.source
		message.url = query[0]
		message.params = query.size() > 1 ? query[1] : null
		message.status = params.status
		message.requestSent = params.requestSent as Long
		message.responseReceived = params.responseReceived as Long
		message.save(failOnError:true)
		render(template: "message", model: [messageId: params.messageId], contentType: "text/javascript")
	}
	
}
