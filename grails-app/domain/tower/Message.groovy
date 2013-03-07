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
	
	Double duration
	
	static transients = ['duration']
	
    static constraints = {
		params nullable:true
    }
	
	static mapping = {
		table 'tower_message'
	}
	
	public Double getDuration() {
		if (!this.duration) {
			this.duration = (this.responseReceived - this.requestSent)/1000.0
		}
		return this.duration
	}
	
}
