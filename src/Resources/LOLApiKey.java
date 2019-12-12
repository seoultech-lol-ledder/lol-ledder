package Resources;	

import net.rithms.riot.api.ApiConfig;

public class LOLApiKey{
	//api key ¼³Á¤
	private ApiConfig cfg;
	public LOLApiKey(){
		 cfg = new ApiConfig().setKey("RGAPI-3368a3a3-7a87-435c-8352-fdad19159e6e");
	}
	public ApiConfig getConfig() {
		return this.cfg;
	}
 }