package tower

class Message {

	String host
	String source
	String url
	String params
	String status
	Long requestSent
	Long responseReceived
	Date dateCreated
	Date lastUpdated
	
    static constraints = {
		params nullable:true
    }
	
	static mapping = {
		table 'tower_message'
	}
	
}
