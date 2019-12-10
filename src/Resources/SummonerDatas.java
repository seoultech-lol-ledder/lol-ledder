package Resources;	

public class SummonerDatas{
	private String name;//이름
	private String accountId; //계정id
	private String id; //소환사id
	private long summonerLevel; //레벨 
	private int profileIconId; //
	
	private String leagueName; //리그명
	private int leaguePoints; //리그포인트
	private String rank; //랭크
	private String tier; //티어
	private int win; //랭크승리 
	private int losses; //랭크패배
	 
	private int championId; //챔피언아이디
	private int kill; //킬
	private int death; //데스
	private int assist; //어시
	private String championName; //챔피언명
	private String image; //이미지
	
	private int totalGame; //총게임수
	private int participateId; //참가자아이디
	
	private int rankPoint;
	
	public int getTotalGame() {
		return totalGame;
	}
	public int getParticipateId() {
		return participateId;
	}
	public void setParticipateId(int participateId) {
		this.participateId = participateId;
	}
	public void setTotalGame(int totalGame) {
		this.totalGame = totalGame;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public long getSummonerLevel() {
		return summonerLevel;
	}
	public void setSummonerLevel(long summonerLevel) {
		this.summonerLevel = summonerLevel;
	}
	public int getProfileIconId() {
		return profileIconId;
	}
	public void setProfileIconId(int profileIconId) {
		this.profileIconId = profileIconId;
	}
	public String getLeagueName() {
		return leagueName;
	}
	public void setLeagueName(String leagueName) {
		this.leagueName = leagueName;
	}
	public int getLeaguePoints() {
		return leaguePoints;
	}
	public void setLeaguePoints(int leaguePoints) {
		this.leaguePoints = leaguePoints;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getTier() {
		return tier;
	}
	public void setTier(String tier) {
		this.tier = tier;
	}
	public int getWin() {
		return win;
	}
	public void setWin(int win) {
		this.win = win;
	}
	public int getLosses() {
		return losses;
	}
	public void setLosses(int losses) {
		this.losses = losses;
	}
	public int getChampionId() {
		return championId;
	}
	public void setChampionId(int championId) {
		this.championId = championId;
	}
	public int getKill() {
		return kill;
	}
	public void setKill(int kill) {
		this.kill = kill;
	}
	public int getDeath() {
		return death;
	}
	public void setDeath(int death) {
		this.death = death;
	}
	public int getAssist() {
		return assist;
	}
	public void setAssist(int assist) {
		this.assist = assist;
	}
	public String getChampionName() {
		return championName;
	}
	public void setChampionName(String championName) {
		this.championName = championName;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public int getRankPoint() {
		return rankPoint;
	}
	public void setRankPoint(String rank, String tier, int leaguePoints ) {
		int point = 0;
		switch(tier) {
		case "CHALLENGER":
			point += 8000;
			break;
		case "GRAND_MASTER":
			point += 7000;
			break;
		case "MASTER":
			point += 6000;
			break;
		case "DIAMOND":
			point += 5000;
			break;
		case "PLATUNUM":
			point += 4000;
			break;
		case "GOLD":
			point += 3000;
		case "SHILBER":
			point += 2000;
			break;
		case "BRONZE":
			point += 1000;
			break;
		case "IRON":
			point += 0;
			break;
		}
		
		switch(rank) {
		case "I":
			point += 800;
			break;
		case "II":
			point += 600;
			break;
		case "III":
			point += 400;
			break;
		case "IV":
			point += 200;
			break;
		case "V":
			point += 0;
			break;
		}
		
		point += leaguePoints;
		this.rankPoint = point;
	}
 }