package Resources;	

import net.rithms.riot.api.ApiConfig;

public class LOLApiKey{
	//api key ¼³Á¤
	private ApiConfig cfg;
	public LOLApiKey(){
		 cfg = new ApiConfig().setKey("RGAPI-fa1a25ea-fd30-4fa5-b779-5e846d56cfc5");
	}
	public ApiConfig getConfig() {
		return this.cfg;
	}
 }