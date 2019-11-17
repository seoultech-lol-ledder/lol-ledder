package Resources;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import net.rithms.riot.*;
import net.rithms.riot.api.ApiConfig;
import net.rithms.riot.api.RiotApi;
import net.rithms.riot.api.RiotApiException;
import net.rithms.riot.api.endpoints.summoner.dto.Summoner;
import net.rithms.riot.constant.Platform;
import net.rithms.riot.api.endpoints.match.*;
import net.rithms.riot.api.endpoints.match.dto.Match;
import net.rithms.riot.api.endpoints.match.dto.MatchList;
import net.rithms.riot.api.endpoints.match.dto.MatchReference;
import net.rithms.riot.api.endpoints.match.dto.Participant;
import net.rithms.riot.api.endpoints.match.dto.ParticipantIdentity;
import net.rithms.riot.api.endpoints.match.dto.ParticipantStats;
import net.rithms.riot.api.endpoints.match.dto.TeamStats;
import net.rithms.riot.api.endpoints.static_data.dto.Champion;
import net.rithms.riot.api.endpoints.champion.dto.ChampionList;
import net.rithms.riot.api.endpoints.league.*;
import net.rithms.riot.api.endpoints.league.methods.*;
import net.rithms.riot.api.endpoints.league.constant.*;
import net.rithms.riot.api.endpoints.league.dto.*;

public class testBean {
	
	public static void main(String[] args) throws RiotApiException {	
		//api key 설정
		ApiConfig config = new ApiConfig().setKey("RGAPI-f249484a-e771-47db-9fd2-16be2b1b7a4c");
		//api패스 설정
		RiotApi api = new RiotApi(config);
		//소환사 이름으로 소환사id값을 찾기위함
		Summoner summoner = api.getSummonerByName(Platform.KR, "돌입");
		
		String name = summoner.getName(); //소환사이름
		long acountId = summoner.getAccountId(); //계정 아이디
		long id = summoner.getId(); // 소환사 아이디
		long summonerLevel = summoner.getSummonerLevel(); //소환사 레벨
		int profileIconId = summoner.getProfileIconId(); //프로필아이콘아이디
		
		//최근 20경기에 대한 매치리스트
		MatchList matchList = api.getRecentMatchListByAccountId(Platform.KR, acountId);
		//리그리스트에 관련된 정보
		List<LeagueList> leagueList = api.getLeagueBySummonerId(Platform.KR, summoner.getId());
		//리그포지션에 관련된 정보
		Set<LeaguePosition> leaguePosition = api.getLeaguePositionsBySummonerId(Platform.KR, summoner.getId());
		//리그포지션의 경우 해쉬셋이므로 get()메소드를 사용할 수 없기때문에 어레이리스트로 바꿔서 저장하여 가져오기
		//이때 해쉬셋에 들어있는 정보는 객체.size()로 확인하기...int index = 객체.size();
		List<LeaguePosition> tempList = new ArrayList<LeaguePosition>(leaguePosition);
		//매치리스트와 관련된 레퍼런스들
		List<MatchReference> matchListRef = matchList.getMatches();		
		/*System.out.println("현재 리그 : " + leagueList.get(0).getName());//리그이름
		System.out.println("현재 티어 : " + leagueList.get(0).getTier());//티어정보*/
		//매치 스텟관련 정보들
		Match checkStats = api.getMatch(Platform.KR,matchListRef.get(0).getGameId());
		//List<Participant> partList = checkStats.getParticipants();
		//Champion champion = api.get

		String leagueName = tempList.get(0).getLeagueName();//리그이름
		int leaguePoints = tempList.get(0).getLeaguePoints();//리그포인트
		String rank = tempList.get(0).getRank();//현재랭크
		String tier = tempList.get(0).getTier();//현재티어
		int win = tempList.get(0).getWins();//승리횟수
		int losses = tempList.get(0).getLosses();//패배횟수
		
		int championId = checkStats.getParticipants().get(0).getChampionId();//챔피언아이디
		int kill = checkStats.getParticipants().get(0).getStats().getKills();//킬횟수
		int death = checkStats.getParticipants().get(0).getStats().getDeaths();//죽은횟수
		int assist = checkStats.getParticipants().get(0).getStats().getAssists();//어시스트
		List<MatchReference> temp = matchList.getMatches();
		Match temp2 = api.getMatch(Platform.KR, temp.get(0).getGameId());
		List<ParticipantIdentity> temp3 = temp2.getParticipantIdentities();
		List<TeamStats> temp4 = temp2.getTeams();
		
		System.out.println(temp2.getTeams());
		System.out.println(temp3);
		for(int i=0;i<20;i++){
			System.out.println(temp.get(i));
			System.out.println(temp.get(i).getGameId());
		}
		System.out.println(matchListRef);
		System.out.println(checkStats);
		System.out.println(checkStats.getParticipants().get(0));
	}
}