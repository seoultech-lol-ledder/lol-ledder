package Resources;	

import net.rithms.riot.api.ApiConfig;

public class LOLApiKey{
	//api key ����
	private ApiConfig cfg;
	public LOLApiKey(){
		 cfg = new ApiConfig().setKey("RGAPI-393ea703-3e0f-45c7-a377-a0e36836e8bd");
	}
	public ApiConfig getConfig() {
		return this.cfg;
	}
 }