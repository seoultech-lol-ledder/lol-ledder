package Resources;	

import net.rithms.riot.api.ApiConfig;

public class LOLApiKey{
	//api key ¼³Á¤
	private ApiConfig cfg;
	public LOLApiKey(){
		 cfg = new ApiConfig().setKey("RGAPI-5d8505a9-7f46-48f9-848d-0acf1198afe6");
	}
	public ApiConfig getConfig() {
		return this.cfg;
	}
 }