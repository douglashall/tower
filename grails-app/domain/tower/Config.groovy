package tower

import java.util.Date;

class Config {

	String host
	boolean enabled
	Date dateCreated
	Date lastUpdated
	
    static constraints = {
    }
	
	static mapping = {
		table 'tower_config'
	}
	
}
